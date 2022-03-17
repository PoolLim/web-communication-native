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
                webview.evaluateJavaScript("fromNative('{\"browsers\":{\"firefox\":{\"name\":\"Firefox\",\"pref_url\":\"about:config\",\"releases\":{\"1\":{\"release_date\":\"2004-11-09\",\"status\":\"retired\",\"engine\":\"Gecko\",\"engine_version\":\"1.7\"}}}}}')", completionHandler: {(result, error) in
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

