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
	
	private static String frsApiUrl = System.getenv("FRS_API_URL");
	private static String frsApiKeyAdmin = System.getenv("FRS_API_KEY_ADMIN");	
	private static String frsApiKey = System.getenv("FRS_API_KEY");	

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
		
		String url = frsApiUrl + action;
		LOGGER.debug("###[FrmsApiUtil] 0) url : [{}] {}", method, url);
		
		try {
			
			URL Url = new URL(url);
			restConn = (HttpURLConnection) Url.openConnection();
			restConn.setDoOutput(true);
			restConn.setRequestMethod(method);
			restConn.setRequestProperty("Accept-Charset", "UTF-8");			
			restConn.setRequestProperty("Content-Type", "application/json");
			restConn.setRequestProperty("Admin-Api-Key", frsApiKeyAdmin);
			restConn.setRequestProperty("X-Api-Key", frsApiKey);
			restConn.setConnectTimeout(50000);
			restConn.setReadTimeout(50000);
			
			OutputStream restOs = restConn.getOutputStream();
			restOs.write(StringUtil.nvl(reqBody).getBytes("UTF-8"));
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
