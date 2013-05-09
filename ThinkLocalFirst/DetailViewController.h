//
//  DetailViewController.h
//  ThinkLocalFirst
//
//  Created by Chris Lamb on 4/21/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "RoundedRectBackground.h"

@interface DetailViewController : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIButton *detailCouponButton;
    MapViewController *locationMap;
    IBOutlet UIScrollView * inputScrollView;
}
//@property (strong, nonatomic) IBOutlet UIScrollView *inputScrollView;
@property (strong, nonatomic) id detailItem;        // selected item data dictionary TODO: recast  

@property (strong, nonatomic) IBOutlet UILabel *detailNameLabel;
@property (strong, nonatomic) IBOutlet UITextView *detailPhoneTextView;
@property (strong, nonatomic) IBOutlet UIImageView *detailImageView;
@property (strong, nonatomic) IBOutlet UITextView *detailDescriptionTextView;
@property (strong, nonatomic) IBOutlet UILabel *detailAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailCityLabel;
@property (strong, nonatomic) IBOutlet UITextView *detailWebsiteURLTextView;

@end
