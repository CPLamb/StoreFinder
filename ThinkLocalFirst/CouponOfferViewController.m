//
//  CouponOfferViewController.m
//  ThinkLocal
//
//  Created by Chris Lamb on 5/18/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import "CouponOfferViewController.h"

@interface CouponOfferViewController ()

@end

@implementation CouponOfferViewController
@synthesize detailItem = _detailItem;       // selected member
@synthesize name = _name;
@synthesize couponOffer = _couponOffer;
@synthesize expireDateString = _expireDateString;

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
    
// Sets the coupon fields from detailItem, the member's dictionary
    self.name.text = [self.detailItem objectForKey:@"name"];
    self.expireDateString.text = [self.detailItem objectForKey:@"expirationDate"];
    self.couponOffer.text = [self.detailItem objectForKey:@"couponOffer"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark AutoRotation

- (NSUInteger)supportedInterfaceOrientations {

    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark Custom methods

- (IBAction)backButton:(UIBarButtonItem *)sender {
//    NSLog(@"Pops the coupon off the stack & displays last screen");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
