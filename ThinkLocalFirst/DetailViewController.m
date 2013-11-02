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
#import "NoShopAnnotation.h"
#import "RoundedRectBackground.h"
#import "CouponOfferViewController.h"
#import "TestingViewController.h"

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
    
    // Builds the custom background bubbles for all 7 fields
    [self assembleBackgrounds];

//    NSLog(@"DetailVC Member selected is %@", self.detailItem);
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
//        NSString *path = [[NSBundle mainBundle] pathForResource:photo ofType:@"jpg"]; //png,jpg
        
        UIImage *photoImage = [UIImage imageNamed:photo];
        
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
    if (description.length > 0) {
        // Calcs height of the textView based on the # of characters in a line
        //    CGFloat textViewHeight = ((description.length/8)+1) * 1;
        CGFloat textViewHeight = description.length / 1.25;
  //      NSLog(@"Description length = %d", description.length);
        
        UITextView *descriptionField = [[UITextView alloc] initWithFrame:CGRectMake(PADDING, PADDING, contentWidth, textViewHeight)];
        descriptionField.text = description;
        descriptionField.font = [UIFont fontWithName:@"Times New Roman" size:18];
        descriptionField.dataDetectorTypes = UIDataDetectorTypeNone;
        descriptionField.editable = NO;
        descriptionField.scrollEnabled = NO;
        
        vertPosition = vertPosition + backgroundHeight + SPACING;
        
        backgroundHeight = textViewHeight + 2*PADDING;
        // NSLog(@"Description length is %f", textViewHeight);
        RoundedRectBackground *descriptionBackground = [[RoundedRectBackground alloc] initWithFrame:CGRectMake(SPACING, vertPosition, backgroundWidth, backgroundHeight)];
        [descriptionBackground addSubview:descriptionField];
        [scrollView addSubview:descriptionBackground];
    }
    
// Website URL - UITextView
    NSString *websiteData = [self.detailItem objectForKey:@"url"];
    if (websiteData.length >0) {
        NSString *websitePrefix = @"Tap to visit:                          ";
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
    }

    
// coupon URL - UITextView    
    NSString *couponData = [self.detailItem objectForKey:@"couponOffer"];
    if (couponData.length > 0) {                                     // Checks for NOT empty string
        
        // Calculates the required height of the background
        CGFloat couponDataHeight = couponData.length / 1.25;
        if (couponDataHeight < 35) couponDataHeight = 60;       // sets minimum height for 2 lines
        
        NSString *couponPrefix = @"Coupon details:                                  ";
        NSString *coupon = [couponPrefix stringByAppendingString:couponData];
        
        UITextView *couponLabel = [[UITextView alloc] initWithFrame:CGRectMake(PADDING, PADDING, contentWidth, couponDataHeight)];
        couponLabel.text = coupon;
        couponLabel.font = [UIFont fontWithName:@"Times New Roman" size:18];
        
        couponLabel.editable = NO;
        couponLabel.scrollEnabled = NO;
        
        vertPosition = vertPosition + backgroundHeight + SPACING;        
        backgroundHeight = couponDataHeight + 2*PADDING;

    //    NSLog(@"UITextView = %f & background = %f, %d", couponDataHeight, backgroundHeight,couponData.length);
        
    // create & initialize a tap recognizer for the coupon view
        UITapGestureRecognizer *tapForCoupon = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(displayCoupon)];
        tapForCoupon.numberOfTapsRequired = 1;
        
    // Makes the custom background & adds it to the view
        RoundedRectBackground *couponBackground = [[RoundedRectBackground alloc] initWithFrame:CGRectMake(SPACING, vertPosition, backgroundWidth, backgroundHeight)];
        
    // Adds the gesture to the background
        [couponBackground addGestureRecognizer:tapForCoupon];
        
        [couponBackground addSubview:couponLabel];
        [scrollView addSubview:couponBackground];
    }
    
    
