package com.example.web_communication_android;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Bundle;
import android.webkit.JavascriptInterface;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import org.json.JSONException;
import org.json.JSONObject;

public class MainActivity extends AppCompatActivity {
  private WebView mWebView; // 웹뷰 선언
  private WebSettings mWebSettings; //웹뷰세팅


  @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

      // 웹뷰 시작
      mWebView = (WebView) findViewById(R.id.webView);

      mWebView.setWebViewClient(new WebViewClient()); // 클릭시 새창 안뜨게
      mWebSettings = mWebView.getSettings(); //세부 세팅 등록
      mWebSettings.setJavaScriptEnabled(true); // 웹페이지 자바스클비트 허용 여부
      mWebSettings.setSupportMultipleWindows(false); // 새창 띄우기 허용 여부
      mWebSettings.setJavaScriptCanOpenWindowsAutomatically(false); // 자바스크립트 새창 띄우기(멀티뷰) 허용 여부
      mWebSettings.setLoadWithOverviewMode(true); // 메타태그 허용 여부
      mWebSettings.setUseWideViewPort(true); // 화면 사이즈 맞추기 허용 여부
      mWebSettings.setSupportZoom(false); // 화면 줌 허용 여부
      mWebSettings.setBuiltInZoomControls(false); // 화면 확대 축소 허용 여부
      mWebSettings.setLayoutAlgorithm(WebSettings.LayoutAlgorithm.SINGLE_COLUMN); // 컨텐츠 사이즈 맞추기
      mWebSettings.setCacheMode(WebSettings.LOAD_NO_CACHE); // 브라우저 캐시 허용 여부
      mWebSettings.setDomStorageEnabled(false); // 로컬저장소 허용 여부

      mWebView.loadUrl("https://poollim.github.io/native-communication-react-web/"); // 웹뷰에 표시할 웹사이트 주소, 웹뷰 시작

      mWebView.addJavascriptInterface(new WebAppInterface(), "Android");
    }

  class WebAppInterface {
    @JavascriptInterface
    public String callNativeFunction(){
      return getBatteryLevel();
    }

    public String getBatteryLevel() {
      Intent batteryIntent = registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
      int level = batteryIntent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1);
      int scale = batteryIntent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);


      float batteryLevel =  ((float)level / (float)scale) * 100.0f;
      JSONObject batteyJson = new JSONObject();
      try {
        batteyJson.put("battery", batteryLevel);

      } catch (JSONException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }

      return batteyJson.toString();
    }
  }
}




