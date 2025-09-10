package com.cafein.payment;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

@Service
public class PaymentService {

    @Value("${portone.api.key}")
    private String IMP_KEY;

    @Value("${portone.api.secret}")
    private String IMP_SECRET;

    @Value("${portone.api.url}")
    private String PORTONE_API_URL;

    private RestTemplate restTemplate = new RestTemplate();

    // 결제 검증
    public PaymentDTO verifyPayment(String impUid) {
        try {
            // 1. 액세스 토큰 발급
            String accessToken = getAccessToken();

            // 2. 결제 정보 조회
            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", "Bearer " + accessToken);
            headers.set("Content-Type", "application/json");

            HttpEntity<String> entity = new HttpEntity<>(headers);

            String url = PORTONE_API_URL + "/payments/" + impUid;
            ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET, entity, String.class);

            // 3. 응답 파싱
            Gson gson = new Gson();
            JsonObject jsonResponse = gson.fromJson(response.getBody(), JsonObject.class);
            JsonObject paymentData = jsonResponse.getAsJsonObject("response");

            PaymentDTO payment = new PaymentDTO();
            payment.setImpUid(paymentData.get("imp_uid").getAsString());
            payment.setMerchantUid(paymentData.get("merchant_uid").getAsString());
            payment.setAmount(paymentData.get("amount").getAsLong());
            payment.setStatus(paymentData.get("status").getAsString());
            payment.setBuyerName(paymentData.get("buyer_name").getAsString());
            payment.setBuyerEmail(paymentData.get("buyer_email").getAsString());
            payment.setBuyerTel(paymentData.get("buyer_tel").getAsString());
            payment.setName(paymentData.get("name").getAsString());
            payment.setPaymentMethod(paymentData.get("pay_method").getAsString());
            payment.setPgProvider(paymentData.get("pg_provider").getAsString());
            payment.setPgTid(paymentData.get("pg_tid").getAsString());
            payment.setReceiptUrl(paymentData.get("receipt_url").getAsString());
            
            Date now = new Date();
            SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
            payment.setCreatedDate(fmt.format(now));

            return payment;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // 액세스 토큰 발급
    private String getAccessToken() {
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.set("Content-Type", "application/json");

            Map<String, String> requestBody = new HashMap<>();
            requestBody.put("imp_key", IMP_KEY);
            requestBody.put("imp_secret", IMP_SECRET);

            Gson gson = new Gson();
            String jsonBody = gson.toJson(requestBody);

            HttpEntity<String> entity = new HttpEntity<>(jsonBody, headers);

            String url = PORTONE_API_URL + "/users/getToken";
            ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, entity, String.class);

            JsonObject jsonResponse = gson.fromJson(response.getBody(), JsonObject.class);
            JsonObject responseData = jsonResponse.getAsJsonObject("response");

            return responseData.get("access_token").getAsString();

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // 고유한 주문번호 생성
    public String generateMerchantUid() {
        return "order_" + System.currentTimeMillis() + "_" + UUID.randomUUID().toString().substring(0, 8);
    }

    // 결제 취소
    public boolean cancelPayment(String impUid, String reason) {
        try {
            String accessToken = getAccessToken();

            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", "Bearer " + accessToken);
            headers.set("Content-Type", "application/json");

            Map<String, String> requestBody = new HashMap<>();
            requestBody.put("imp_uid", impUid);
            requestBody.put("reason", reason);

            Gson gson = new Gson();
            String jsonBody = gson.toJson(requestBody);

            HttpEntity<String> entity = new HttpEntity<>(jsonBody, headers);

            String url = PORTONE_API_URL + "/payments/cancel";
            ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, entity, String.class);

            JsonObject jsonResponse = gson.fromJson(response.getBody(), JsonObject.class);
            return jsonResponse.get("code").getAsInt() == 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
