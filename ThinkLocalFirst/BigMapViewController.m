//
//  BigMapViewController.m
//  ThinkLocalFirst
//
//  Created by Chris Lamb on 5/16/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import "BigMapViewController.h"
#import "MapItem.h"
#import "NoShopAnnotation.h"
#import "MemberListData.h"
#import "DetailViewController.h"

@interface BigMapViewController ()

@end

@implementation BigMapViewController
@synthesize mapView = _mapView;
@synthesize mapAnnotations = _mapAnnotations;

const float MIN_MAP_ZOOM_METERS = 500.0;
const float MAX_MAP_ZOOM_METERS = 75000.0;
const float DEFAULT_SPAN = 10000.0;
const int  MAX_PINS_TO_DROP = 20;

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

//    NSLog(@"%@ view did load for the first time.", self);
    
// Setup for the mapView
    self.mapView.showsUserLocation = YES;
    [self.mapView setDelegate:self];// set by storyboard
    CLLocationDegrees theLatitude = 36.998;
    CLLocationDegrees theLongitude = -121.9968;
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(theLatitude, theLongitude), MKCoordinateSpanMake(0.5, 0.5)) animated:YES];
    self.mapView.mapType = MKMapTypeStandard;
    
// Sets up the properties
//    [self configureView];
    
// Setup for the annotations & drop a pin at home
    self.mapAnnotations = [[NSMutableArray alloc] init];

}

- (void)viewWillAppear:(BOOL)animated {
//    NSLog(@"%@ WILL appear...", self);
    
    // Loads from data objects
    [self loadPins];
        
    // Centers the view on the box containing all visible pins
    [self calculateCenter];
}

