//
//  MVGradientView.h
//  MapView
//
//  Created by App on 2011/10/28.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MVGradientView : UIView

+ (id) viewFromColor:(UIColor *)aColor toColor:(UIColor *)anotherColor;

@property (nonatomic, readonly, retain) UIColor *fromColor;
@property (nonatomic, readonly, retain) UIColor *toColor;

@end
