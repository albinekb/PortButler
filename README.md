<p align="center">
  <h3 align="center">PortButler</h3>
  <p align="center">An open-source macOS menubar app using netstat</p>
</p>
<p align="center">
  <img align="center" width="387.5px" height="230px" alt="Screenshot" src="https://github.com/albinekb/PortButler/raw/master/.github/preview.png" />
</p>

# About

This app shows running servers on localhost posts

- Currently hard-coded to look at servers between `2999-4999`
- Checks servers using `netstat`, very fast
- Loads page in `WKWebView` to get title, webview is destroyed after to save memory

# Installing

There's no build available yet, but it should be easy to clone and build with Xcode.

1. Clone and open project in xcode
1. Click product -> Archive
1. Publish app, select "export"
