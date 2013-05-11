//
//  DetailViewController.m
//  ThinkLocalFirst
//
//  Created by Chris Lamb on 4/21/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import "DetailViewController.h"

#import "MapViewController.h"
#import "MapItem.h"
#import "RoundedRectBackground.h"

#define PADDING 5.0
#define SPACING 10.0

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;               // This uses _propertyName in the automatically
@synthesize detailNameLabel = _detailNameLabel;     // created setter & getter methods
@synthesize detailPhoneTextView = _detailPhoneTextView;
@synthesize detailImageView = _detailImageView;
@synthesize detailDescriptionTextView = _detailDescriptionTextView;
@synthesize detailAddressLabel = _detailAddressLabel;
@synthesize detailCityLabel = _detailCityLabel;
@synthesize detailWebsiteURLTextView = _detailWebsiteURLTextView;

#pragma mark -- View lifecycle methods

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
    
//    [self configureView];
    
    [inputScrollView setScrollEnabled:YES];
    // Portrait only
    [inputScrollView setContentSize:CGSizeMake(320.0, 1500.0)];
    
    NSLog(@"DetailVC Member selected is %@", self.detailItem);
}

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}


- (void)viewWillAppear:(BOOL)animated {
    
// Builds the custom background bubbles for all 7 fields
    [self assembleBackgrounds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom methods

/* 
 Builds the details screen with fields of dynamic heights and places them
 on a dynamically sized scrollView.
 If the field is empty in the PList the background is not displayed
*/
- (void)assembleBackgrounds {
    
// Configure the scrollView
    CGRect scrollViewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    [self.view addSubview:scrollView];
        
// Builds individual backgrounds and inserts the content into dynamically sized background
    
// Calculates background widths
    CGFloat backgroundWidth = self.view.bounds.size.width - 2*SPACING;
    CGFloat contentWidth = backgroundWidth - 2*PADDING;
    
// Business name - NSString
    NSString *name = [self.detailItem objectForKey:@"name"];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING*1.5, PADDING, contentWidth, 30)];
    nameLabel.text = name;
    nameLabel.font = [UIFont fontWithName:@"Helvetica" size:24];
    nameLabel.adjustsFontSizeToFitWidth = YES;

    CGFloat vertPosition = SPACING;     // Starting Y position for each background
    
    CGFloat backgroundHeight = nameLabel.bounds.size.height + 2*PADDING;  
    // NSLog(@"Height is %f", vertPosition);
    RoundedRectBackground *nameBackground = [[RoundedRectBackground alloc] initWithFrame:CGRectMake(SPACING, vertPosition, backgroundWidth, backgroundHeight)];
    [nameBackground addSubview:nameLabel];
    [scrollView addSubview:nameBackground];

// Phone number - UITextView
    NSString *phoneData = [self.detailItem objectForKey:@"phone"];
    if (phoneData.length > 0) {                                     // Checks for NOT empty string
        NSString *phonePrefix = @"Tap to call: ";
        NSString *phone = [phonePrefix stringByAppendingString:phoneData];
        
        UITextView *phoneLabel = [[UITextView alloc] initWithFrame:CGRectMake(PADDING, PADDING, contentWidth, 40)];
        phoneLabel.text = phone;
        phoneLabel.font = [UIFont fontWithName:@"Times New Roman" size:18];
        
        phoneLabel.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
        phoneLabel.editable = NO;
        
        vertPosition = vertPosition + backgroundHeight + SPACING;
        
        backgroundHeight = phoneLabel.bounds.size.height + 2*PADDING;
        // NSLog(@"UITextView height is %f", phoneLabel.bounds.size.height);
        RoundedRectBackground *phoneBackground = [[RoundedRectBackground alloc] initWithFrame:CGRectMake(SPACING, vertPosition, backgroundWidth, backgroundHeight)];
        [phoneBackground addSubview:phoneLabel];
        [scrollView addSubview:phoneBackground];
    }

// Photo/Logo - UIImageView
    
    NSString *photo = [self.detailItem objectForKey:@"logo"];
// Checks to see if a photo name exists
    if (photo.length > 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:photo ofType:@"png"];
        UIImage *photoImage = [UIImage imageWithContentsOfFile:path];
        
        UIImageView *photoView = [[UIImageView alloc] initWithImage:photoImage];
        
        vertPosition = vertPosition + backgroundHeight + SPACING;
        
        backgroundHeight = photoImage.size.height + 2*PADDING;
        // NSLog(@"image height is %f", backgroundHeight);
        UIView *photoBackground = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - photoImage.size.width)/2 , vertPosition, backgroundWidth, backgroundHeight)];
        [photoBackground addSubview:photoView];
        [scrollView addSubview:photoBackground];
    }
    
