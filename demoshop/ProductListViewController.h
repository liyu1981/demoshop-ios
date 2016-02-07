//
//  MasterViewController.h
//  demoshop
//
//  Created by Yu Li on 2/5/16.
//  Copyright © 2016 Yu Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface ProductListViewController : UITableViewController<NSURLConnectionDelegate>
{
    NSMutableData *_responseData;
    NSDictionary *_responseXmlDoc;
    NSString *_categorySelected;
}

- (void)setCategorySelected:(NSString*)category;

@end

