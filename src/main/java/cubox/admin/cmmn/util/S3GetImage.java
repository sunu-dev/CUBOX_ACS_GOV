package cubox.admin.cmmn.util;

import java.io.IOException;
import java.io.InputStream;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.GetObjectRequest;
import com.amazonaws.services.s3.model.S3Object;

public class S3GetImage {

	private static String accessKey = System.getenv("FRS_S3_accessKey");
	private static String secretKey = System.getenv("FRS_S3_secretKey");
	private static String bucketName = System.getenv("FRS_S3_bucketName");
	
	private static final Logger LOGGER = LoggerFactory.getLogger(S3GetImage.class);
	
	//s3://cu-pdteam-bucket/s01/
	public static byte[] getImage(String filePath) {

		AWSCredentials credentials = new BasicAWSCredentials(accessKey, secretKey);

        AmazonS3 s3 = AmazonS3ClientBuilder.standard()
		        .withCredentials(new AWSStaticCredentialsProvider(credentials))
		        .withRegion(Regions.AP_NORTHEAST_2)
		        .build();

        //LOGGER.debug("###[getImage] filePath : {}", filePath);
        S3Object object = s3.getObject(new GetObjectRequest(bucketName, filePath));
        
	    InputStream in = object.getObjectContent();
	    byte[] byteArray = null;
	    
		try {
			byteArray = IOUtils.toByteArray(in);
		} catch (IOException e) {
			e.printStackTrace();
		}
	    
	    return byteArray;
	}	
}
