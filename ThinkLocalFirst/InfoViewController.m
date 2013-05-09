//
//  InfoViewController.m
//  ThinkLocalFirst
//
//  Created by Chris Lamb on 4/20/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController
@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize detailNameLabel = _detailNameLabel;

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

    [self configureView];
       
    NSLog(@"InfoVC Member selected is %@", self.detailItem);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        //        NSLog(@"detailItem is %@", _detailItem);
        // Update the view.
        [self configureView];
    } else {
        //        NSLog(@"detailItem is %@", _detailItem);
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        self.detailNameLabel.text = [self.detailItem objectForKey:@"Name"];
        self.detailDescriptionLabel.text = [self.detailItem objectForKey:@"Description"];
    } else {
        NSLog(@"The record is NULL");
    }
}

#pragma mark - Custom methods

- (IBAction)sortList:(id)sender {
    NSLog(@"Somebody tapped me!");
}

@end
