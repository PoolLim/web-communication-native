//
//  ViewController.swift
//  web-communication-ios
//
//  Created by Gadek Lim on 2022/03/17.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate,  WKScriptMessageHandler {
    let config = WKWebViewConfiguration()
    @IBOutlet weak var webview: WKWebView!


    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == "callbackHandler"){
            if(message.body as! String == "callNativeFunction"){
                print("called from javascript")
                
                let batteryLevel = floor(UIDevice.current.batteryLevel * 10000)/100
                
                let jsonObject:NSMutableDictionary = NSMutableDictionary()
                jsonObject.setValue(batteryLevel, forKey: "battery")
                let jsonData = try! JSONSerialization.data(withJSONObject: jsonObject)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as! String
                print(jsonString)
                
                
                webview.evaluateJavaScript("fromNative('\(jsonString)')", completionHandler: {(result, error) in
                                if let result = result {
                                    print(result)
                                }
                                if error != nil {
                                    print(error)
                                }
                            })
                

            }
        }
    }
    
    

    
    func goWeb()->(){
        let url = URL(string:"https://poollim.github.io/native-communication-react-web/")
        let request = URLRequest(url:url!)
        webview.load(request)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UIDevice.current.isBatteryMonitoringEnabled = true

        // js -> native call
        let contentController = self.webview.configuration.userContentController
        contentController.add(self, name: "callbackHandler")
  
//        webview.configuration.preferences.javaScriptEnabled = true
        webview.uiDelegate = self
        webview.navigationDelegate = self
        
        goWeb()
        print("didLoad")
    }


}

