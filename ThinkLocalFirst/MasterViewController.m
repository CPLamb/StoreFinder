//
//  MasterViewController.m
//  ThinkLocalFirst
//
//  Created by Chris Lamb on 4/20/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import "MasterViewController.h"
#import "MemberListData.h"

@interface MasterViewController () {
    NSMutableArray *_objects;

}
@end

@implementation MasterViewController

@synthesize memberListAll = _memberListAll;

@synthesize memberViewController = _memberViewController;
@synthesize infoViewController = _infoViewController;
@synthesize sortSelectionView = _sortSelectionView;
//@synthesize bigMapViewController = _bigMapViewController;

@synthesize detailItem = _detailItem;

@synthesize membersArray = _membersArray;
@synthesize namesArray = _namesArray;
@synthesize indexArray = _indexArray;
@synthesize anArrayOfShortenedWords = _anArrayOfShortenedWords;
@synthesize tempIndexPath = _tempIndexPath;

@synthesize mySearchBar = _mySearchBar;
@synthesize searchString = _searchString;
@synthesize searchArray = _searchArray;
@synthesize filteredArray = _filteredArray;

#pragma mark - View Lifecycle methods

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
//    [self loadPlistData];
    
    sortedByCategory = NO;
    filteredByCoupons = NO;
    self.navigationItem.title = @"List";

// Assigns the data object to the local membersArray
//    AppDelegate* appDel = [[UIApplication sharedApplication] delegate];
//    MemberListData* sharedData = appDel.memberData;
    
    
    self.membersArray = [NSArray arrayWithArray: MEMBERLISTDATA.membersArray];
    
// Makes up the index array & the sorted array for the cells
    [self makeSectionsIndex:self.membersArray];
    [self makeIndexedArray:self.membersArray withIndex:self.indexArray];

// Initializes Search properties with values
    self.searchString = [NSString stringWithFormat:@"Coffee"];
    self.filteredArray = [NSMutableArray arrayWithCapacity:20];
    self.mySearchBar.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.indexArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.namesArray objectAtIndex:section] count];                  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MemberCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];// forIndexPath:indexPath];// <--ios6 only

