//
//  MapViewController.m
//  ThinkLocalFirst
//
//  Created by Chris Lamb on 4/20/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import "MapViewController.h"
#import "MapItem.h"
#import "NoShopAnnotation.h"


@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapView = _mapView;
@synthesize mapAnnotations = _mapAnnotations;
@synthesize nameLabel = _nameLabel;


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
    
// Setup for the mapView
    self.mapView.showsUserLocation = YES;
    [self.mapView setDelegate:self];
    CLLocationDegrees theLatitude =  37;   //[self.detailItem objectForKey:@"Latitude"];
    CLLocationDegrees theLongitude = -122; // [self.detailItem objectForKey:@"Longitude"];
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(theLatitude, theLongitude), MKCoordinateSpanMake(1.0, 1.0)) animated:YES];
    self.mapView.mapType = MKMapTypeStandard;

// Sets up properties
    [self configureView];
    
// Setup for annotations & drop a pin at home
    self.mapAnnotations = [[NSMutableArray alloc] initWithCapacity:20];

// sets the properties of the annotation pin
    CLLocationDegrees pinLatitude = [[self.detailItem objectForKey:@"latitude"] doubleValue];
    CLLocationDegrees pinLongitude = [[self.detailItem objectForKey:@"longitude"] doubleValue];
    NSString *pinName = [self.detailItem objectForKey:@"name"];
    NSString *pinDescription = [self.detailItem objectForKey:@"phone"];     // description
    
    CLLocationCoordinate2D pinCoordinates = CLLocationCoordinate2DMake(pinLatitude, pinLongitude);
    MapItem *droppedPin = [[MapItem alloc] initWithCoordinates:pinCoordinates placeName:pinName description:pinDescription];
    

// Adds the pin to the view
    [self.mapView addAnnotation:droppedPin];

    
//    NSLog(@"MapVC Member selected is %@", self.detailItem);
}

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAll;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Custom methods

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
//    NSLog(@"This is mapViews detailItem %@", self.detailItem);
}

- (void)configureView
{
// Update the user interface whenever the detail item changes.
    
    if (self.detailItem) {
// Get latitude & longitude doubles from the detailItem dictionary
        NSString *countryLatitude = [self.detailItem objectForKey:@"latitude"];
        double latitudeNumber = [countryLatitude doubleValue];
        CLLocationDegrees latitudeLocation = latitudeNumber;
        
        NSString *countryLongitude = [self.detailItem objectForKey:@"longitude"];
        double longitudeNumber = [countryLongitude doubleValue];
        CLLocationDegrees longitudeLocation = longitudeNumber;
        
// Getting area in square miles to calculate the span
        NSString *areaString = @"12";           // [self.detailItem objectForKey:@"Area"];
        int area = [areaString intValue];
        double span = [self calculateSpan:area];
        
// Moving & redsizing the mapview region
        self.nameLabel.text = [self.detailItem objectForKey:@"name"];
        self.descriptionLabel.text = [NSString stringWithFormat:@"Located at %3.2f %3.2f, Span = %2.1f", latitudeNumber, longitudeNumber, span];
        [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(latitudeLocation, longitudeLocation), MKCoordinateSpanMake(span, span)) animated:YES];
    }
}

#pragma mark - mapView methods

- (double )calculateSpan:(int )area {
    //    NSLog(@"The area = %d", area);
    double span = (sqrt(area))*0.014;
    if (span >= 15.0) {
        span = 15.0;
    }
    //    NSLog(@"Calculating the span = %2.1f", span);
    return span;
}

// Delete?
- (IBAction)dropPinButton:(id)sender {
//    NSLog(@"Drops a pin close to my home");
    CLLocationCoordinate2D aNewLocation = CLLocationCoordinate2DMake(36.968, -121.9987);
    MapItem *aNewPin = [[MapItem alloc] initWithCoordinates:aNewLocation placeName:@"CPL Labs" description:@"close by"];
    [self.mapAnnotations addObject:aNewPin];
    [self.mapView addAnnotation:aNewPin];
}

- (IBAction)directionsButton:(UIButton *)sender {
//    NSLog(@"uses Apples Maps to provide directions");
    
    
    MKPlacemark *myPlacemark = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(36.4, -121.75) addressDictionary:nil];
    MKMapItem *myLocation = [[MKMapItem alloc] initWithPlacemark:myPlacemark];
    // MKMapItem *myLocation = [MKMapItem mapItemForCurrentLocation];
    
    MKPlacemark *memberPlacemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(36.0, -122.0) addressDictionary:nil];
    MKMapItem *memberLocation = [[MKMapItem alloc] initWithPlacemark:memberPlacemark];
    
    NSArray *from = [NSArray arrayWithObjects:myLocation, memberLocation, nil];
    CLLocation *fromLocation = myLocation.placemark.location;
    
    // Create a region centered on the starting point with a 10km span    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(fromLocation.coordinate, 10000, 10000);
 
    // Open the item in Maps, specifying the map region to display.    
    [MKMapItem openMapsWithItems:[NSArray arrayWithObject:from]     
                   launchOptions:[NSDictionary dictionaryWithObjectsAndKeys:                                  
                                  [NSValue valueWithMKCoordinate:region.center], MKLaunchOptionsMapCenterKey,
                                  [NSValue valueWithMKCoordinateSpan:region.span], MKLaunchOptionsMapSpanKey, nil]];
}

// Sends User to the DetailViewController
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
//    NSLog(@"Somebody TAPPED me!");
    [self removeFromParentViewController];
}

// Configures the Annotation popup
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // in case it's the user location, we already have an annotation, so just return nil
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    // handles our custom annotation look N feel
    if ([annotation isKindOfClass:[MapItem class]])         // for Members with offices
    {
        // try to dequeue an existing pin view first
        static NSString *BridgeAnnotationIdentifier = @"bridgeAnnotationIdentifier";
        
        MKPinAnnotationView *pinView =
        (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:BridgeAnnotationIdentifier];
        if (pinView == nil)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:BridgeAnnotationIdentifier];
            customPinView.pinColor = MKPinAnnotationColorPurple;
            customPinView.alpha = 0.87;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;
            
            return customPinView;
        }
    }
    if ([annotation isKindOfClass:[NoShopAnnotation class]]) {      // for Members with NO offices
        // try to dequeue an existing pin view first
        static NSString *noShopAnnotationIdentifier = @"noShopAnnotationIdentifier";
        
        MKPinAnnotationView *pinView =
        (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:noShopAnnotationIdentifier];
        if (pinView == nil)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:noShopAnnotationIdentifier];
            customPinView.pinColor = MKPinAnnotationColorGreen;
            customPinView.alpha = 1.00;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;
            
            return customPinView;
        }
    }
    return nil;
}

@end
