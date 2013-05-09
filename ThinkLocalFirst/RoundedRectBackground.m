//
//  RoundedRectBackground.m
//  ThinkLocalFirst
//
//  Created by Chris Lamb on 4/26/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import "RoundedRectBackground.h"

#define RECT_RADIUS 4.0
#define RECT_PADDING 2.0
#define RECT_SHADOW -2.0
#define LINE_WIDTH 3.0
#define BLUR 1.0

@implementation RoundedRectBackground


#pragma mark - Custom drawing methods

- (void)drawRect:(CGRect)rect
{
// Sets a shadow & other appearance/context related properties
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGSize offset = CGSizeMake(RECT_SHADOW, RECT_SHADOW);   // Position of light source above the object
    CGContextSetShadow(context, offset, BLUR);
    
// Drawing code for the background
    UIBezierPath *roundedRectangle = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:RECT_RADIUS];
    
    // Set color of backgrounds
    [[UIColor whiteColor] setFill];
    
    UIRectFill(self.bounds);
    [roundedRectangle setLineWidth:LINE_WIDTH];
    
    [[UIColor blackColor] setStroke];    
    [roundedRectangle addClip];        // makes corners invisible
    
    [roundedRectangle stroke];          // draws the object
}

#pragma mark - Custom setters & designated initializer

- (void)initWithItem:(id)detailItem cornerRadius:(CGFloat)radius padding:(CGFloat)padding {
    
    
}

- (void)setHeight:(CGFloat)height {
    
    _height = height;
    [self setNeedsDisplay];
}

- (void)setWidth:(CGFloat)width {
    
    _width = width;
    [self setNeedsDisplay];
}

- (void)setDetailItemOrder:(NSUInteger)detailItemOrder {
    
    _detailItemOrder = detailItemOrder;
    [self setNeedsDisplay];
}

- (void)setDetailItemText:(NSString *)detailItemText {
    
    _detailItemText = detailItemText;
    [self setNeedsDisplay];
}

#pragma mark - View Lifecycle methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setNeedsDisplay];
    }
    return self;
}


@end
