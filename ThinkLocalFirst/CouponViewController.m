//
//  CouponViewController.m
//  ThinkLocal
//
//  Created by Chris Lamb on 5/18/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponOfferViewController.h"

@interface CouponViewController ()

@end

@implementation CouponViewController

#pragma mark -- View lifecycle methods

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

// Sets up the tableView
    NSLog(@"CouponVC namesArray is %d", [self.namesArray count]);
    
    filteredByCoupons = YES;
    sortedByCategory = YES;
    
    [self couponFilter];
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
    static NSString *cellIdentifier = @"couponCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];// forIndexPath:indexPath];// <-- ios6 only
    
// Configure the cell text fields
    NSString *cellTitle = [[[self.namesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.textLabel.text = cellTitle;
    
// Changes subTitle if couponSort is ON
    NSString *cellSubtitle = [[[self.namesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"couponOffer"];
    cell.detailTextLabel.text = cellSubtitle;
    
    self.tempIndexPath = indexPath;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *couponURL = [[[self.namesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"couponURL"];
    
    NSLog(@"The selected row is %@", couponURL);
    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
{
    // Sends User to the DetailViewController
    NSLog(@"Performing segue to detail view for row at indexPath: %@", indexPath);
    [self performSegueWithIdentifier:@"showDetails" sender:indexPath];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender  {
    
    // Show Details screen
    if ([[segue identifier] isEqualToString:@"showDetails"]) {
        NSIndexPath *indexPath = sender;
        NSDictionary *object = [[self.namesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        DetailViewController* dvc = [segue destinationViewController];
        dvc.detailItem = object;
    }
    
    // Show Coupon Offer screen (Web view)
    else if ([[segue identifier] isEqualToString:@"showCoupon"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *object = [[self.namesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//              NSLog(@"The object passed is = %@", object);
        
        CouponOfferViewController* covc = [segue destinationViewController];
        covc.couponURLString = [object objectForKey:@"couponURL"];
        
    }
}

#pragma mark -- Custom methods

- (void)couponFilter; {             // :(SortSelectionViewController *)controller
//    NSLog(@"Filters the table for coupons YES (y)");
    
    filteredByCoupons = YES;
    
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
        
        // DO NOT update the parent array because we do not want the map view to access our sorted coupon list.
//        MEMBERLISTDATA.namesArray = [NSArray arrayWithArray:self.namesArray];
        
        [self.tableView reloadData];
        
        //Loads up the annotation pins for the BigMap
        //        self.bigMapViewController.mapAnnotations = [[NSMutableArray alloc] initWithArray:self.namesArray];
    }
}


@end
