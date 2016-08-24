//
//  WebviewController.m
//  demoshop
//
//  Created by Yu Li on 8/24/16.
//  Copyright © 2016 Yu Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "FBSDKAppEvents+Webview.h"
#import "WebviewController.h"

@implementation WebviewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.    
    self.webView.delegate = self;
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://104.236.187.180/demoshop/index.php"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([FBSDKAppEvents webView:webView supportPixelEventWithRequest:request navigationType:navigationType]) {
        return NO;
    }
    return YES;
}

@end