// Sizes the scrollView, dynamically
    CGFloat scrollViewHeight = vertPosition + SPACING + backgroundHeight + 100.0;
    CGSize scrollViewContentSize = CGSizeMake(self.view.bounds.size.width, scrollViewHeight);
    [scrollView setContentSize:scrollViewContentSize];

}

- (IBAction)displayCoupon
{
//    NSLog(@"This method displays a coupon by tapping on the background");
    
    // Get coupon values for the selected member
    NSString *memberName = [self.detailItem objectForKey:@"name"];
    NSString *couponOffer = [self.detailItem objectForKey:@"couponOffer"];
    NSString *expireDate = [self.detailItem objectForKey:@"expirationDate"];
    
    // Lists them for reference
//    NSLog(@"%@ has %@ expires on %@", memberName, couponOffer, expireDate);
    
// Get a couponOffer object & assign above values to it.
    // Object needs to be instantiated with this method because the objects are created in storyboard
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    CouponOfferViewController *thisCoupon = [storyBoard instantiateViewControllerWithIdentifier:@"CouponOfferVC"];
    
    UILabel *expireDateLabel = [[UILabel alloc] init];
    [expireDateLabel setText:expireDate];
    [thisCoupon setExpireDateString:expireDateLabel];
    
    UITextView *couponTextView = [[UITextView alloc] init];
    [couponTextView setText:couponOffer];
    [thisCoupon setCouponOffer:couponTextView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setText:memberName];
    [thisCoupon setName:nameLabel];
    
    NSLog(@"%@ has %@ expires on %@", thisCoupon.name.text, thisCoupon.couponOffer.text, thisCoupon.expireDateString.text);
    
    // pushes the couponView onto the stack
    [thisCoupon setDetailItem:self.detailItem];
    [self presentViewController:thisCoupon animated:YES completion:nil];
    
    
//    NSArray *object = [[self.namesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//    [[segue destinationViewController] setDetailItem:object];

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
 //       NSLog(@"The record is NULL");
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
    NSString *newDescription = [self.detailItem objectForKey:@"phone"];
    BOOL hasShop = [[self.detailItem objectForKey:@"hasShop"] boolValue];
    
// Calls for a new MapItem object & adds it to the view & annotations array
    
    if (hasShop) {
        MapItem *aNewPin = [[MapItem alloc] initWithCoordinates:newCoordinates placeName:newName description:newDescription];
  //      NSLog(@"The new pin is MapItem %@", aNewPin);
        [self addAnAnnotation:aNewPin];
    } else {
        NoShopAnnotation *aNewPin = [[NoShopAnnotation alloc] initWithCoordinates:newCoordinates placeName:newName description:newDescription];
  //      NSLog(@"The new pin is NoShopAnnotation %@", aNewPin);
        [self addAnAnnotation:aNewPin];
    }
/*
    [locationMap.mapView addAnnotation:aNewPin];    
    [locationMap.mapView selectAnnotation:aNewPin animated:YES];
    [locationMap.mapAnnotations addObject:aNewPin];    
    NSLog(@"The new pin data is %@", aNewPin);
*/    
}

- (void)addAnAnnotation:(MapItem *)newPin {
    [locationMap.mapView addAnnotation:newPin];
    [locationMap.mapView selectAnnotation:newPin animated:YES];
    [locationMap.mapAnnotations addObject:newPin];
}


// Moves to other view & sets the detailItem to the selected item
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 //   NSLog(@"Segue ID is %@", [segue identifier]);

    
    if ([[segue identifier] isEqualToString:@"showMap"]) {
        
        [[segue destinationViewController] setDetailItem:self.detailItem];
    }
    
// Show Coupon screen
    if ([[segue identifier] isEqualToString:@"showCoupon02"]) {
                
//        NSArray *object = [[self.detailItem objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:self.detailItem];
    }

}

@end

