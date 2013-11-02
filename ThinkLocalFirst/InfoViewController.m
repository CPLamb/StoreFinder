//
//  InfoViewController.m
//  ThinkLocalFirst
//
//  Created by Chris Lamb on 4/20/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import "InfoViewController.h"
#import "MasterViewController.h"
#import "AboutViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController
@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize detailNameLabel = _detailNameLabel;

#pragma mark - View Lifecycle methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configureView];
       
    NSLog(@"InfoVC Member selected is %@", self.detailItem);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        //        NSLog(@"detailItem is %@", _detailItem);
        // Update the view.
        [self configureView];
    } else {
        //        NSLog(@"detailItem is %@", _detailItem);
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        self.detailNameLabel.text = [self.detailItem objectForKey:@"Name"];
        self.detailDescriptionLabel.text = [self.detailItem objectForKey:@"Description"];
    } else {
        NSLog(@"The record is NULL");
    }
}

#pragma mark - Custom methods

- (IBAction)searchButton:(UIButton *)sender
{
    NSLog(@"pushing the ABOUT screen onto the stack");
        
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    AboutViewController *theAboutScreen = [storyBoard instantiateViewControllerWithIdentifier:@"AboutVC"];
    
    // pushes the couponView onto the stack
    [self presentViewController:theAboutScreen animated:NO completion:nil];

}

- (IBAction)mapButton:(UIButton *)sender
{
    NSLog(@"pushing the MAP screen onto the stack");
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    AboutViewController *theMapScreen = [storyBoard instantiateViewControllerWithIdentifier:@"MapNavC"];
    
    // pushes the couponView onto the stack
    [self presentViewController:theMapScreen animated:YES completion:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"The segue identifier is %@", [segue identifier]);
    
    // Show List screen
    if ([[segue identifier] isEqualToString:@"showList"]) {
//        MasterViewController *listViewController = [segue destinationViewController];
    }
    
    // Show About screen
    if ([[segue identifier] isEqualToString:@"showAbout"]) {
        [segue destinationViewController];
    }
    
    // Show Map screen
    if ([[segue identifier] isEqualToString:@"showMap"]) {
        [segue destinationViewController];
    }
    
    // Show Coupons screen
    if ([[segue identifier] isEqualToString:@"showCoupons"]) {
        [segue destinationViewController];
    }
    
    // Show Categories screen
    if ([[segue identifier] isEqualToString:@"showCategories"]) {
        [segue destinationViewController];
    }
}

@end
