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
    CGFloat scrollViewHeight = 2500;
    CGSize scrollViewContentSize = CGSizeMake(320, scrollViewHeight);
    [scrollView setContentSize:scrollViewContentSize];
    
// Adds a coupon rotoated for ease of display
    NSString *couponFileName = @"CouponSample_480x320.png";
    UIImage *couponImage = [UIImage imageNamed:couponFileName];
    UIImageView *coupon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    coupon.image = couponImage;            
    [scrollView addSubview:coupon];
    
    // Adds a coupon rotoated for ease of display
    couponFileName = @"Coupon02.png";
    couponImage = [UIImage imageNamed:couponFileName];
    coupon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 480, 180, 560)];
    coupon.image = couponImage;
    [scrollView addSubview:coupon];
    
    // Adds a coupon rotoated for ease of display
    couponFileName = @"CouponSample_480x320.png";
    couponImage = [UIImage imageNamed:couponFileName];
    coupon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1040, 320, 480)];
    coupon.image = couponImage;
    [scrollView addSubview:coupon];
        
    // Adds a coupon rotoated for ease of display
    couponFileName = @"Coupon01.png";
    couponImage = [UIImage imageNamed:couponFileName];
    coupon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1520, 160, 320)];
    coupon.image = couponImage;
    [scrollView addSubview:coupon];
    
    
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
    NSLog(@"Someone is doing some NSDocumentDirectory stuff");
    
// Set up fileManager & get directory URLs
    NSFileManager *myFileManager = [NSFileManager defaultManager];
    NSArray *myDirectoryURLs = [myFileManager URLsForDirectory:NSAllApplicationsDirectory inDomains:NSAllDomainsMask];
    NSLog(@"NSDocumentDirectory %@", myDirectoryURLs);
    
// Get contents of the directory
    NSURL *myFirstDirectoryURL = [myDirectoryURLs objectAtIndex:0];
    NSString *myFirstDirectoryString = [myFirstDirectoryURL absoluteString];
    NSArray *myFiles = [myFileManager contentsOfDirectoryAtPath:myFirstDirectoryString error:nil];
    NSLog(@"files are %@", myFiles);
    
}

- (IBAction)test02:(id)sender {
    NSLog(@"Someone pressed 02");
    
// Get's the app's bundle
    NSArray *myBundle = [NSBundle allBundles];
    NSLog(@"my apps bundle is %@", myBundle);
    
    // List the contents of that bundle
    
    
}


@end
