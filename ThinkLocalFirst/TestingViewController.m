//
//  TestingViewController.m
//  ThinkLocalFirst
//
//  Created by Chris Lamb on 4/27/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import "TestingViewController.h"

@interface TestingViewController ()

@end

#define RECT_PADDING 2.0    // space around data object
#define RECT_SPACING 10.0    // space between backgrounds

@implementation TestingViewController
//@synthesize scrollView = _scrollView;

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
    
// Configures the scrollView
    CGRect scrollViewFrame = CGRectMake(0, 44, 320, 392);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    [self.view addSubview:scrollView];

// Sizes the scrollview
    CGFloat scrollViewHeight = 1500;
    CGSize scrollViewContentSize = CGSizeMake(320, scrollViewHeight);
    [scrollView setContentSize:scrollViewContentSize];
    
    // Adds a coupon rotoated for ease of display
    NSString *couponFileName = @"Coupon02.png";
    UIImage *couponImage = [UIImage imageNamed:couponFileName];
    UIImageView *coupon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 159, 318)];
    coupon.image = couponImage;            
    [scrollView addSubview:coupon];
/*
// Builds custom background views
    RoundedRectBackground *nameBackground = [[RoundedRectBackground alloc] initWithFrame:CGRectMake(RECT_SPACING, RECT_SPACING, 300, 40)];
//    UITextView *name = [[UITextView alloc] initWithFrame:nameBackground.frame];
//    name.text = @"ChrisPLamb Labs";
//    [nameBackground addSubview:name];
    [scrollView addSubview:nameBackground];
    
    CGFloat verticalPosition = 60;
    RoundedRectBackground *phoneBackground = [[RoundedRectBackground alloc] initWithFrame:CGRectMake(RECT_SPACING, verticalPosition, 300, 40)];
    [scrollView addSubview:phoneBackground];
    
    verticalPosition = 110;   //verticalPosition + RECT_SPACING + phoneBackground.height;
    RoundedRectBackground *photoBackground = [[RoundedRectBackground alloc] initWithFrame:CGRectMake(RECT_SPACING, verticalPosition, 300, 300)];
    [scrollView addSubview:photoBackground];
    
    verticalPosition = 420;
    RoundedRectBackground *descriptionBackground = [[RoundedRectBackground alloc] initWithFrame:CGRectMake(RECT_SPACING, verticalPosition, 300, 140)];
    UITextView *name = [[UITextView alloc] initWithFrame:nameBackground.frame];
    name.text = @"ChrisPLamb Labs";
    [descriptionBackground addSubview:name];
    [scrollView addSubview:descriptionBackground];


    UILabel *label01 = [[UILabel alloc] initWithFrame:CGRectMake(120, 100, 150, 40)];
    [label01 setText:@"Top"];
    [scrollView addSubview:label01];

    UILabel *label03 = [[UILabel alloc] initWithFrame:CGRectMake(120, 800, 150, 40)];
    [label03 setText:@"Bottom"];
    [scrollView addSubview:label03];

//    [self.scrollView setScrollEnabled:YES];
// Landscape only
//    [self.scrollView setContentSize:CGSizeMake(640, 920)];
*/
}

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Custom methods

- (IBAction)test01:(id)sender {
    NSLog(@"Someone pressed 01");
/*
    CGFloat scrollViewHeight = 1500;
    CGSize scrollViewContentSize = CGSizeMake(320, scrollViewHeight);
    scrollView setContentSize:scrollViewContentSize];
*/
}

- (IBAction)test02:(id)sender {
    NSLog(@"Someone pressed 02");
    
}


@end
