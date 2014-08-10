//
//  SettingsViewController.h
//  ThinkLocal
//
//  Created by Chris Lamb on 5/19/14.
//  Copyright (c) 2014 Chris Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *couponCountLabel;

- (IBAction)cancelButton:(id)sender;
- (IBAction)newCouponButton:(UIButton *)sender;
- (IBAction)enableCouponButton:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UITextField *businessNameTextfield;
@property (strong, nonatomic) IBOutlet UITextField *couponOfferTextfield;
@property (strong, nonatomic) IBOutlet UITextField *expirationDateTextfield;

@property (strong, nonatomic) NSArray *enabledCoupons;

- (IBAction)nextButton:(UIButton *)sender;
- (IBAction)previousButton:(UIButton *)sender;

@end
