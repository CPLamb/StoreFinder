//
//  BigMapViewController.m
//  ThinkLocalFirst
//
//  Created by Chris Lamb on 5/16/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import "BigMapViewController.h"
#import "MapItem.h"
#import "MemberListData.h"

@interface BigMapViewController ()

@end

@implementation BigMapViewController
@synthesize mapView = _mapView;
@synthesize mapAnnotations = _mapAnnotations;

const float MIN_MAP_ZOOM_METERS = 500.0;

#pragma mark - View lifecycle methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

// Add us as the delegate for tab changes in the app
    ((UITabBarController*)self.parentViewController).delegate = self;
    
    
// Setup for the mapView
    self.mapView.showsUserLocation = YES;
    [self.mapView setDelegate:self];
    CLLocationDegrees theLatitude = 36.998;
    CLLocationDegrees theLongitude = -121.9968;
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(theLatitude, theLongitude), MKCoordinateSpanMake(0.5, 0.5)) animated:YES];
    self.mapView.mapType = MKMapTypeStandard;
    
// Sets up the properties
//    [self configureView];
    
// Setup for the annotations & drop a pin at home
    self.mapAnnotations = [[NSMutableArray alloc] init];
    
/* Sets the properties of the annotation pin
    CLLocationDegrees pinLatitude = 36.9986;        //[[self.detailItem objectForKey:@"latitude"] doubleValue];
    CLLocationDegrees pinLongitude = -121.9987;     //[[self.detailItem objectForKey:@"longitude"] doubleValue];
    NSString *pinName = @"CPLambLabs";              //[self.detailItem objectForKey:@"name"];
    NSString *pinDescription = @"awesome apps!";     //[self.detailItem objectForKey:@"phone"];     // description
    
    CLLocationCoordinate2D pinCoordinates = CLLocationCoordinate2DMake(pinLatitude, pinLongitude);
    MapItem *droppedPin = [[MapItem alloc] initWithCoordinates:pinCoordinates placeName:pinName description:pinDescription];
    [self.mapAnnotations addObject:droppedPin];

    MapItem *anotherMember = [[MapItem alloc]initWithCoordinates:CLLocationCoordinate2DMake(37.0075, -121.925) placeName:@"Freddys Crab Shack" description:@"another place"];
    [self.mapAnnotations addObject:anotherMember];
//    [self.mapView addAnnotation:anotherMember];
*/    
}

- (void)viewWillAppear:(BOOL)animated {
    // Loads from data objects
    [self loadPins];
    
    //Adds the pin to the view
    [self.mapView addAnnotations:self.mapAnnotations];
    [self calculateCenter];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (void)calculateCenter {
    
    // set min to the highest and max to the lowest so any MIN or MAX calculation will change this value
    CLLocationCoordinate2D minCoord = CLLocationCoordinate2DMake(180.0, 180.0);
    CLLocationCoordinate2D maxCoord = CLLocationCoordinate2DMake(-180.0, -180.0);
    
    
    // check all annotations for min and 
    for( MapItem * item in self.mapView.annotations ){
        double lat = [item.latitude doubleValue];
        double lon = [item.longitude doubleValue];
        minCoord.latitude = MIN(minCoord.latitude, lat);
        minCoord.longitude = MIN(minCoord.longitude, lon);
        maxCoord.latitude = MAX(maxCoord.latitude, lat);
        maxCoord.longitude = MAX(maxCoord.longitude, lon);
    }
    
    
    // after checking all
    if( self.mapView.userLocation != nil ){
        CLLocationCoordinate2D userCoord = self.mapView.userLocation.coordinate;
        if( userCoord.latitude == 0.0 && userCoord.longitude == 0.0 ){
            // If user location can't be found, fake it
            userCoord = CLLocationCoordinate2DMake(36.968, -121.9987);
        }
    
            minCoord.latitude = MIN(minCoord.latitude, userCoord.latitude);
            minCoord.longitude = MIN(minCoord.longitude, userCoord.longitude);
            maxCoord.latitude = MAX(maxCoord.latitude, userCoord.latitude);
            maxCoord.longitude = MAX(maxCoord.longitude, userCoord.longitude);
    }
    
    
    CLLocation *minLocation = [[CLLocation alloc] initWithLatitude:minCoord.latitude longitude:minCoord.longitude];
    CLLocation *maxLocation = [[CLLocation alloc] initWithLatitude:maxCoord.latitude longitude:maxCoord.longitude];
    
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake((minCoord.latitude + maxCoord.latitude)/2, (minCoord.longitude + maxCoord.longitude)/2);
    
    float distance = [minLocation distanceFromLocation:maxLocation];
    distance *= 1.1; // make actual map region slightly larger than distance between points
    distance = MAX( distance, MIN_MAP_ZOOM_METERS );
    
    
    MKCoordinateRegion mapRegion = MKCoordinateRegionMakeWithDistance(centerCoordinate, distance, distance);
//    mapRegion = [self.mapView regionThatFits:mapRegion]; // fit to non-square screens
    
    NSLog(@"About to center the mapview at (%f, %f) with distance %f", centerCoordinate.latitude , centerCoordinate.longitude, distance);
    
    [self.mapView setRegion:mapRegion animated:YES];
    
}


#pragma mark - UITbBarDelegate methods

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSLog(@"Tab bar tab item pressed %@", viewController);
}

