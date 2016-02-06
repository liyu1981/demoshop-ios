//
//  CartViewController.m
//  demoshop
//
//  Created by Yu Li on 2/6/16.
//  Copyright © 2016 Yu Li. All rights reserved.
//

#import "CartViewController.h"
#import "AppDelegate.h"
#import "MasterViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"


@interface CartViewController ()

@end

@implementation CartViewController

#pragma mark - Managing the detail item

- (void)addItem:(id)newItem {
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    [app.cart insertObject:newItem atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UIBarButtonItem *payButton = [[UIBarButtonItem alloc] initWithTitle:@"Pay!" style:UIBarButtonItemStyleDone target:self action:@selector(pay:)];
    self.navigationItem.rightBarButtonItem = payButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pay:(id)sender {
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    [app.cart removeAllObjects];
    [self performSegueWithIdentifier:@"productList" sender:sender];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"productList"]) {
        MasterViewController *controller = (MasterViewController *)[[segue destinationViewController] topViewController];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    return app.cart.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSDictionary *object = app.cart[indexPath.row];
    
    cell.textLabel.text = [object valueForKey:@"g:title"];
    cell.detailTextLabel.text = [object valueForKey:@"g:price"];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[object valueForKey:@"g:image_link"]]
                      placeholderImage:[UIImage imageNamed:@"placeholder-pushee.jpg"]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        [app.cart removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
