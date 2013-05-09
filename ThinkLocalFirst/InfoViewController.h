//
//  InfoViewController.h
//  ThinkLocalFirst
//
//  Created by Chris Lamb on 4/20/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

- (IBAction)sortList:(id)sender;

@end
