//
//  DetailViewController.h
//  demoshop
//
//  Created by Yu Li on 2/5/16.
//  Copyright © 2016 Yu Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

