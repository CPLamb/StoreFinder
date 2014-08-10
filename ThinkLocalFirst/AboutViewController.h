//
//  AboutViewController.h
//  ThinkLocal
//
//  Created by Chris Lamb on 10/18/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//
/* The AboutVC is the page that highlights and details information
 about Think Local First.  The scrollView is set to a static height
 
*/ 

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController
{
    IBOutlet UIScrollView *scrollPage;
    IBOutlet UIView *helpView;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollPage;
@property (strong, nonatomic) IBOutlet UIView *helpView;

- (IBAction)contactUsButton:(UIButton *)sender;
- (IBAction)showHelpButton:(id)sender;
- (IBAction)hideHelpButton:(id)sender;

- (IBAction)loginButton:(UIButton *)sender;
- (IBAction)beLocalButton:(UIButton *)sender;

@end
