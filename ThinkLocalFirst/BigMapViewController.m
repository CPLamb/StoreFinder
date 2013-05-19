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
    self.mapAnnotations = [[NSMutableArray alloc] initWithCapacity:400];
    
// Sets the properties of the annotation pin
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
    
// Loads from data objects
    [self loadPins];
    
//Adds the pin to the view
    [self.mapView addAnnotations:self.mapAnnotations];
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

#pragma mark - Custom methods

- (void)loadPins {
    NSArray *pinsArray = MEMBERLISTDATA.namesArray;
    NSLog(@"pinsArray count = %d", [pinsArray count]);
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
    NSLog(@"Zeros out the manAnnotation array %d", [self.mapAnnotations count]);

    [self.mapAnnotations removeAllObjects];
    [self.mapView removeAnnotations:self.mapAnnotations];
}


@end
