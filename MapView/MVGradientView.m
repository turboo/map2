//
//  MVGradientView.m
//  MapView
//
//  Created by App on 2011/10/28.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MVGradientView.h"
#import <QuartzCore/QuartzCore.h>


@interface MVGradientView ()

@property (nonatomic, readonly, retain) CAGradientLayer *layer;

@property (nonatomic, readwrite, retain) UIColor *fromColor;
@property (nonatomic, readwrite, retain) UIColor *toColor;

- (void) updateLayer;

@end

@implementation MVGradientView

@dynamic layer;
@synthesize fromColor, toColor;

+ (id) viewFromColor:(UIColor *)aColor toColor:(UIColor *)anotherColor {

    MVGradientView *returnedView = [[[self alloc] initWithFrame:CGRectZero] autorelease];
    if (!returnedView)
        return nil;
    
    returnedView.fromColor = aColor;
    returnedView.toColor = anotherColor;
    
    return returnedView;

}

+ (Class) layerClass {

    return [CAGradientLayer class];

}

- (id) initWithFrame:(CGRect)newFrame {

    self = [super initWithFrame:newFrame];
    if (!self)
        return nil;
    
    return self;

}

- (void) dealloc {

    [fromColor release];
    [toColor release];
    [super dealloc];

}

- (void) setFromColor:(UIColor *)newFromColor {

    if (fromColor == newFromColor)
        return;
    
    [fromColor release];
    fromColor = [newFromColor retain];
    
    [self updateLayer];
    
}

- (void) setToColor:(UIColor *)newToColor {

    if (toColor == newToColor)
        return;
    
    [toColor release];
    toColor = [newToColor retain];
    
    [self updateLayer];

}

- (void) updateLayer {

    self.layer.colors = [NSArray arrayWithObjects:self.fromColor.CGColor, self.toColor.CGColor, nil];

}

@end
