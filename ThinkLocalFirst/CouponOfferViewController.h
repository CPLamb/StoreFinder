//
//  CouponOfferViewController.h
//  ThinkLocal
//
//  Created by Chris Lamb on 5/18/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponOfferViewController : UIViewController


@property (strong, nonatomic) id detailItem;        // selected item data dictionary

@property (strong, nonatomic) IBOutlet UILabel *expireDateString;
@property (strong, nonatomic) IBOutlet UITextView *couponOffer;
@property (strong, nonatomic) IBOutlet UILabel *name;

- (IBAction)backButton:(UIBarButtonItem *)sender;

@end
