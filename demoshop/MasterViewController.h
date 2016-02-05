//
//  MasterViewController.h
//  demoshop
//
//  Created by Yu Li on 2/5/16.
//  Copyright © 2016 Yu Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController<NSURLConnectionDelegate>
{
    NSMutableData *_responseData;
    NSDictionary *_responseXmlDoc;
}

@property (strong, nonatomic) DetailViewController *detailViewController;


@end

