//
//  WebView.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-27.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//


import WebKit
import Combine
import SwiftUI
import AppKit


public struct WebBrowserView {

    private let webView: WKWebView = WKWebView(frame: .zero)
    

    // ...

    public func load(url: URL) {
        print(url)
        webView.load(URLRequest(url: url))
    }
    
    public func getTitle () -> String {
        webView.title ?? "None"
    }

    public class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {

        var parent: WebBrowserView

        init(parent: WebBrowserView) {
            self.parent = parent
        }

        public func webView(_: WKWebView, didFail: WKNavigation!, withError: Error) {
            // ...
            print("webview error")
        }

        public func webView(_: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) {
            // ...
        }

        public func webView(_ webView: WKWebView, didFinish: WKNavigation!) {
            parent.didFinish(title: webView.title!)
        }

        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            // ...
        }

        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(.allow)
        }

        public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
            return nil
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}


#if os(macOS) // macOS Implementation (iOS version omitted for brevity)
extension WebBrowserView: NSViewRepresentable {

    public typealias NSViewType = WKWebView

    public func makeNSView(context: NSViewRepresentableContext<WebBrowserView>) -> WKWebView {

        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        return webView
    }

    public func updateNSView(_ nsView: WKWebView, context: NSViewRepresentableContext<WebBrowserView>) {

    }
    public func didFinish(title: String) {
        print(title)
    }
}

class ObservableWebView: NSObject, ObservableObject, WKNavigationDelegate {
    @Published var title: String = "Loading"
    @Published var isLoading: Bool = true
    private let webView = WKWebView(frame: .zero)
    
    public func load(url: URL){
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
     
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title" {
            if let title = webView.title {
                self.title = title
            }
        }
    }
    public func webView(_ webView: WKWebView, didFinish: WKNavigation!) {
        self.isLoading = false
        guard let title = webView.title else {
            self.title = "Error"
            return
        }
        if title.count > 2 {
            self.title = title
        } else {
            self.title = "-"
        }
    }
}

struct BrowserTitleView: View {
    var port: Int
    @ObservedObject var webView = ObservableWebView()
    var body: some View {
        AnyView(
            Text(self.webView.title)
        ).onAppear{
            self.webView.load(url: URL(string: "http://localhost:" + String(self.port))!)
        }
    }
}

struct BrowserView: View {
    private let browser = WebBrowserView()
    var port: Int

    var body: some View {
        HStack {
            browser
                .onAppear() {
                    self.browser
                        .load(url: URL(string: "http://localhost:" + String(self.port))!)
            }.frame(width:0,height: 0)


        }
        .padding()
    }
}
#endif
