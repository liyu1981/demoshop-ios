//
//  AppDelegate.m
//  demoshop
//
//  Created by Yu Li on 2/5/16.
//  Copyright © 2016 Yu Li. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import "RegExCategories.h"
#import <Bolts/Bolts.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <AdSupport/ASIdentifierManager.h>

@interface AppDelegate () <UISplitViewControllerDelegate> {
    NSMutableSet *_categories;
}

@end

@implementation AppDelegate

@synthesize cart;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (launchOptions[UIApplicationLaunchOptionsURLKey] == nil) {
        [FBSDKAppLinkUtility fetchDeferredAppLink:^(NSURL *url, NSError *error) {
            NSUUID* adId = [[ASIdentifierManager sharedManager] advertisingIdentifier];
            NSString* s = [NSString stringWithFormat:@"DEEPLINK: %@, Device ADID: %@", [url absoluteString], [adId UUIDString]];
            if (error) {
                NSLog(@"Received error while fetching deferred app link %@", error);
            }
            if (url) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Got deferred deeplink"
                                                                               message:s
                                                                        preferredStyle:UIAlertActionStyleDefault];
                UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"Copy and close"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction* action) {
                                                                     UIPasteboard* pb = [UIPasteboard generalPasteboard];
                                                                     [pb setString:s];
                                                                 }];
                [alert addAction:okButton];
                [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
    
    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;

    // init app variables
    self.products = nil;
    self.cart = [[NSMutableArray alloc] init];

    // FBSDK
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];

    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation];
    if (handled) {
        return TRUE;
    }
    
    NSUUID* adId = [[ASIdentifierManager sharedManager] advertisingIdentifier];
    NSString* s = [NSString stringWithFormat:@"DEEPLINK: %@, Device ADID: %@", [url absoluteString], [adId UUIDString]];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Got deeplink"
                                                                   message:s
                                                            preferredStyle:UIAlertActionStyleDefault];
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"Copy and close"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction* action) {
                                                         UIPasteboard* pb = [UIPasteboard generalPasteboard];
                                                         [pb setString:s];
                                                     }];
    [alert addAction:okButton];
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:alert animated:YES completion:nil];
    return TRUE;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (NSUInteger)getPriceFrom:(NSString *)priceString {
    NSString *priceNumberString = [priceString firstMatch:RX(@"\\d+")];
    return [priceNumberString intValue];
}

- (NSUInteger)getTotalPrice {
    int total = 0;
    for (NSDictionary *entry in self.cart) {
        NSString *priceString = [entry valueForKey:@"g:price"];
        NSString *priceNumberString = [priceString firstMatch:RX(@"\\d+")];
        total += [AppDelegate getPriceFrom:priceNumberString];
    }
    return total;
}

- (NSArray*)getCategories {
    if (_categories == nil) {
        _categories = [[NSMutableSet alloc] init];
        for (NSDictionary *entry in self.products) {
            NSString *title = [entry valueForKey:@"g:title"];
            NSArray *words = [title componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [_categories addObject:[words lastObject]];
        }
    }
    NSMutableArray *a = [[[_categories allObjects] sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    [a insertObject:@"ALL" atIndex:0];
    return [NSArray arrayWithArray:a];
}

- (NSArray*) filterProductsWith:(NSString*)categorySelected {
    if (_products == nil) {
        return @[];
    }

    if ([categorySelected isEqual: @"ALL"]) {
        return [NSArray arrayWithArray:_products];
    } else {
        NSMutableArray *a = [[NSMutableArray alloc] init];
        for (NSDictionary *entry in _products) {
            NSString *title = [entry valueForKey:@"g:title"];
            if ([title hasSuffix:categorySelected]) {
                [a addObject:entry];
            }
        }
        return [NSArray arrayWithArray:a];
    }
}

- (NSUInteger) countFilterProductsWith:(NSString*)categorySelected {
    if ([categorySelected isEqual:@"ALL"]) {
        return _products.count;
    } else {
        return [self filterProductsWith:categorySelected].count;
    }
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

@end
