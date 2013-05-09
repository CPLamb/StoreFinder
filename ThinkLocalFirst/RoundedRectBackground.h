//
//  RoundedRectBackground.h
//  ThinkLocalFirst
//
//  Created by Chris Lamb on 4/26/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundedRectBackground : UIView

@property (nonatomic) NSUInteger detailItemOrder;
@property (strong, nonatomic) NSString *detailItemText;

@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat width;

@end
