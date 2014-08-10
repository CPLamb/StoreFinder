//
//  AboutViewController.m
//  ThinkLocal
//
//  Created by Chris Lamb on 10/18/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import "AboutViewController.h"
#import "RoundedRectBackground.h"
#import <Parse/Parse.h>
#import "SignupLoginViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController
@synthesize scrollPage = _scrollPage;
@synthesize helpView = _helpView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"  ");
    NSLog(@"viewDIDAppear");
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.helpView.hidden = YES;
    self.scrollPage.contentSize = CGSizeMake(320.0, 930.0);
    
/* A test Parse object that can be viewed in Dashboard of StoreFinder in myParse
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"user"] = @"CPLamb";
    [testObject saveInBackground];
*/
// Website URL - UITextView
    NSString *websitePrefix = @"Tap to visit:                          ";
    NSString *website = @"http://www.mobile.thinklocalsantacruz.org/";
    NSString *websiteText = [websitePrefix stringByAppendingString:website];
    
    // Uses a UITextView because they recognize URLs phone numbers etc;
    UITextView *websiteField = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 260, 60)];
    websiteField.text = websiteText;
    websiteField.font = [UIFont fontWithName:@"Times New Roman" size:16];
    websiteField.dataDetectorTypes = UIDataDetectorTypeAll;
    websiteField.editable = NO;
    
    // Background position on scroollView & it's height
    CGFloat vertPosition = 480.0;
    CGFloat backgroundHeight = 70;  //phoneLabel.bounds.size.height + 2*PADDING;
    RoundedRectBackground *websiteBackground = [[RoundedRectBackground alloc] initWithFrame:CGRectMake(20.0, vertPosition, 280.0, backgroundHeight)];
    
    // Add textField to background & then to scrollView
    [websiteBackground addSubview:websiteField];
    [self.scrollPage addSubview:websiteBackground];
/*
// Mailing Address - UITextView
    NSString *addressStreet = @"6 Oak Road                                   ";
    NSString *addressTown = @"Santa Cruz, CA 95060";
    NSString *addressAll = [addressStreet stringByAppendingString:addressTown];
    
    // Uses a UITextView because they recognize URLs phone numbers etc;
    UITextView *addressField = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 260, 60)];
    addressField.text = addressAll;
    addressField.font = [UIFont fontWithName:@"Times New Roman" size:16];
    addressField.dataDetectorTypes = UIDataDetectorTypeNone;
    addressField.editable = NO;
    
    // Background position on scroollView & it's height
    CGFloat vertPosition2 = 520.0;
    CGFloat backgroundHeight2 = 70;  //phoneLabel.bounds.size.height + 2*PADDING;
    RoundedRectBackground *addressBackground = [[RoundedRectBackground alloc] initWithFrame:CGRectMake(20.0, vertPosition2, 280.0, backgroundHeight2)];
    
    // Add textField to background & then to scrollView
    [addressBackground addSubview:addressField];
    [self.scrollPage addSubview:addressBackground];
*/    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Parse methods

- (IBAction)beLocalButton:(UIButton *)sender
{
    NSLog(@"displays the settings & screen for User interaction");

}

- (IBAction)loginButton:(UIButton *)sender;
{
    NSLog(@"displays the login screen");

    SignupLoginViewController *login = [[SignupLoginViewController alloc] init];

    [self presentModalViewController:login animated:YES];
}

#pragma mark - Custom methods

- (IBAction)showHelpButton:(id)sender
{
    NSLog(@"slides up a transparency that describes the buttons below");
    if (self.helpView.hidden) {
        self.helpView.hidden = NO;
    }
}

- (IBAction)hideHelpButton:(id)sender
{
//    NSLog(@"hides the transparency that describes the buttons below");
    if (!self.helpView.hidden) {
        self.helpView.hidden = YES;
    }
}

- (IBAction)contactUsButton:(UIButton *)sender {
//    NSLog(@"Somebody wants to open an email!");
    
    // Configures the email address
    NSString *recipient = @"mailto:info@ThinkLocalSantaCruz.org?&subject=Think Local First iPhone app";
    //    NSString *recipient = @"mailto:CPLamb@Pacbell.net";      // &subject=Think LocalFirst iPhone app";
    NSString *body = @"&body=Great app! I'll tell all my friends";
    NSString *email = [NSString stringWithFormat:@"%@%@", recipient, body];
    //    NSString *email = [NSString stringWithFormat:@"%@", recipient];
    
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];        // @"mailto:"]];
}

// Moves to other view & sets the detailItem to the selected item
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    NSLog(@"The segue identifier is %@", [segue identifier]);
    
    if ([[segue identifier] isEqualToString:@"showCoupon"]) {
        [segue destinationViewController];
    }
    
}

@end
