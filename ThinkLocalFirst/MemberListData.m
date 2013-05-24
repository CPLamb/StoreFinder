//
//  MemberListData.m
//  ThinkLocal
//
//  Created by Chris Lamb on 5/18/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import "MemberListData.h"

@implementation MemberListData
@synthesize namesArray = _namesArray;
@synthesize membersArray = _membersArray;

- (id)init {                        // overridden initializer
    if ((self = [super init])) {
        [self loadPlistData];
    }
    return self;
    
}

#pragma mark - Custom methods

- (void)loadPlistData {
    // Loads the Plist into member array either from web or locally
    
// Loads file locally
//    NSBundle *mainBundle = [NSBundle mainBundle];
//    NSURL *fileURL = [mainBundle URLForResource:@"TLFMemberList" withExtension:@"plist"];
    
// Loads the file from the web
    NSString *fileURLString = @"https://dl.dropboxusercontent.com/u/13142051/TLFMemberList.plist";
    NSURL *fileURL = [[NSURL alloc]initWithString:fileURLString];

    self.membersArray = [NSArray arrayWithContentsOfURL:fileURL];
    NSLog(@"MEMBERLISTDATA Array count %d", [self.membersArray count]);

    // Copy members array into the names array which can later be sorted for other views
    self.namesArray = [NSArray arrayWithArray:self.membersArray];
    
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
                
//                [self.tableView reloadData];
            } else {
                NSLog(@"Download FAILED!!!!");
                NSLog(@"Array count %d", [membersURLArray count]);
            }
        });
    });
}

+ (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

@end