// Description - UITextView
    NSString *description = [self.detailItem objectForKey:@"description"];
    
// Calcs height of the textView based on the # of characters in a line
    CGFloat textViewHeight = ((description.length/30)+1) * 1;
    
    UITextView *descriptionField = [[UITextView alloc] initWithFrame:CGRectMake(PADDING, PADDING, contentWidth, textViewHeight*1.35)];
    descriptionField.text = description;
    descriptionField.font = [UIFont fontWithName:@"Times New Roman" size:18];
    descriptionField.dataDetectorTypes = UIDataDetectorTypeNone;
    descriptionField.editable = NO;
    descriptionField.scrollEnabled = NO;
    
    vertPosition = vertPosition + backgroundHeight + SPACING;
    
    backgroundHeight = textViewHeight*1.5 + 2*PADDING;
    // NSLog(@"Description length is %f", textViewHeight);
    RoundedRectBackground *descriptionBackground = [[RoundedRectBackground alloc] initWithFrame:CGRectMake(SPACING, vertPosition, backgroundWidth, backgroundHeight)];
    [descriptionBackground addSubview:descriptionField];
    [scrollView addSubview:descriptionBackground];
    
// Website URL - UITextView
    NSString *websiteData = [self.detailItem objectForKey:@"url"];
    if (websiteData.length >0) {
        NSString *websitePrefix = @"Tap to visit:                 ";
        NSString *website = [websitePrefix stringByAppendingString:websiteData];
        
        UITextView *websiteField = [[UITextView alloc] initWithFrame:CGRectMake(PADDING, PADDING, contentWidth, 60)];
        websiteField.text = website;
        websiteField.font = [UIFont fontWithName:@"Times New Roman" size:18];
        websiteField.dataDetectorTypes = UIDataDetectorTypeAll;
        websiteField.editable = NO;
        
        vertPosition = vertPosition + backgroundHeight + SPACING;
        
        backgroundHeight = 70;  //phoneLabel.bounds.size.height + 2*PADDING;
        // NSLog(@"UITextView height is %f", phoneLabel.bounds.size.height);
        RoundedRectBackground *websiteBackground = [[RoundedRectBackground alloc] initWithFrame:CGRectMake(SPACING, vertPosition, backgroundWidth, backgroundHeight)];
        [websiteBackground addSubview:websiteField];
        [scrollView addSubview:websiteBackground];
    }
    
// Business address - 2 x NSString
    NSString *address = [self.detailItem objectForKey:@"address"];
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING*1.5, PADDING, contentWidth, 30)];
    addressLabel.text = address;
    addressLabel.font = [UIFont fontWithName:@"Times New Roman" size:18];
    addressLabel.adjustsFontSizeToFitWidth = YES;
    
    // Assemble city, state, zip string
    NSString *city = [self.detailItem objectForKey:@"city"];
    NSString *state = [self.detailItem objectForKey:@"state"];
    NSString *zip = [self.detailItem objectForKey:@"zip"];
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING*1.5, PADDING+24, contentWidth, 30)];
    cityLabel.text = [[[[[NSString stringWithString:city] stringByAppendingString:@", "] stringByAppendingString:state] stringByAppendingString:@"  "] stringByAppendingString:zip];
    cityLabel.font = [UIFont fontWithName:@"Times New Roman" size:18];
    cityLabel.adjustsFontSizeToFitWidth = YES;
    
    vertPosition = vertPosition + backgroundHeight + SPACING;
    
    backgroundHeight = 70;
    // NSLog(@"Height is %f", backgroundHeight);
    RoundedRectBackground *addressBackground = [[RoundedRectBackground alloc] initWithFrame:CGRectMake(SPACING, vertPosition, backgroundWidth, backgroundHeight)];
    [addressBackground addSubview:addressLabel];
    [addressBackground addSubview:cityLabel];
    [scrollView addSubview:addressBackground];
        
