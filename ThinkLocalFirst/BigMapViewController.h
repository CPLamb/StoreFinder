//
//  BigMapViewController.h
//  ThinkLocalFirst
//
//  Created by Chris Lamb on 5/16/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
/*
    This mapVC is managed by the tabBar controller and is a map of ALL items pins in
    the current tableView filter
*/ 

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface BigMapViewController : UIViewController <MKMapViewDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSMutableArray *mapAnnotations;

- (IBAction)dropPinButton:(UIButton *)sender;
- (IBAction)removeAllPins:(UIButton *)sender;

@end
