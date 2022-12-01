package com.ncs.green;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class GongController {
	
	@RequestMapping(value = "/gong")
	public ModelAndView gong(ModelAndView mv) throws IOException {
		
		StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/3780000/smr_api/voucherSale"); /*URL*/
	    //  성남사랑상품권 판매 현황 :  http://apis.data.go.kr/3780000/smr_api/voucherSale
		//  가맹점 : http://apis.data.go.kr/3780000/smr_api/voucherShop    
	    // 2. 오픈 API의요청 규격에 맞는 파라미터 생성, 발급받은 인증키 적용.
	    urlBuilder.append("?serviceKey=uNWCbDCtK48EjlWlA9IG6m1kzHzVMW2n0RMppqjBMBandHI4MizspWYzzvG8jpburcpE73MY5eQqh8FBNZs5ww%3D%3D"); /*Service Key*/
	    //urlBuilder.append("&searchArea=1"); /*지역 구분코드 (전체:0, 분당구:1, 수정구:2, 중원구:3)*/
	    urlBuilder.append("&" + URLEncoder.encode("searchArea","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8"));
	    // => urlEncode: 필요시에만 사용하면 됨 -> 요즘엔 이미 Encode 된 키를제공하기때문에 30행 처럼 안해도 됨. 
	    urlBuilder.append("&searchMonth=202101");  //판매현황 조회 년월 -> voucherSale Test 시 필요    
	    
	    // ** 요청
	    // 3. URL 객체 생성.
	    URL url = new URL(urlBuilder.toString());
	    // 4. 요청하고자 하는 URL과 통신하기 위한 Connection 객체 생성.
	    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	    // 5. 통신을 위한 메소드 SET.
	    conn.setRequestMethod("GET");
	    // 6. 통신을 위한 Content-type SET. 
	    conn.setRequestProperty("Content-type", "application/json");
	    
	    // ** 응답 & 응답 결과 처리
	    // 7. 통신 응답 코드 확인.
	    System.out.println("Response code: " + conn.getResponseCode());
	    
	    // 8. 전달받은 데이터를 BufferedReader 객체로 저장.
	    BufferedReader rd;
	    if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
	        rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	    } else {
	        rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
	    }
	    // 9. 저장된 데이터를 라인별로 읽어 StringBuilder 객체로 저장.
	    StringBuilder sb = new StringBuilder();
	    String line;
	    while ((line = rd.readLine()) != null) {
	        sb.append(line);
	    }
	    // 10. BufferedReader 객체 해제.
	    rd.close();
	    conn.disconnect();
	    
	    // 11. 전달받은 데이터 확인.
	    // => Console 에서 줄바꿈이 안되면 우클릭 후 팝업메뉴에서 -> Word Wrap 을 선택
	    //System.out.println(sb.toString());
	    // => 성남사랑상품권 판매 현황 Test 시에 출력하면 이클립스 다운될수있음 (/voucherSale)
	    
	    // ** 전달된 자료를 JSON 형태로 변환 
	    // => 현재 sb 에 저장된 자료는 문자형태로 되어있지만, 
	    //    API 문서의 데이터 표준은 JSON 이므로 JSON 형태로 변환해야 사용가능함  
	    // => 이를 위해 json-simple 사용
	    // => json-simple 이란?
	    //	  JSON 데이터를 처리하기 위한 자바 라이브러리
	    //
	    // => json-simple 특징
	    //	  1.json-simple은 내부적으로 JSON 데이터를 처리하기 위해 Map과 List를 사용.
	    //	  2.json-simple은 JSON 데이터를 구문 분석하고 이를 파일에 기록할 수 있음.
	    //	  3.json-simple의 가장 큰 특징은 타사 라이브러리에 대한 의존성이 없음.
	    //	  4.json-simple는 매우 가벼운 API이며 간단한 JSON 데이터를 처리하기 위해 적합.
	    
	    // => json-simple 주요 클래스
	    //	  1. org.json.simple Class JSONObejct
	    //	   -> JSON 객체를 추상화한 클래스로, java.util.HashMap 클래스를 상속받고 있으므로
	    //	      대부분의 메소드가 HashMap 클래스로부터 상속받고 있음.
	    //	  2. org.json.simple Class JSONArray
	    //	   -> JSON 배열을 추상화한 클래스로, java.util.ArrayList 클래스를 상속하고 있으므로
	    //	      메소드 사용 방법은 대부분 ArrayList와 거의 흡사함.
	    //	  3. org.json.simple Class JSONParser
	    //	   -> JSON 데이터를 파싱하는 기능을 구현한 클래스.
	    //	  4. org.json.simple Class JSONValue
	    //	   -> JSON 데이터를 다루기 위한 몇 가지 메소드를 제공.
	    //	  5. org.json.simple Class JSONException
	    //	   -> JSONParser 클래스를 사용해서 파싱할 때 발생할 수 있는 예외 사항을 추상화한 클래스. 
	    // => pom 설정
		//		<dependency>
		//			<groupId>com.googlecode.json-simple</groupId>
		//			<artifactId>json-simple</artifactId>
		//			<version>1.1.1</version>
	    //		</dependency> 	    
	    
	    // 1. 문자열 형태의 JSON을 파싱하기 위한 JSONParser 객체 생성.
	    JSONParser parser = new JSONParser();
	    JSONObject obj = null;
	    
	    // 2. JSON 을 파싱 : 문자열을 JSON 형태로 JSONObject 객체에 저장. 	
	    try {
	    	 obj = (JSONObject)parser.parse(sb.toString());  // Checked Exception
		} catch (ParseException e) {
			 System.out.println("변환(파싱) 실패");
	        e.printStackTrace();
		}
	           
	    // 3. 필요한 자료들을 타입별로 가져와 사용하기 
	    // => 전달된 결과 sb.toString()
	    //    {"totalCount":"76","resultCode":"0","resultMsg":"OK","data":[{...},{..},...]}
	    //      key :  value,     key      :value,...    
	    // => 이들중 key data 의 value 는 JSON 의 배열[]타입 이고, 이것은 Java 에서는 List 로 표현됨.
	    System.out.println("** Parsing Test **");
	    String totalCount = (String)obj.get("totalCount");
	    System.out.println("** totalCount => "+totalCount);
	    
	    List list = (ArrayList)obj.get("data");
	    System.out.println("** List => "+list.get(0)); 
	    
	    JSONArray dataArr = (JSONArray)obj.get("data");  
	    // 데이터 부분만 가져와 JSONArray (JSON 의 배열)로 저장.
	    System.out.println("** JSONArray dataArr 0 => "+dataArr.get(0));
	    System.out.println("** JSONArray dataArr 1 => "+dataArr.get(1));
	    
	    // ** Jsp 사용시 model에 담아준다.
	    mv.addObject("list", list);
	    mv.addObject("data", dataArr);
		
		mv.setViewName("axTest/gongTest");
		return mv;
	} //gong	

} // class
