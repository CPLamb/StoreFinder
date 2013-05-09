//
//  MasterViewController.m
//  ThinkLocalFirst
//
//  Created by Chris Lamb on 4/20/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;

}
@end

@implementation MasterViewController
@synthesize memberViewController = _memberViewController;
@synthesize infoViewController = _infoViewController;
@synthesize sortSelectionView = _sortSelectionView;

@synthesize detailItem = _detailItem;

@synthesize membersArray = _membersArray;
@synthesize namesArray = _namesArray;
@synthesize indexArray = _indexArray;
@synthesize anArrayOfShortenedWords = _anArrayOfShortenedWords;
@synthesize tempIndexPath = _tempIndexPath;

#pragma mark - View Lifecycle methods

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
// Loads the Plist into member array either from web or locally
    
// Public dropbox link to data - https://dl.dropboxusercontent.com/u/13142051/TLFMemberList.plist
//    NSString *fileURLString = @"https://dl.dropboxusercontent.com/u/13142051/TLFMemberList.plist";
//    NSURL *fileURL = [[NSURL alloc]initWithString:fileURLString];

// Loads file locally
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *fileURL = [mainBundle URLForResource:@"TLFMemberList" withExtension:@"plist"];
    
    self.membersArray = [NSArray arrayWithContentsOfURL:fileURL];
    NSLog(@"Array count %d", [self.membersArray count]);
    
// Loads the sortBy view & hides it
    [self.view addSubview:self.sortSelectionView];
    self.sortSelectionView.alpha = 0.0;
    sortedByCategory = NO;
    
// Makes up the index array & the sorted array for the cells
    [self makeSectionsIndex:self.membersArray];
    [self makeIndexedArray:self.membersArray withIndex:self.indexArray];
 
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

// Configure the cell text fields
    NSString *cellTitle = [[[self.namesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.textLabel.text = cellTitle;
    NSString *cellSubtitle = [[[self.namesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"city"];
    cell.detailTextLabel.text = cellSubtitle;
    
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
/*    NSArray *object = [[self.namesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    self.memberViewController = [[DetailViewController alloc] init];
    self.memberViewController.detailItem = object;
    
    self.tempIndexPath = indexPath;

//    [self presentViewController:self.memberViewController animated:YES completion:NULL];
*/    
    NSLog(@"Somebody just tapped me?? with detailItem");
}

#pragma mark - Custom seques

/*
 Moves to other views based upon the segue identifier set in Storyboard
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

// Show Details screen
    if ([[segue identifier] isEqualToString:@"showDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSArray *object = [[self.namesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSLog(@"IndexPath = %@", indexPath);
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
            [sectionsMutableSet addObject:aCategory];
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
        [indexedNameArray addObject:aListOfItems];
    }
    self.namesArray = [NSArray arrayWithArray:indexedNameArray];
//    NSLog(@"The self.namesArray = %@", self.namesArray);
    
    return self.namesArray;
}
#pragma mark - Delegate methods

- (void)cancelSortView:(SortSelectionViewController *)controller {
    NSLog(@"This is the delegate (MasterVC) responding with %@", controller);
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)nameSort:(SortSelectionViewController *)controller {
    NSLog(@"Sorts the table by name");
    
    // Initialization
    sortedByCategory = NO;
    self.sortSelectionView.alpha = 0.0;
    
    self.namesArray = [NSArray arrayWithArray:self.membersArray];
    // Reworks the index & cells
    [self makeSectionsIndex:self.namesArray];
    [self makeIndexedArray:self.namesArray withIndex:self.indexArray];
    
    // Regenerate the data
    [self.tableView reloadData];

    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)categorySort:(SortSelectionViewController *)controller {
    NSLog(@"Sorts the table by category");
    
    // Initialization
    sortedByCategory = YES;
    self.sortSelectionView.alpha = 0.0;
    
    self.namesArray = [NSArray arrayWithArray:self.membersArray];
    // Reworks the index & cells
    [self makeSectionsIndex:self.namesArray];
    [self makeIndexedArray:self.namesArray withIndex:self.indexArray];
    
    // Regenerate the data
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)couponFilter:(SortSelectionViewController *)controller; {
    NSLog(@"Filters the table for coupons YES (y)");
    
    self.sortSelectionView.alpha = 0.0;
    
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
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Custom methods
 
- (IBAction)sortListButton:(UIBarButtonItem *)sender {
    NSLog(@"Displays the sort selection view - 'slide up' animation");

    self.sortSelectionView.hidden = NO;
    [UIView animateWithDuration:1.5 animations:^{
                         self.sortSelectionView.alpha = 0.85;
    }];
  
}

- (IBAction)showAllButton:(UIBarButtonItem *)sender {
    NSLog(@"Displays ALL the items by existing sort criteria");

    self.sortSelectionView.alpha = 0.0;
    
// Reworks the index & cells
    [self makeSectionsIndex:self.membersArray];
    [self makeIndexedArray:self.membersArray withIndex:self.indexArray];
    
    [self.tableView reloadData];
}

//TODO: delete ALL unused methods & code
- (IBAction)sortByCategory:(UIButton *)sender {
    NSLog(@"Sorts the table by category");

// Initialization
    sortedByCategory = YES;
    self.sortSelectionView.alpha = 0.0;
    
    self.namesArray = [NSArray arrayWithArray:self.membersArray];
// Reworks the index & cells
    [self makeSectionsIndex:self.namesArray];
    [self makeIndexedArray:self.namesArray withIndex:self.indexArray];
    
// Regenerate the data
    [self.tableView reloadData];
}

- (IBAction)sortByName:(UIButton *)sender {
    NSLog(@"Sorts the table by name");

// Initialization
    sortedByCategory = NO;
    self.sortSelectionView.alpha = 0.0;
    
    self.namesArray = [NSArray arrayWithArray:self.membersArray];
// Reworks the index & cells
    [self makeSectionsIndex:self.namesArray];
    [self makeIndexedArray:self.namesArray withIndex:self.indexArray];

// Regenerate the data    
    [self.tableView reloadData];
}

- (IBAction)filterForCoupons:(UIButton *)sender {
    NSLog(@"Filters the table for coupons YES (y)"); 

    self.sortSelectionView.alpha = 0.0;
    
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
}

- (IBAction)cancelButton:(UIButton *)sender {
    NSLog(@"Hides the sort by window - 'slide DOWN' animation");
    
    self.sortSelectionView.alpha = 0.0;
}


@end
