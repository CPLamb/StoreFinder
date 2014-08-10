//
//  MapViewController.h
//  ThinkLocalFirst
//
//  Created by Chris Lamb on 4/20/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//
/* TODO delete this is replaced by BigMapVC
*/

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BigMapViewController.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSMutableArray *mapAnnotations;

@property (strong, nonatomic) id detailItem;    // data dictionary for selected item

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

- (IBAction)dropPinButton:(id)sender;
- (IBAction)directionsButton:(UIButton *)sender;
@end
