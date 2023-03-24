package com.oti.team2.util.springsecurity;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Service;

import com.oti.team2.member.dto.Join;
import com.oti.team2.member.dto.Member;
import com.oti.team2.member.dto.Users;
import com.oti.team2.member.service.IJoinService;
import com.oti.team2.member.service.IMemberService;
import com.oti.team2.util.Auth;

import lombok.extern.log4j.Log4j2;

@Log4j2
@Service
public class GoogleService {
	@Autowired
	private IJoinService joinService;
	
	@Autowired
	private IMemberService memberService;
	
	
	public String getAuthURL() {
		log.info(" google login 들옴");
		String authURL = "https://accounts.google.com/o/oauth2/auth";
		authURL += "?client_id=384557297665-3n8abq0eana7g9igakohgfsiu1q57qh3.apps.googleusercontent.com";
		authURL += "&response_type=code";
		authURL += "&redirect_uri=http://localhost:8080/login/oauth2/google/callback";
		authURL += "&scope=https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile openid";
		return authURL;
	}		
	
	public String getAccessToken(String code) {
		String access_token = "";
		String refresh_token = "";
		
		try {
			String apiURL = "https://oauth2.googleapis.com/token";
			String reqMethod = "POST";
			String bodyData = "grant_type=authorization_code";
			bodyData += "&client_id=384557297665-3n8abq0eana7g9igakohgfsiu1q57qh3.apps.googleusercontent.com";
			bodyData += "&client_secret=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";
			bodyData += "&redirect_uri=http://localhost:8080/login/oauth2/google/callback";
			bodyData += "&code=" + code;
				
			//토큰을 요청한다.
			URL url = new URL(apiURL);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod(reqMethod);
			conn.setDoOutput(true);
			
			BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
			bw.write(bodyData);
			bw.flush();

			int responseCode = conn.getResponseCode();
			log.info("토큰 응답코드 : " + responseCode);
			
			BufferedReader br;
			if (responseCode == 200) { // 정상 호출
				br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			} else { // 에러 발생
				br = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
			}			
			
			String br_line = "";
			String resBody = "";
			while ((br_line = br.readLine()) != null) {
				resBody += br_line;
			}
			br.close();
			bw.close();
			
			if (responseCode == 200) {
				log.info(resBody);
				JSONObject root = new JSONObject(resBody);
				access_token = root.getString("access_token");
				log.info("access_token: " + access_token);			
			} else {
				throw new Exception(resBody);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return access_token;
	}

	public Users getUserInfo(String access_token) {
		Map<String, String> resultMap = new HashMap<>();
		Users user = null;
		
		try {
			String reqURL = "https://www.googleapis.com/oauth2/v2/userinfo";
			String reqMethod = "GET";
		
			URL url = new URL(reqURL);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			conn.setRequestProperty("Authorization", "Bearer " + access_token);

			int responseCode = conn.getResponseCode();
			log.info("사용자 응답코드 : " + responseCode);

			BufferedReader br;
			if (responseCode == 200) {
				br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			} else {
				br = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
			}			
			
			String br_line = "";
			String resBody = "";
			while ((br_line = br.readLine()) != null) {
				resBody += br_line;
			}
			br.close();

			if (responseCode == 200) {
				log.info(resBody);
				JSONObject root = new JSONObject(resBody);
				
				String id = root.getString("id");
				String name = root.getString("name");
				String email = root.getString("email");
				String picture = root.getString("picture");
				log.info("id: " + id);
				log.info("name: " + name);
				log.info("email: " + email);	
				
				Member member = memberService.isMember(email);
				List<GrantedAuthority> roles = new ArrayList<>();
				roles.add(new SimpleGrantedAuthority("ROLE_CLIENT"));
				// 비회원인 경우 회원가입 진행
				if(member == null) {
					log.info("비회원이므로 조인한다~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
					Join join = new Join();
					String randomPswd = UUID.randomUUID().toString().replaceAll("-", "");
					randomPswd = randomPswd.substring(0, 10);
					join.setMemberId(email);
					join.setPswd(joinService.getEncodedPassword(randomPswd));
					join.setFlnm(name);
					join.setEml(email);
					join.setMemberType(Auth.ROLE_CLIENT.toString());
					log.info(join);
					joinService.getJoin(join);
					 user = new Users(email, join.getPswd(),true, roles,
							 name, picture);
				}
				else {			      
			        user = new Users(member.getMemberId(), member.getPswd(),true, roles,
			        		member.getFlnm(), picture);
				}
				
				
			} else {
				throw new Exception(resBody);
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return user;
	}
}
