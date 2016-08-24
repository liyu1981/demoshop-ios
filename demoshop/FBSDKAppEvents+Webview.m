//
//  FBSDKAppEvents+Webview.m
//  demoshop
//
//  Created by Yu Li on 8/24/16.
//  Copyright © 2016 Yu Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBSDKAppEvents+Webview.h"

NSString *const FBSDKAppEventsAdvancedMatchingSupportProtocol = @"fb-ads-sdk-advanced-matching-support:";

@implementation FBSDKAppEvents(Webview)

+(NSString*)parameterStringValueFrom:(NSArray*)queryItems withKey:(NSString*)key {
    NSURLQueryItem *queryItem = [[queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name=%@", key]] firstObject];
    return queryItem.value;
}

+(double)parameterDoubleValueFrom:(NSArray*)queryItems {
    NSString *valueAsString = [self parameterStringValueFrom:queryItems withKey:@"cd[value]"];
    return [valueAsString doubleValue];
}

+(NSString*)parameterArrayStringValueFrom:(NSArray*)queryItems withKey:(NSString*)key {
    NSString *valueString = [self parameterStringValueFrom:queryItems withKey:key];
    if (valueString == nil) {
        return @"";
    }
    NSData *data = [valueString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *idarray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return [idarray componentsJoinedByString:@","];
}

+(void)trySetObject:(id)object forKey:(NSString*)key toDictionary:(NSMutableDictionary*)dict {
    if (object != nil) {
        [dict setObject:object forKey:key];
    }
}

+(NSDictionary*)parametersFrom:(NSArray*)queryItems {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{}];
    [self trySetObject:[self parameterArrayStringValueFrom:queryItems withKey:@"cd[content_ids]"] forKey:@"content_ids" toDictionary:dict];
    [self trySetObject:[self parameterStringValueFrom:queryItems withKey:@"cd[content_type]"] forKey:@"content_type" toDictionary:dict];
    [self trySetObject:[self parameterStringValueFrom:queryItems withKey:@"cd[content_name]"] forKey:@"content_name" toDictionary:dict];
    [self trySetObject:[self parameterStringValueFrom:queryItems withKey:@"cd[content_category]"] forKey:@"content_category" toDictionary:dict];
    [self trySetObject:[self parameterStringValueFrom:queryItems withKey:@"cd[currency]"] forKey:@"currency" toDictionary:dict];
    return dict;
}

+(BOOL)webView:(UIWebView *)webView supportPixelEventWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestURLString = [[request URL] absoluteString];
    
    if ([requestURLString hasPrefix:FBSDKAppEventsAdvancedMatchingSupportProtocol]) {
        NSArray *components = [requestURLString componentsSeparatedByString:@":"];
        
        NSString *commandName = (NSString*)[components objectAtIndex:1];
        NSString *argsAsString = [(NSString*)[components objectAtIndex:2] stringByRemovingPercentEncoding];
        
        NSLog(@"Command: %@ - %@", commandName, argsAsString);
        
        if ([commandName isEqualToString:@"track"]) {
            NSString *url = [NSString stringWithFormat:@"https://www.facebook.com/tr?%@", argsAsString];
            NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:[NSURL URLWithString:url] resolvingAgainstBaseURL:NO];
            NSArray *queryItems = urlComponents.queryItems;
            NSString *event = [self parameterStringValueFrom:queryItems withKey:@"ev"];
            NSLog(@"Event: %@", event);
            
            if ([event isEqualToString:@"PageView"]) {
                // should we fire some event here?
            } else if ([event isEqualToString:@"ViewContent"] ||
                       [event isEqualToString:@"AddToCart"] ||
                       [event isEqualToString:@"Purchase"]) {
                double value = [self parameterDoubleValueFrom:queryItems];
                NSDictionary* parameters = [self parametersFrom:queryItems];
                [self logEvent:event valueToSum:value parameters:parameters];
            }
            
        }
        
        return YES;
    } else {
        return NO;
    }
}

@end
