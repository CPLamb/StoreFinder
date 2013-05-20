//
//  MemberListData.h
//  ThinkLocal
//
//  Created by Chris Lamb on 5/18/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "SortSelectionViewController.h"

// Static call for the singleton of the memberData
#define MEMBERLISTDATA (((AppDelegate*)[[UIApplication sharedApplication] delegate]).memberData)

@interface MemberListData : NSObject  <SortSelectionViewControllerDelegate>

@property (strong, nonatomic) NSArray *namesArray;  // array of indexed array of dictionaries
@property (strong, nonatomic) NSArray *membersArray;    // complete list derived from the PList

@end
