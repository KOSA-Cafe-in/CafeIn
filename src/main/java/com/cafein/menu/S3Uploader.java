package com.cafein.menu;

import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.ObjectMetadata;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.PostConstruct;
import java.io.IOException;
import java.util.UUID;

@Slf4j
@Component
public class S3Uploader {

    @Value("${cloud.aws.credentials.accessKey}")
    private String accessKey;
    @Value("${cloud.aws.credentials.secretKey}")
    private String secretKey;
    @Value("${cloud.aws.s3.bucket}")
    private String bucket;
    @Value("${cloud.aws.region.static}")
    private String region;

    private AmazonS3 s3Client;

    @PostConstruct
    public void initializeAmazon() {
        BasicAWSCredentials credentials = new BasicAWSCredentials(accessKey, secretKey);
        s3Client = AmazonS3ClientBuilder.standard()
                .withRegion(region)
                .withCredentials(new AWSStaticCredentialsProvider(credentials))
                .build();
    }

    public String upload(MultipartFile file, String dirName) throws IOException {
        String fileName = dirName + "/" + UUID.randomUUID() + "_" + file.getOriginalFilename();
        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentLength(file.getSize());
        metadata.setContentType(file.getContentType());
        s3Client.putObject(bucket, fileName, file.getInputStream(), metadata);
        return s3Client.getUrl(bucket, fileName).toString(); // S3 URL
    }

    // ✅ S3 객체 삭제 (URL을 받아 내부에서 key 추출)
    public void delete(String fileUrl) {
        try {
            String key = extractKeyFromUrl(fileUrl);
            s3Client.deleteObject(bucket, key);
            log.info("S3 객체 삭제 성공: bucket={}, key={}", bucket, key);
        } catch (Exception e) {
            // SLF4J placeholder 개수 오류 피하려고 문자열 더하기 사용
            log.error("S3 객체 삭제 실패: bucket=" + bucket + ", url=" + fileUrl, e);
        }
    }

    // ✅ URL에서 S3 key 추출
    private String extractKeyFromUrl(String url) {
        // 예: https://{bucket}.s3.{region}.amazonaws.com/menu/abc.jpg → menu/abc.jpg
        String base1 = "https://" + bucket + ".s3." + region + ".amazonaws.com/";
        String base2 = "https://s3-" + region + ".amazonaws.com/" + bucket + "/"; // 다른 형식 대비
        if (url.startsWith(base1)) return url.substring(base1.length());
        if (url.startsWith(base2)) return url.substring(base2.length());
        // 일반적인 경우가 아니면 마지막 '/' 뒤를 자르기(최후 수단)
        int idx = url.indexOf(".amazonaws.com/");
        return (idx > -1) ? url.substring(idx + ".amazonaws.com/".length() + bucket.length() + 1) : url;
    }
}
