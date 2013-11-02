//
//  InfoViewController.h
//  ThinkLocalFirst
//
//  Created by Chris Lamb on 4/20/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//
/*
 This InfoVC class Is the first screen upon start of the app and it
 used for basic navigation around the app.  It is the "Home" screen
 and .........
 */

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

- (IBAction)searchButton:(UIButton *)sender;
- (IBAction)mapButton:(UIButton *)sender;

@end