#pragma mark - Custom methods

- (void)loadPins {
    NSArray *pinsArray;
    if (self.detailItem != nil) {
        pinsArray = [NSArray arrayWithObject:self.detailItem];
    } else {
        pinsArray = MEMBERLISTDATA.namesArray;
    }
            
    NSLog(@"pinsArray count = %d", [pinsArray count]);
    
// Deletes all prior pins
    [self removeAllPins:nil];
    
//    for (int i=0; i<[pinsArray count]; i++) {
    for( NSDictionary* d in pinsArray ){
        
        NSLog(@"[map] adding pin with data (%@ type): %@", NSStringFromClass([d class]), d);
        
        NSString *aLatitudeString = [d objectForKey:@"latitude"];
        NSString *aLongitudeString = [d objectForKey:@"longitude"];
        double aLatitude = [aLatitudeString doubleValue];
        double aLongitude = [aLongitudeString doubleValue];
        CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(aLatitude, aLongitude);
        
        NSString *aName = [d objectForKey:@"name"];
        NSString *aDescription = [d objectForKey:@"description"];
        
        MapItem *aNewPin = [[MapItem alloc] initWithCoordinates:coordinates placeName:aName description:aDescription];
        [self.mapAnnotations addObject:aNewPin];
    }
    [self.mapView addAnnotations:self.mapAnnotations];
}

// Custom setter method for mapAnnotations
- (void)setMapAnnotations:(NSMutableArray *)newMapAnnotations {
    NSLog(@"How's this setter thang work?");
    if (_mapAnnotations != newMapAnnotations) {
        _mapAnnotations = newMapAnnotations;
        [self configureView];
    }
    NSLog(@"This is the map Annotations array %@", self.mapAnnotations);
}

- (void)configureView
{
    // Update the user interface whenever the detail item changes.
    
    if (self.mapAnnotations) {
        // Get latitude & longitude doubles from the detailItem dictionary
        NSString *countryLatitude = @"37.0";       //[self.detailItem objectForKey:@"latitude"];
        double latitudeNumber = [countryLatitude doubleValue];
        CLLocationDegrees latitudeLocation = latitudeNumber;
        
        NSString *countryLongitude = @"-122";        //[self.detailItem objectForKey:@"longitude"];
        double longitudeNumber = [countryLongitude doubleValue];
        CLLocationDegrees longitudeLocation = longitudeNumber;
        
        // Getting area in square miles to calculate the span
        NSString *areaString = @"12";           // [self.detailItem objectForKey:@"Area"];
        int area = [areaString intValue];
        double span = [self calculateSpan:area];
//        [self calculateCenter];

        // Moving & redsizing the mapview region
//        self.nameLabel.text = [self.detailItem objectForKey:@"name"];
//        self.descriptionLabel.text =  [NSString stringWithFormat:@"Located at %3.2f %3.2f, Span = %2.1f", latitudeNumber, longitudeNumber, span];
        [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(latitudeLocation, longitudeLocation), MKCoordinateSpanMake(span, span)) animated:YES];
 
    }
}


- (IBAction)dropPinButton:(id)sender {
    NSLog(@"Drops a pin close to my home");

    CLLocationCoordinate2D aNewLocation = CLLocationCoordinate2DMake(36.968, -121.9987);
    MapItem *aNewPin = [[MapItem alloc] initWithCoordinates:aNewLocation placeName:@"CPLamb Labs" description:@"awesome apps!"];
    [self.mapAnnotations addObject:aNewPin];
    [self.mapView addAnnotation:aNewPin];
 
}

- (IBAction)removeAllPins:(UIButton *)sender {
    NSLog(@"Removing %d annotations from mapAnnotation array", [self.mapAnnotations count]);
    [self.mapAnnotations removeAllObjects];

    NSLog(@"Removing %d annotations from mapView annotations", [self.mapView.annotations count]);
    [self.mapView removeAnnotations:self.mapView.annotations];
}


@end
