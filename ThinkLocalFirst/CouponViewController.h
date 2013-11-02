//
//  CouponViewController.h
//  ThinkLocal
//
//  Created by Chris Lamb on 5/18/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//
/*  This Coupon VC is a subclass of the MasterVC tableView.
   It is filtered by the hasCoupon boolean 
*/ 

#import "MasterViewController.h"

@interface CouponViewController : MasterViewController

//@property (nonatomic, strong) UISearchBar *mySearchBar;


- (IBAction)showAllButton:(UIBarButtonItem *)sender;


@end
