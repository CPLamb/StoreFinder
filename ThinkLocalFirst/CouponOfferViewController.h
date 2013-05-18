//
//  CouponOfferViewController.h
//  ThinkLocal
//
//  Created by Chris Lamb on 5/18/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponOfferViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *couponView;
@property (strong, nonatomic) NSString *couponURLString;

@end
