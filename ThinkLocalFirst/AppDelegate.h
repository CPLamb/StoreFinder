//
//  AppDelegate.h
//  ThinkLocalFirst
//
//  Created by Chris Lamb on 4/20/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberListData.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {

//    MemberListData *memberData;
}
@property (strong, nonatomic) MemberListData *memberData;
@property (strong, nonatomic) UIWindow *window;

@end
