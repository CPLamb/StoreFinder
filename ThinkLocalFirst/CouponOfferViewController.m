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
@synthesize couponView = _couponView;
@synthesize couponURLString = _couponURLString;

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

//    if( self.couponURLString == nil )
//        self.couponURLString = @"http://santacruznewspapertaxi.com/wp-content/uploads/2013/05/CouponSample_480x320.png"
    NSURL *couponURL = [NSURL URLWithString:self.couponURLString];
    NSURLRequest *couponRequest = [NSURLRequest requestWithURL:couponURL];
    [self.couponView loadRequest:couponRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark AutoRotation

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
}


@end