// coupon URL - UITextView
    
    NSString *couponData = [self.detailItem objectForKey:@"couponURL"];
    if (couponData.length > 0) {                                     // Checks for NOT empty string
        NSString *couponPrefix = @"Tap for specials & coupons: ";
        NSString *coupon = [couponPrefix stringByAppendingString:couponData];
        
        UITextView *couponLabel = [[UITextView alloc] initWithFrame:CGRectMake(PADDING, PADDING, contentWidth, 60)];
        couponLabel.text = coupon;
        couponLabel.font = [UIFont fontWithName:@"Times New Roman" size:18];
        
        couponLabel.dataDetectorTypes = UIDataDetectorTypeLink;
        couponLabel.editable = NO;
        
        vertPosition = vertPosition + backgroundHeight + SPACING;
        
        backgroundHeight = 70;          // couponLabel.bounds.size.height + 2*PADDING;
        // NSLog(@"UITextView height is %f", phoneLabel.bounds.size.height);
        RoundedRectBackground *couponBackground = [[RoundedRectBackground alloc] initWithFrame:CGRectMake(SPACING, vertPosition, backgroundWidth, backgroundHeight)];
        [couponBackground addSubview:couponLabel];
        [scrollView addSubview:couponBackground];
    }
    
    
// Sizes the scrollView, dynamically
    CGFloat scrollViewHeight = vertPosition + SPACING + backgroundHeight;
    CGSize scrollViewContentSize = CGSizeMake(self.view.bounds.size.width, scrollViewHeight);
    [scrollView setContentSize:scrollViewContentSize];

}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
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
        self.detailNameLabel.text = [self.detailItem objectForKey:@"name"];
        self.detailPhoneTextView.text = [self.detailItem objectForKey:@"phone"];
/*
        NSString *imageFilename = [self.detailItem objectForKey:@"PhotoName"];
        NSURL *logoImageURL = [[NSURL alloc] initFileURLWithPath:imageFilename];
        self.detailImageView.image
*/        
        self.detailDescriptionTextView.text = [self.detailItem objectForKey:@"description"];
        self.detailAddressLabel.text = @"address";
        self.detailCityLabel.text = [self.detailItem objectForKey:@"city"];
        self.detailWebsiteURLTextView.text = [self.detailItem objectForKey:@"url"];

    } else {
        NSLog(@"The record is NULL");
    }
}

// Creates a pin from the detailItem dictionary
- (void)creatAnnotationPin:(int)i {
    
// Annotations for a single location picked
    // Sets latitude & longitude
    NSString *newLatitudeString = [self.detailItem objectForKey:@"latitude"];
    NSString *newLongitudeString = [self.detailItem objectForKey:@"longitude"];
    double newLatitude = [newLatitudeString doubleValue];
    double newLongitude = [newLongitudeString doubleValue];
    CLLocationCoordinate2D newCoordinates = CLLocationCoordinate2DMake(newLatitude, newLongitude);
    
    NSString *newName = [self.detailItem objectForKey:@"name"];
    NSString *newDescription = [self.detailItem objectForKey:@"description"];
    
    // Calls for a new Country object & adds it to the view & annotations array
    MapItem *aNewPin = [[MapItem alloc] initWithCoordinates:newCoordinates placeName:newName description:newDescription];
    
    [locationMap.mapView addAnnotation:aNewPin];
    [locationMap.mapAnnotations addObject:aNewPin];
    
    NSLog(@"The new pin data is %@", aNewPin);
}


// Moves to other view & sets the detailItem to the selected item
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showMap"]) {
        
        NSLog(@"DetailVC is %@", self.detailItem);
//        NSArray *object = [self.membersArray objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:self.detailItem];
    }
}

@end

