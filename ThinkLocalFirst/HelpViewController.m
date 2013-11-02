//
//  HelpViewController.m
//  ThinkLocal
//
//  Created by Chris Lamb on 10/25/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Custom methods

- (IBAction)backButton:(UIBarButtonItem *)sender {
    NSLog(@"Pops the coupon off the stack & displays last screen");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
