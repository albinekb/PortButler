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
        }

        public func webView(_: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) {
            // ...
        }

        public func webView(_: WKWebView, didFinish: WKNavigation!) {
            // ...
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
}
#endif
