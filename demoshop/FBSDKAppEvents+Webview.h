//
//  FBSDKAppEvents+Webview.h
//  demoshop
//
//  Created by Yu Li on 8/24/16.
//  Copyright © 2016 Yu Li. All rights reserved.
//

#ifndef FBSDKAppEvents_Webview_h
#define FBSDKAppEvents_Webview_h

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface FBSDKAppEvents(Webview)

+(BOOL)webView:(UIWebView *)webView supportPixelEventWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end

#endif /* FBSDKAppEvents_Webview_h */
