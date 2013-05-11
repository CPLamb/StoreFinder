//
//  MasterViewController.h
//  ThinkLocalFirst
//
//  Created by Chris Lamb on 4/20/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "MapViewController.h"
#import "InfoViewController.h"
#import "SortSelectionViewController.h"

@interface MasterViewController : UITableViewController <SortSelectionViewControllerDelegate, UISearchDisplayDelegate, UISearchBarDelegate>  {
    
    BOOL sortedByCategory;
    NSArray *membersArray;
}
@property (nonatomic, strong) DetailViewController *memberViewController;
@property (nonatomic, strong) InfoViewController *infoViewController;

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) NSIndexPath *tempIndexPath;

@property (nonatomic, strong) NSArray *membersArray;    // Master array of dictionaries from the PList
@property (strong, nonatomic) NSArray *namesArray;      // Name of each member object By Letter TODO: delete?
@property (strong, nonatomic) NSArray *indexArray;      // Letters used for sections index
@property (strong, nonatomic) NSArray *anArrayOfShortenedWords;

@property (nonatomic, strong) IBOutlet UISearchBar *mySearchBar;
@property (nonatomic, strong) NSString *searchString;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) NSMutableArray *filteredArray;

@property (weak, nonatomic) IBOutlet UIView *sortSelectionView; //TODO: delete?

- (IBAction)sortListButton:(UIBarButtonItem *)sender;
- (IBAction)showAllButton:(UIBarButtonItem *)sender;

@end