- (void)viewDidAppear:(BOOL)animated {
//    NSLog(@"%@ DID appear...", self);

    [self.mapView setRegion:self.centerRegion animated:YES];
    
    
// Limit the toal number pins to drop to MAX_PINS_TO_DROP so that map view is not too cluttered
    NSLog(@"Pins in the select = %d", [self.mapAnnotations count]);
    
    int annotationsCount = [self.mapAnnotations count];    
// Limits the total number of pins dropped
    if (annotationsCount > MAX_PINS_TO_DROP) {
// Add only MAX_PIN_TO_DROP to the map
        int location = MAX_PINS_TO_DROP;
        int length = [self.mapAnnotations count] - MAX_PINS_TO_DROP;
        NSMutableArray *aClippedArray = [NSMutableArray arrayWithArray:self.mapAnnotations];
        [aClippedArray removeObjectsInRange:NSMakeRange(location, length)];
        [self.mapView addAnnotations:aClippedArray];
    } else {
// Add all of the pins
        [self.mapView addAnnotations:self.mapAnnotations];        
    }
// Displays an annotation the first object
    [self.mapView selectAnnotation:[self.mapAnnotations objectAtIndex:0] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom MapView Methods

// Getter function checks to see if user location is enabled & if not zooms to CPL Labs location
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

- (void)zoomToFitMapAnnotations { 
    
    if ([self.mapView.annotations count] == 0) return;
    int i = 0;
    MKMapPoint points[[self.mapView.annotations count]];
    
    //build array of annotation points
    for (id<MKAnnotation> annotation in [self.mapView annotations]){
        points[i++] = MKMapPointForCoordinate(annotation.coordinate);
    }
 
//    MKPolygon *poly = [MKPolygon polygonWithPoints:points count:i];
//    [self.mapView setRegion:MKCoordinateRegionForMapRect([poly boundingMapRect]) animated:YES];
}

- (void)calculateCenter {
    
    // set min to the highest and max to the lowest so any MIN or MAX calculation will change this value
    CLLocationCoordinate2D minCoord = CLLocationCoordinate2DMake(180, 180.0);
    CLLocationCoordinate2D maxCoord = CLLocationCoordinate2DMake(-180.0, -180.0);
    

//    NSLog(@"Checking min/max coords for %d mapAnnotations", [self.mapAnnotations count]);
    // checks all annotations for min and max (deprecated -- checking pinsArray instead)
    for( MapItem * item in self.mapAnnotations ){
        if ((item.latitude != 0) && (item.longitude != 0)) {
            double lat = [item.latitude doubleValue];
            double lon = [item.longitude doubleValue];
            minCoord.latitude = MIN(minCoord.latitude, lat);
            minCoord.longitude = MIN(minCoord.longitude, lon);
            maxCoord.latitude = MAX(maxCoord.latitude, lat);
            maxCoord.longitude = MAX(maxCoord.longitude, lon);
        }
    }
//
    
// after checking all
    if((self.mapView.userLocation.coordinate.latitude != 0.0) && (self.mapView.userLocation.coordinate.latitude != 0.0)) {
        CLLocationCoordinate2D userCoord = self.referenceLocation.coordinate;
            minCoord.latitude = MIN(minCoord.latitude, userCoord.latitude);
            minCoord.longitude = MIN(minCoord.longitude, userCoord.longitude);
            maxCoord.latitude = MAX(maxCoord.latitude, userCoord.latitude);
            maxCoord.longitude = MAX(maxCoord.longitude, userCoord.longitude);
    }

    CLLocation *minLocation = [[CLLocation alloc] initWithLatitude:minCoord.latitude longitude:minCoord.longitude];
    CLLocation *maxLocation = [[CLLocation alloc] initWithLatitude:maxCoord.latitude longitude:maxCoord.longitude];
    
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake((minCoord.latitude + maxCoord.latitude)/2, (minCoord.longitude + maxCoord.longitude)/2);
    
// Initializes distance at DEFAULT_SPAN if both coordinates are the same
    float distance = 500;
    if ((minCoord.latitude == maxCoord.latitude) && (maxCoord.longitude == maxCoord.longitude)) {
        distance = DEFAULT_SPAN;
    } else {
        distance = [minLocation distanceFromLocation:maxLocation];
    }
    distance = distance * 1.1; // make actual map region slightly larger than distance between points
//    distance = MIN( MAX_MAP_ZOOM_METERS, MAX( distance, MIN_MAP_ZOOM_METERS ) );
    
//    NSLog(@"Setting mapView.centerRegion to (%f, %f) with distance %f", centerCoordinate.latitude , centerCoordinate.longitude, distance);

    self.centerRegion = MKCoordinateRegionMakeWithDistance(centerCoordinate, distance, distance);
}


#pragma mark - Custom Annotation methods

- (NSArray*)pinsArray {
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
    
//    NSLog(@"Accessing pinsArray with count = %d", [pinsArray count]);
    return pinsArray;
}

- (void)loadPins {

// Deletes all prior pins
    [self removeAllPins:nil];

// Figure out the closest pin to the user
//    id<MKAnnotation> defaultPin = nil;
    double closestDistance = DBL_MAX;   // set distance to furthest so first result is less than this

    for( NSDictionary* d in self.pinsArray ){
        
//        NSLog(@"[map] adding pin with data (%@ type): %@", NSStringFromClass([d class]), d);
        
        NSString *aLatitudeString = [d objectForKey:@"latitude"];
        NSString *aLongitudeString = [d objectForKey:@"longitude"];
        double aLatitude = [aLatitudeString doubleValue];
        double aLongitude = [aLongitudeString doubleValue];
        CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(aLatitude, aLongitude);
        BOOL hasShop = [[d objectForKey:@"hasShop"] boolValue];
        
//        NSString *aName = [d objectForKey:@"name"];
//        NSString *aDescription = [d objectForKey:@"description"];
//        BOOL hasShop = [d objectForKey:@"hasShop"];
        
//        MapItem *aNewPin = [[MapItem alloc] initWithCoordinates:coordinates placeName:aName description:aDescription];
        
        // Adds annotations to the mapAnnotations array depending upon hasShop Boolean
        if (hasShop) {
            MapItem *aNewPin = [[MapItem alloc] initWithCoordinates:coordinates memberData:d];
            aNewPin.memberData = d; // set data about the member so it can be passed to annotations and disclosures
            [self.mapAnnotations addObject:aNewPin];
//            NSLog(@"HAS SHOP %@", aNewPin);
        } else {
            NoShopAnnotation *aNewPin = [[NoShopAnnotation alloc] initWithCoordinates:coordinates memberData:d];
            aNewPin.memberData = d; // set data about the member so it can be passed to annotations and disclosures
            [self.mapAnnotations addObject:aNewPin];
//            NSLog(@"NO SHOP %@", aNewPin);
        }
        

    // Get distance between this new pin and the stored reference location (the user location or a faked Santa Cruz lat/long if location is disabled)
        CLLocation* loc = [[CLLocation alloc] initWithLatitude:aLatitude longitude:aLongitude];
        
        // Get the distance and store the closest annotation
        double dist = [self.referenceLocation distanceFromLocation:loc];
        if( dist > 0 && dist < closestDistance ){
            closestDistance = dist;
//            defaultPin = aNewPin;
        }
    }
    // If defaultPin is set, select it when we view the map
    [self.mapView selectAnnotation:self.defaultPin animated:YES];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    [self zoomToFitMapAnnotations];
    
    // If defaultPin is set, select it when we view the map
    [self.mapView selectAnnotation:self.defaultPin animated:YES];    
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

- (IBAction)removeAllPins:(UIButton *)sender {
//    NSLog(@"Removing %d annotations from mapAnnotation array", [self.mapAnnotations count]);
    [self.mapAnnotations removeAllObjects];
    
//    NSLog(@"Removing %d annotations from mapView annotations", [self.mapView.annotations count]);
    [self.mapView removeAnnotations:self.mapView.annotations];
}


#pragma mark - MapView Annotation Methods


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
// Sends User to the DetailViewController
        
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
//        NSLog(@"The annotation is %@", annotation);
        // try to dequeue an existing pin view first
        static NSString *BridgeAnnotationIdentifier = @"bridgeAnnotationIdentifier";
        
        MKPinAnnotationView *pinView =
        (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:BridgeAnnotationIdentifier];
        if (pinView == nil)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation
                                                  reuseIdentifier:BridgeAnnotationIdentifier];
            customPinView.pinColor = MKPinAnnotationColorPurple;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            customPinView.image = [UIImage imageNamed:@"lobster.png"];
//            NSLog(@"The customPinView is %@", customPinView);

                      
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//            [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
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
            customPinView.image = [UIImage imageNamed:@"dolphins.png"];
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;
            
            return customPinView;
        }
    }
    return nil;
}

@end
