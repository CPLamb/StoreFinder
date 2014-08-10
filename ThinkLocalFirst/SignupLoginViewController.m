//
//  SignupLoginViewController.m
//  ThinkLocal
//
//  Created by Chris Lamb on 5/13/14.
//  Copyright (c) 2014 Chris Lamb. All rights reserved.
//

#import "SignupLoginViewController.h"

@interface SignupLoginViewController ()

@end

@implementation SignupLoginViewController

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
    // Do any additional setup after loading the view.
/*    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TLF_Logo640x960.png"]];
    
    self.logInView.usernameField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.logInView.passwordField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
*/
    self.delegate = self;
    self.signUpController.delegate = self;
    self.logInView.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SCNTaxiLogo.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Parse Delegte methods

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    NSLog(@"%@ is now LOGGED ON!", user.username);
    [self dismissModalViewControllerAnimated:YES];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    [PFUser logOut];
    NSLog(@"Cancel / Dismiss button pressed");
    [self dismissModalViewControllerAnimated:YES];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    NSLog(@"%@ is now signed up!", user.username);
    [self dismissModalViewControllerAnimated:YES];
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController
{
    NSLog(@"sign up is CANCELLED!");
    [self dismissModalViewControllerAnimated:YES];
}

@end
