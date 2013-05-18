//
//  MemberListData.h
//  ThinkLocal
//
//  Created by Chris Lamb on 5/18/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

#define MEMBERLISTDATA (((AppDelegate*)[[UIApplication sharedApplication] delegate]).memberData)

@interface MemberListData : NSObject

//@property (strong, nonatomic) NSArray *namesArray;
@property (strong, nonatomic) NSArray *membersArray;

@end
