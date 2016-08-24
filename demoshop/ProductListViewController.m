//
//  MasterViewController.m
//  demoshop
//
//  Created by Yu Li on 2/5/16.
//  Copyright © 2016 Yu Li. All rights reserved.
//

#import "ProductListViewController.h"
#import "DetailViewController.h"
#import "WebviewController.h"
#import "AppDelegate.h"
#import "XMLDictionary.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface ProductListViewController ()

@end

@implementation ProductListViewController

- (void)reportFBViewedContent {
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSArray *products = [app filterProductsWith:_categorySelected];
    if (products.count > 0) {
        // get first 3 items
        NSArray *first3 = [products subarrayWithRange:NSMakeRange(0, MIN(products.count, 3))];
        NSMutableArray *contentIDs = [[NSMutableArray alloc] init];
        NSUInteger total = 0;
        for (NSDictionary *entry in first3) {
            [contentIDs addObject:[entry valueForKey:@"g:id"]];
            total += [AppDelegate getPriceFrom:[entry valueForKey:@"g:price"]];
        }
        [FBSDKAppEvents logEvent:FBSDKAppEventNameViewedContent
                      valueToSum:total
                      parameters:@{ FBSDKAppEventParameterNameContentType: @"product",
                                    FBSDKAppEventParameterNameContentID: [contentIDs componentsJoinedByString:@","] }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.

    // self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    if (_categorySelected == nil) {
        _categorySelected = @"ALL";
    }

    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Category (%@)", _categorySelected]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(selectCategory:)];
    self.navigationItem.rightBarButtonItem = filterButton;
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    if (app.products == nil) {
        // Now get the XML file
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://104.236.187.180/magento/fbdpafeed.xml"]];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [self reportFBViewedContent];
    [self becomeFirstResponder];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectCategory:(id)sender {
    [self.navigationController performSegueWithIdentifier:@"showCategorySelector" sender:self];
}

- (void)setCategorySelected:(NSString *)category {
    _categorySelected = category;
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    _responseXmlDoc = [NSDictionary dictionaryWithXMLData:[NSData dataWithData:_responseData]];
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    app.products = [[NSMutableArray alloc] init];
    for (NSDictionary* entry in [_responseXmlDoc valueForKey:@"entry"]) {
        [app.products addObject:entry];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([app.products count] - 1) inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self reportFBViewedContent];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        NSDate *object = [app filterProductsWith:_categorySelected][indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    } else if ([[segue identifier] isEqualToString:@"shakeToWebview"]) {
        
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    return [app countFilterProductsWith:_categorySelected];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    AppDelegate *app = [[UIApplication sharedApplication] delegate];

    NSDictionary *object = [app filterProductsWith:_categorySelected][indexPath.row];
    
    cell.textLabel.text = [object valueForKey:@"g:title"];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Price: %@, Availability: %@",
                                                           [object valueForKey:@"g:price"],
                                                           [object valueForKey:@"g:availability"]];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[object valueForKey:@"g:image_link"]]
                      placeholderImage:[UIImage imageNamed:@"placeholder-pushee.jpg"]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    /*if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }*/
}

#pragma mark - shake support

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        NSLog(@"shaked");
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"DemoshopWebview"];
        [self showViewController:vc sender:self];
    }
}

@end
