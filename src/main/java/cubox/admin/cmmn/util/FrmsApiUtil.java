package cubox.admin.cmmn.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import net.sf.json.JSONException;

public class FrmsApiUtil {

	private static FrmsApiUtil instance;
	
	private static String GLOBAL_API_URL = System.getenv("FRS_API_URL");//CuboxProperties.getProperty("Globals.api.url");
	private static String GLOBAL_API_KEY = System.getenv("FRS_API_KEY");//CuboxProperties.getProperty("Globals.api.key");	

	static {
		instance = new FrmsApiUtil();
	}
	
	public static FrmsApiUtil getInstance() {
		return instance;
	}

	private static final Logger LOGGER = LoggerFactory.getLogger(FrmsApiUtil.class);    
	
	public static HashMap<String, Object> getFrmsApiReq(String reqBody, String action, String method){

		String InputLine = "";
		String responseBody = "";
		HashMap<String, Object> result = new HashMap<String, Object>();
		HttpURLConnection restConn = null;
		
		String url = GLOBAL_API_URL + action;
		LOGGER.debug("###[FrmsApiUtil] 0) url : {}, method : {}", url, method);
		
		try {
			/*
			String username = GLOBAL_PARKING_API_ID;
			String password = GLOBAL_PARKING_API_PASSWORD;
			
			String auth = username + ":" + password;
			byte[] encodedAuth = Base64.encodeBase64(auth.getBytes(StandardCharsets.UTF_8));
			String authHeaderValue = new String(encodedAuth);
			*/
			
			URL Url = new URL(url);
			restConn = (HttpURLConnection) Url.openConnection();
			restConn.setDoOutput(true);
			restConn.setRequestMethod(method);
			restConn.setRequestProperty("Content-Type", "application/json");
			restConn.setRequestProperty("Accept-Charset", "UTF-8"); 
			//restConn.setRequestProperty("Authorization", authHeaderValue);
			restConn.setRequestProperty("Admin-Api-Key", GLOBAL_API_KEY);
			restConn.setConnectTimeout(50000);
			restConn.setReadTimeout(50000);
			
			OutputStream restOs = restConn.getOutputStream();
			restOs.write(reqBody.getBytes("UTF-8"));
			restOs.flush();

			int responseCode = restConn.getResponseCode();  //200:정상, 200외:에러
			
			LOGGER.debug("###[FrmsApiUtil] 1) responseCode : {}", responseCode);

			// 리턴된 결과 읽기
			InputStreamReader isr = null;
			if(responseCode == 200) {
				LOGGER.debug("###[FrmsApiUtil] 1-1) getInputStream : {}", restConn.getInputStream());
				isr = new InputStreamReader(restConn.getInputStream(), "UTF-8");
				
				BufferedReader matchIn = new BufferedReader(isr);
				while ((InputLine = matchIn.readLine()) != null) {
					responseBody += InputLine;
				}
				
				LOGGER.debug("###[FrmsApiUtil] 2) responseBody : {}", responseBody);
				
				JSONParser parser = new JSONParser();
				Object obj = parser.parse(responseBody);
				result = (HashMap<String, Object>) CommonUtils.getMapFromJsonObject((JSONObject) obj);
				
				LOGGER.debug("###[FrmsApiUtil] 3) result : {}", result);
				
			} else {
				LOGGER.debug("###[FrmsApiUtil] 1-2) getErrorStream : {}", restConn.getErrorStream());
				// 에러 처리가 명확하지 않음
				if(restConn.getErrorStream() != null) { 
					isr = new InputStreamReader(restConn.getErrorStream(), "UTF-8");
				}
				
				if(isr != null) {
					BufferedReader matchIn = new BufferedReader(isr);
					while ((InputLine = matchIn.readLine()) != null) {
						responseBody += InputLine;
					}
				}
				
				LOGGER.debug("###[FrmsApiUtil] 2-1) responseBody : {}", responseBody);

				if(responseBody != null) {
					JSONParser parser = new JSONParser();
					Object obj = parser.parse(responseBody);
					result = (HashMap<String, Object>) CommonUtils.getMapFromJsonObject((JSONObject) obj);
				}
				
				LOGGER.debug("###[FrmsApiUtil] 3-1) result : {}", result);
			}
			
			result.put("responseCode", responseCode);

		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (JSONException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(restConn != null) restConn.disconnect();
		}
		
		return result;
	}

}
