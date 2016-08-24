//
//  WebviewController.h
//  demoshop
//
//  Created by Yu Li on 8/24/16.
//  Copyright © 2016 Yu Li. All rights reserved.
//

#ifndef WebviewController_h
#define WebviewController_h

#import <UIKit/UIKit.h>

@interface WebviewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

#endif /* WebviewController_h */
