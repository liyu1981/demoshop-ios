//
//  DetailViewController.m
//  demoshop
//
//  Created by Yu Li on 2/5/16.
//  Copyright © 2016 Yu Li. All rights reserved.
//

#import "DetailViewController.h"
#import "CartViewController.h"
#import "AppDelegate.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[self.detailItem valueForKey:@"g:image_link"]]
                          placeholderImage:[UIImage imageNamed:@"placeholder-pushee.jpg"]];
        self.titleLabel.text = [self.detailItem valueForKey:@"g:title"];
        self.priceLabel.text = [self.detailItem valueForKey:@"g:price"];
        self.availabilityLabel.text = [self.detailItem valueForKey:@"g:availability"];
        self.detailDescriptionLabel.text = [self.detailItem valueForKey:@"g:description"];
        
        [FBSDKAppEvents logEvent:FBSDKAppEventNameViewedContent
                      valueToSum:[AppDelegate getPriceFrom:[self.detailItem valueForKey:@"g:price"]]
                      parameters:@{ FBSDKAppEventParameterNameCurrency: @"USD",
                                    FBSDKAppEventParameterNameContentType: @"product",
                                    FBSDKAppEventParameterNameContentID: [self.detailItem valueForKey:@"g:id"] }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"addToCart"]) {
        CartViewController *controller = (CartViewController *)[[segue destinationViewController] topViewController];
        [controller addItem:self.detailItem];
        
        [FBSDKAppEvents logEvent:FBSDKAppEventNameAddedToCart
                      valueToSum:[AppDelegate getPriceFrom:[self.detailItem valueForKey:@"g:price"]]
                      parameters:@{ FBSDKAppEventParameterNameContentType: @"product",
                                    FBSDKAppEventParameterNameContentID: [self.detailItem valueForKey:@"g:id"] }];
        
        //controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        //controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

@end
