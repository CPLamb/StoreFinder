//
//  SettingsViewController.m
//  ThinkLocal
//
//  Created by Chris Lamb on 5/19/14.
//  Copyright (c) 2014 Chris Lamb. All rights reserved.
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>  // For Parse features

@interface SettingsViewController ()

@end
int indexPath = 0;


@implementation SettingsViewController
@synthesize userNameLabel = _userNameLabel;
@synthesize couponCountLabel = _couponCountLabel;

@synthesize enabledCoupons = _enabledCoupons;

@synthesize businessNameTextfield = _businessNameTextfield;
@synthesize expirationDateTextfield = _expirationDateTextfield;
@synthesize couponOfferTextfield = _couponOfferTextfield;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{

    PFQuery *couponQuery = [PFQuery queryWithClassName:@"Coupon"];
    [couponQuery getObjectInBackgroundWithId:@"8aYTnKimWc" block:^(PFObject *coupon, NSError *error) {
        // Stuff to be done after the block completes
        NSLog(@"%@", coupon);
        self.businessNameTextfield.text = coupon[@"name"];
        self.couponOfferTextfield.text = coupon[@"couponOffer"];
        self.expirationDateTextfield.text = coupon[@"expirationDate"];
    }];

 }

- (void)viewDidLoad
{
    [super viewDidLoad];
    
// sets textfiled delegates so we can dismiss the keyboard
    _businessNameTextfield.delegate = self;
    _expirationDateTextfield.delegate = self;
    _couponOfferTextfield.delegate = self;
    
/* A test Parse object that can be viewed in Dashboard of StoreFinder in myParse, logs currentUser
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"user"] = [PFUser currentUser].username;
    [testObject saveInBackground];
*/    
// Displays the User's name & other stuff
    self.userNameLabel.text = [PFUser currentUser].username;
    self.couponCountLabel.text = @"xx coupons";

    [self CPLQueryForCoupons];
}

// removes keyboards from the screen with these 2 textfdiled delegate methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_businessNameTextfield resignFirstResponder];
    [_expirationDateTextfield resignFirstResponder];
    [_couponOfferTextfield resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField)
    {
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Custom Parse methods

- (NSArray *)CPLQueryForCoupons {
//    NSLog(@"Get a new query any time New Coupon or Enable Coupons button Pressed");
    
// Builds an array of enabledCoupons
    PFQuery *coupons = [PFQuery queryWithClassName:@"Coupon"];
    [coupons whereKey:@"couponEnabled" equalTo:@YES];
    
    [coupons findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        self.enabledCoupons = objects;
        NSLog(@"Successfully retrieved %d coupons", objects.count);
//        for (PFObject *object in self.enabledCoupons) {
//            NSLog(@"%@", object);
//        }
    }];
    self.couponCountLabel.text = [NSString stringWithFormat:@"%d Coupons", self.enabledCoupons.count+1];
    return self.enabledCoupons;
}

- (IBAction)cancelButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];

}

- (IBAction)newCouponButton:(UIButton *)sender
{
//    NSLog(@"Creates a new PFObject from the textfields & sends it to Parse");
   
// A test Parse object that can be viewed in Dashboard of StoreFinder in myParse
    PFObject *coupon = [PFObject objectWithClassName:@"Coupon"];
    coupon[@"name"] = self.businessNameTextfield.text;
    coupon[@"couponOffer"] = self.couponOfferTextfield.text;
    coupon[@"expirationDate"] = self.expirationDateTextfield.text;
    coupon[@"userName"] = [PFUser currentUser].username;
    coupon[@"couponEnabled"] = @YES;

    [coupon saveInBackground];
    
// queries for the updated list
    [self CPLQueryForCoupons];

}

- (IBAction)enableCouponButton:(UIButton *)sender
{
//    NSLog(@"Toggles the enable Boolean & sends it to Parse");
    PFObject *coupon = [self.enabledCoupons objectAtIndex:indexPath];
    coupon[@"couponEnabled"] = @NO;
    
    [coupon saveInBackground];
    
    [self CPLQueryForCoupons];
    [self decrementList];
}

- (IBAction)nextButton:(UIButton *)sender
{
//    NSLog(@"scrolls forward thru the various coupons & displays them above");
    indexPath = indexPath + 1;
    if (indexPath == self.enabledCoupons.count) {
        indexPath = 0;
    }
    PFObject *coupon = [self.enabledCoupons objectAtIndex:indexPath];
    self.businessNameTextfield.text = coupon[@"name"];
    self.expirationDateTextfield.text = coupon[@"expirationDate"];
    self.couponOfferTextfield.text = coupon[@"couponOffer"];
    
//    NSLog(@"index = %d", indexPath);
}

- (IBAction)previousButton:(UIButton *)sender
{
//    NSLog(@"scrolls backward thru the various coupons & displays them above");
    [self decrementList];
//    NSLog(@"index = %d", indexPath);
}

- (void)decrementList
{
    indexPath = indexPath - 1;
    if (indexPath == -1) {
        indexPath = self.enabledCoupons.count-1;
    }
    PFObject *coupon = [self.enabledCoupons objectAtIndex:indexPath];
    self.businessNameTextfield.text = coupon[@"name"];
    self.expirationDateTextfield.text = coupon[@"expirationDate"];
    self.couponOfferTextfield.text = coupon[@"couponOffer"];
}

@end
