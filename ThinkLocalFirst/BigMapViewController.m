//
//  BigMapViewController.m
//  ThinkLocalFirst
//
//  Created by Chris Lamb on 5/16/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import "BigMapViewController.h"
#import "MapItem.h"

@interface BigMapViewController ()

@end

@implementation BigMapViewController
@synthesize mapView = _mapView;

#pragma mark - View lifecycle methods

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom methods

- (IBAction)dropPinButton:(id)sender {
    NSLog(@"Drops a pin close to my home");
/*
    CLLocationCoordinate2D aNewLocation = CLLocationCoordinate2DMake(36.968, -121.9987);
    MapItem *aNewPin = [[MapItem alloc] initWithCoordinates:aNewLocation placeName:@"CPL Labs" description:@"close by"];
    [self.mapAnnotations addObject:aNewPin];
    [self.mapView addAnnotation:aNewPin];
*/ 
}


@end