// Configure the cell text fields
    NSString *cellTitle = [[[self.namesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.textLabel.text = cellTitle;
    
// Changes subTitle if couponSort is ON
    if (filteredByCoupons) {
        NSString *cellSubtitle = [[[self.namesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"couponOffer"];
        cell.detailTextLabel.text = cellSubtitle;        
    } else {
        NSString *cellSubtitle = [[[self.namesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"city"];
        cell.detailTextLabel.text = cellSubtitle;
    }
    
    self.tempIndexPath = indexPath;

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [self.indexArray objectAtIndex:section];
}

-  (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return self.anArrayOfShortenedWords;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    return index;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
{
    // Sends User to the DetailViewController
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Performing segue to detail view for row: %@", cell);
    [self performSegueWithIdentifier:@"showDetails" sender:cell];
}

#pragma mark - Custom seques

/*
 Moves to other views based upon the segue identifier set in Storyboard
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

// Show Details screen
    if ([[segue identifier] isEqualToString:@"showDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSArray *object = [[self.namesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  //      NSLog(@"IndexPath = %@", indexPath);
        
// Sets the detailItem to the selected item
        [[segue destinationViewController] setDetailItem:object];
    }
  
// Show Map screen
    if ([[segue identifier] isEqualToString:@"showMap"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSArray *object = [[self.namesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        // Sets the detailItem to the selected item
        [[segue destinationViewController] setDetailItem:object];
    }
    
// Show Sort Selection screen
    if ([[segue identifier] isEqualToString:@"showSortSelection"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

#pragma mark - UITabBarControllerDelegate methods

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    NSLog(@"A tabBar item was pressed %@", viewController);
}

#pragma mark - Custom sort & search methods

- (NSArray *)makeSectionsIndex:(NSArray *)arrayOfDictionaries {
    NSLog(@"Takes the array of Dictionaries (PList), and creates an index of first letters for use in the tableview");
    
// Creates a mutable set to read each letter only once
    NSMutableSet *sectionsMutableSet = [NSMutableSet setWithCapacity:36];
    
//Reads each items Name & loads it's first letter into the sections set
    for (int i=0; i<=[arrayOfDictionaries count]-1; i++) {
        NSDictionary *aDictionary = [arrayOfDictionaries objectAtIndex:i];
    // Allows sort by Name or Category
        if (sortedByCategory) {
            NSString *aCategory = [aDictionary objectForKey:@"category"];
            if (aCategory.length > 0) {
                [sectionsMutableSet addObject:aCategory];
            }
        } else {
            NSString *aName = [aDictionary objectForKey:@"name"];
            NSString *aLetter = [aName substringToIndex:1U];        //uses the first letter of the string
            [sectionsMutableSet addObject:aLetter];
        }
    }
    
// Copies the mutable set into a set & then makes a mutable array of the set
    NSSet *sectionsSet = [NSSet setWithSet:sectionsMutableSet];
    NSMutableArray *sectionsMutableArray = [[sectionsSet allObjects] mutableCopy];
    
// Now let's sort the array and make it immutable
    NSArray *sortedArray = [[NSArray alloc] init];
    sortedArray = [sectionsMutableArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
// Trim the length of the indexes so that they appear as a short index word
// TODO: This array is NOT sorted
    NSArray *anUnsortedArray = [[NSArray alloc] init];
    anUnsortedArray = [self trimWordLength:sectionsMutableArray];
    self.anArrayOfShortenedWords = [anUnsortedArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    self.indexArray = [NSArray arrayWithArray:sortedArray];
    
//    NSLog(@"The self.indexArray = %@", self.indexArray);
    return self.indexArray;
}

- (NSMutableArray *)trimWordLength:(NSMutableArray *)array {
//    NSLog(@"Trims the words in this array %@ to display on the index", array);
    
    NSMutableArray *trimmedArray = [[NSMutableArray alloc] init];
    for (int i=0; i<=([array count]-1); i++) {
        NSString *trimmedWord = [[NSString alloc] init];
        trimmedWord = [array objectAtIndex:i];
        if (trimmedWord.length > 6) {
            trimmedWord = [trimmedWord substringToIndex:6U];
        }
        [trimmedArray addObject:trimmedWord];
    }
//    trimmedArray = [trimmedArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
//    NSLog(@"Trimmed words are; %@", trimmedArray);
    return trimmedArray;
}

- (NSArray *)makeIndexedArray:(NSArray *)wordsArray withIndex:(NSArray *)indexArray {
    NSLog(@"Takes an array of index letters (sections) and name array (rows) for display in the indexed tableview");
//    NSLog(@"wordsArray is %@", wordsArray);
    
// Create the mutable array
    NSMutableArray *indexedNameArray = [NSMutableArray arrayWithCapacity:600];

// Create an indexed arrray start with the first index letter
    for (int i=0; i <=([indexArray count] - 1); i++) {
        NSString *theIndexItem = [indexArray objectAtIndex:i];
        NSMutableArray *aListOfItems = [NSMutableArray arrayWithCapacity:50];
        
    // Now page thru all of the names
        for (int j=0; j<=([wordsArray count]-1); j++) {
// sorts by Name or Category
            NSString *firstLetterOfWord = [[NSString alloc] init];
            if (sortedByCategory) {
                firstLetterOfWord = [[wordsArray objectAtIndex:j] objectForKey:@"category"];
            } else {
                firstLetterOfWord = [[[wordsArray objectAtIndex:j] objectForKey:@"name"] substringToIndex:1U];
            }
            if ([theIndexItem isEqualToString:firstLetterOfWord]) {
                [aListOfItems addObject:[wordsArray objectAtIndex:j]];
            }
        }
//        NSArray *aListOfSortedItems = [aListOfItems sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        [indexedNameArray addObject:aListOfItems];
    }
    self.namesArray = [NSArray arrayWithArray:indexedNameArray];
//    NSLog(@"The self.namesArray = %@", self.namesArray);
    
    return self.namesArray;
}

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
// Update the filtered array based on the search text & scope
    
    [self.filteredArray removeAllObjects];      // First clear thefiltered array
    
    //Loop thru each defined field and looks for a match
    for (int i=0; i<+[self.membersArray count]-1; i++) {
        NSString *searchDescription = [[self.membersArray objectAtIndex:i] objectForKey:@"description"];
        NSString *searchName = [[self.membersArray objectAtIndex:i] objectForKey:@"name"];
        NSString *searchCategory = [[self.membersArray objectAtIndex:i] objectForKey:@"category"];
        NSString *searchMeta = [[self.membersArray objectAtIndex:i] objectForKey:@"meta"];
        
        // Checks for an empty search string
        if (self.searchString.length > 0) {
            
            // Searches in the various fields for the string match
            BOOL foundInDescription = [searchDescription rangeOfString:self.searchString options:NSCaseInsensitiveSearch].location == NSNotFound;
            BOOL foundInName = [searchName rangeOfString:self.searchString options:NSCaseInsensitiveSearch].location == NSNotFound;
            BOOL foundInCategory = [searchCategory rangeOfString:self.searchString options:NSCaseInsensitiveSearch].location == NSNotFound;
            BOOL foundInMeta = [searchMeta rangeOfString:self.searchString options:NSCaseInsensitiveSearch].location == NSNotFound;
            if (!foundInName || !foundInDescription|| !foundInCategory || !foundInMeta) {
                //           NSLog(@"The Business is #%d %@   %@", i, searchName, searchDescription);
                
                [self.filteredArray addObject:[self.membersArray objectAtIndex:i]];
            }
        }
    }
    NSLog(@"The resulting filteredArray has %d items", [self.filteredArray count]);
    
    // Makes sure there is something in the filteredArray
    if ([self.filteredArray count] > 0) {
        // Copy to namesArray and reload the data
        self.namesArray = [NSArray arrayWithArray:self.filteredArray];
        
        // Reworks the index & cells
        [self makeSectionsIndex:self.namesArray];
        [self makeIndexedArray:self.namesArray withIndex:self.indexArray];

        
        MEMBERLISTDATA.namesArray = [NSArray arrayWithArray:self.namesArray];
        
        [self.tableView reloadData];

    //Loads up the annotation pins for the BigMap
//        self.bigMapViewController.mapAnnotations = [[NSMutableArray alloc] initWithArray:self.namesArray];
    }
}

#pragma mark - UISearchBarDelegate methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    self.searchString = self.mySearchBar.text;
    NSLog(@"TRYing to search Now for ---> %@", self.searchString);
    
    [self filterContentForSearchText:self.searchString scope:@"All"];
    
    NSLog(@"Now we're SEARCHING baby!");
    [self.mySearchBar resignFirstResponder];            // dismisses the keyboard
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSString *searchString = self.mySearchBar.text;
    NSLog(@"TRYing to search Now for this %@", searchString);
}


#pragma mark - Delegate methods

- (void)cancelSortView:(SortSelectionViewController *)controller {
//    NSLog(@"This is the delegate (MasterVC) responding with %@", controller);
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)nameSort:(SortSelectionViewController *)controller {
    NSLog(@"Sorts the table by name");
    
// Initialization
    sortedByCategory = NO;
//    self.sortSelectionView.alpha = 0.0;
    self.namesArray = [NSArray arrayWithArray:self.membersArray];
    
// Reworks the index & cells
    [self makeSectionsIndex:self.namesArray];
    [self makeIndexedArray:self.namesArray withIndex:self.indexArray];
    
// Store new filtered data in the central data object
    MEMBERLISTDATA.namesArray = [NSArray arrayWithArray:self.namesArray];
    
// Regenerate the data
    [self.tableView reloadData];
    
// Removes the view controller
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)categorySort:(SortSelectionViewController *)controller {
    NSLog(@"Sorts the table by category");
    
// Initialization
    sortedByCategory = YES;
//    self.sortSelectionView.alpha = 0.0;
    self.namesArray = [NSArray arrayWithArray:self.membersArray];
    
// Reworks the index & cells
    [self makeSectionsIndex:self.namesArray];
    [self makeIndexedArray:self.namesArray withIndex:self.indexArray];
    
// Store new filtered data in the central data object
    MEMBERLISTDATA.namesArray = [NSArray arrayWithArray:self.namesArray];

// Regenerate the data
    [self.tableView reloadData];
    
// Removes the view controller
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)couponFilter:(SortSelectionViewController *)controller; {
    NSLog(@"Filters the table for coupons YES (y)");
    
    filteredByCoupons = YES;
    self.navigationItem.title = @"Coupon List";
    
// builds an array of HasCoupon = y
    NSMutableArray *aFilteredArray = [[NSMutableArray alloc] initWithCapacity:600];
    for (int i=0; i<=([self.membersArray count]-1); i++) {
        if ([[[self.membersArray objectAtIndex:i] objectForKey:@"hasCoupon"] isEqualToString:@"y"]) {
            [aFilteredArray addObject:[self.membersArray objectAtIndex:i]];
        }
    }
    // Copies the filtered array into our namesArray
    self.namesArray = [NSArray arrayWithArray:aFilteredArray];
    
    // Reworks the index & cells
    [self makeSectionsIndex:aFilteredArray];
    [self makeIndexedArray:aFilteredArray withIndex:self.indexArray];
    
    [self.tableView reloadData];
    
    // Saves namesArray to the data object
    MEMBERLISTDATA.namesArray = [NSArray arrayWithArray:self.namesArray];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Custom methods

- (void)loadPlistData {
// Loads the Plist into member array either from web or locally
    
// Loads file locally
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *fileURL = [mainBundle URLForResource:@"TLFMemberList" withExtension:@"plist"];
    
    self.membersArray = [NSArray arrayWithContentsOfURL:fileURL];
    NSLog(@"Array count %d", [self.membersArray count]);
    
// loads the web Plist on another thread
    [self loadPlistURL];
}

- (void)loadPlistURL {
// Loads the Plist from the web on another thread, and if both array counts are
// equal it copies the web version over the local version. And reloads the data

// Public dropbox link to data - https://dl.dropboxusercontent.com/u/13142051/TLFMemberList.plist
    NSString *fileURLString = @"https://dl.dropboxusercontent.com/u/13142051/TLFMemberList.plist";
    NSURL *fileURL = [[NSURL alloc]initWithString:fileURLString];
    
// Assign the URL command to another string
    dispatch_queue_t downloadQueue = dispatch_queue_create("Plist downloader", NULL);
    dispatch_async(downloadQueue, ^{
        
        NSArray *membersURLArray = [NSArray arrayWithContentsOfURL:fileURL];
        
    // dispatches to the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
        // compares counts of each array & allows copy if the are equal
            if ([self.membersArray count] == [membersURLArray count]) {
                NSLog(@"let's overwrite NOW!!!");
                
                self.membersArray = [NSArray arrayWithArray:membersURLArray];
                NSLog(@"Array count %d", [self.membersArray count]);
                
                [self.tableView reloadData];
            } else {
                NSLog(@"Download FAILED!!!!");
                NSLog(@"Array count %d", [membersURLArray count]);
            }
        });
    });
}


- (IBAction)sortListButton:(UIBarButtonItem *)sender {
    NSLog(@"Displays the sort selection view - 'slide up' animation");

    self.sortSelectionView.hidden = NO;
    [UIView animateWithDuration:1.5 animations:^{
                         self.sortSelectionView.alpha = 0.85;
    }];
  
}

- (IBAction)showAllButton:(UIBarButtonItem *)sender {
    NSLog(@"Displays ALL the items by existing sort criteria");

    filteredByCoupons = NO;
    self.navigationItem.title = @"List";
    
// Reworks the index & cells
    [self makeSectionsIndex:self.membersArray];
    [self makeIndexedArray:self.membersArray withIndex:self.indexArray];
    
    [self.tableView reloadData];
}

@end
