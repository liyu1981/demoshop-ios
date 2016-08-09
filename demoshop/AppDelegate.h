//
//  AppDelegate.h
//  demoshop
//
//  Created by Yu Li on 2/5/16.
//  Copyright © 2016 Yu Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSMutableArray *products;
@property (nonatomic, retain) NSMutableArray *cart;

+ (NSUInteger) getPriceFrom:(NSString*)priceString;
- (NSUInteger) getTotalPrice;
- (NSArray*) getCategories;
- (NSArray*) filterProductsWith:(NSString*)categorySelected;
- (NSUInteger) countFilterProductsWith:(NSString*)categorySelected;

@end

