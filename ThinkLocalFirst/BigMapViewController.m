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
#import "DetailViewController.h"

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
        
    // Centers the view on the box containing all visible pins
    [self calculateCenter];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom MapView Methods

//- (double )calculateSpan:(int )area {
//    //    NSLog(@"The area = %d", area);
//    double span = (sqrt(area))*0.014;
//    if (span >= 15.0) {
//        span = 15.0;
//    }
//    //    NSLog(@"Calculating the span = %2.1f", span);
//    return span;
//}

- (CLLocation*)referenceLocation {
    if( _referenceLocation == nil ){
        CLLocationCoordinate2D userCoord = self.mapView.userLocation.location.coordinate;
        if( self.mapView.userLocation.location == nil ||
           (userCoord.latitude == 0.0 && userCoord.longitude == 0.0) ){
            // If user location can't be found, fake it
            userCoord = CLLocationCoordinate2DMake(36.968, -121.9987);
        } else {
            _referenceLocation = self.mapView.userLocation.location;
        }
    }
    return _referenceLocation;
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
        CLLocationCoordinate2D userCoord = self.referenceLocation.coordinate;
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


#pragma mark - Custom Annotation methods

- (void)loadPins {
    NSMutableArray *pinsArray = [NSMutableArray array];
    
    // If a single detailItem is set, prefer that to the list of all pins
    if (self.detailItem != nil) {
        [pinsArray addObject:self.detailItem];
    } else {
        // Otherwise show all pins in the namesArray
        for( id arrayOrDict in MEMBERLISTDATA.namesArray ){
            // Flatten any arrays (needed in data for sorting lists with categories)
            if( [arrayOrDict isKindOfClass:[NSArray class]] ){
                [pinsArray addObjectsFromArray:arrayOrDict];
            }
            else {
                [pinsArray addObject:arrayOrDict];
            }
        }
    }
    
    
    NSLog(@"pinsArray count = %d", [pinsArray count]);
    
// Deletes all prior pins
    [self removeAllPins:nil];

    // Figure out the closest pin to the user
    id<MKAnnotation> defaultPin = nil;
    double closestDistance = DBL_MAX;   // set distance to furthest so first result is less than this

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

        aNewPin.memberData = d; // set data about the member so it can be passed to annotations and disclosures
        
        [self.mapAnnotations addObject:aNewPin];

    // Get distance between this new pin and the stored reference location (the user location or a faked Santa Cruz lat/long if location is disabled)
        CLLocation* loc = [[CLLocation alloc] initWithLatitude:aLatitude longitude:aLongitude];
        
        // Get the distance and store the closest annotation
        double dist = [self.referenceLocation distanceFromLocation:loc];
        if( dist > 0 && dist < closestDistance ){
            closestDistance = dist;
            defaultPin = aNewPin;
        }

    
    }
    [self.mapView addAnnotations:self.mapAnnotations];

    [self.mapView selectAnnotation:defaultPin animated:YES];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender  {
    
    // Show Details screen
    if ([[segue identifier] isEqualToString:@"showDetails"]) {
        // Sender should be the member data corresponding to the touched annotation
        MapItem* item = sender;
        DetailViewController* dvc = [segue destinationViewController];
        NSLog(@"Preparing for segue with identifier '%@' to show item: %@", [segue identifier], item);
        dvc.detailItem = item.memberData;
    }
    
}


/*
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
*/

- (IBAction)removeAllPins:(UIButton *)sender {
    NSLog(@"Removing %d annotations from mapAnnotation array", [self.mapAnnotations count]);
    [self.mapAnnotations removeAllObjects];

    NSLog(@"Removing %d annotations from mapView annotations", [self.mapView.annotations count]);
    [self.mapView removeAnnotations:self.mapView.annotations];
}


#pragma mark - MapView Annotation Methods
// Sends User to the DetailViewController
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id<MKAnnotation> sender = view.annotation;
    NSLog(@"Performing segue to detail view for annotation view: %@", sender);
    [self performSegueWithIdentifier:@"showDetails" sender:sender];
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
            
            // add a detail disclosure button to the callout which will open a new view controller page
            //
            // note: when the detail disclosure button is tapped, we respond to it via:
            //       calloutAccessoryControlTapped delegate method
            //
            // by using "calloutAccessoryControlTapped", it's a convenient way to find out which annotation was tapped
            //
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//            [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;
            
            return customPinView;
        }
    }    
    return nil;
}

@end
