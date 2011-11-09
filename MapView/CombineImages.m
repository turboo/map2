//
//  CombineImages.m
//  Map
//
//  Created by App on 2011/10/19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CombineImages.h"

@implementation UIImage (MapAdditions)

- (UIImage *) compositeImageWithOverlayText:(NSString *)incomingText {

	UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
	UIFont *usedFont = [UIFont systemFontOfSize:12];
	
	//CGRect imageRect = (CGRect){ CGPointZero, self.size };

	CGRect imageRect = (CGRect){ CGPointZero,{self.size.width-10,self.size.height-10} };
	

	CGSize textSize = [incomingText sizeWithFont:usedFont];
	CGRect textRect = (CGRect){
		(CGPoint){
			roundf(0.5f * (CGRectGetWidth(imageRect) - textSize.width)),
			roundf(0.4f * (CGRectGetHeight(imageRect) - textSize.height))
		},
		textSize
	};
	
	[self drawInRect:imageRect];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
	
	[incomingText drawInRect:textRect withFont:usedFont];
	
	UIImage *returnedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
    return returnedImage;
	
}


- (UIImage *) compositeImageWithOverlayImage:(UIImage *)image2 { 

	UIGraphicsBeginImageContext(self.size);
	[self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
	[image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
	UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return resultingImage;
	
}


- (UIImage *) scaledImageWithSize:(CGSize)reSize {

	UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
	[self drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
	UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return reSizeImage;
	
}

-(UIImage *)sendURLReturnImage:(NSString *)imageURL{
  //  NSURL *url = [NSURL URLWithString:imageURL];
  //  NSData *data = [NSData dataWithContentsOfURL:url];
  //  UIImage *img = [[UIImage alloc] initWithData:data];
  //  return img;
  
  return [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
}

-(UIImage *)sendURLReturnImage2:(NSString *)imageURL itemImage:(UIImage *)itemImage

{
  //  NSURL *url = [NSURL URLWithString:imageURL];
  //  NSData *data = [NSData dataWithContentsOfURL:url];
  //  UIImage *img = [[UIImage alloc] initWithData:data];
  //  return img;
/*
  float default_width = 30.0; 
  float default_height = 30.0; 
  NSRect initialFrame = NSMakeRect(0.0, 0.0, default_width, default_height); 
  itemImageView = [[NSButton alloc] init]; 
  [[itemImageView setFrame:initialFrame]; 
  
  [itemImageView setToolTip:@"Click the image for full screen, click again to return to normal size."]; 
  [itemImageView setTarget:self]; 
  [itemImageView setAction:@selector(imageClicked:)]; 
  [itemImageView setBordered:NO]; 
  [itemImageView setFrame:self.frame]; 
  [itemImageView setAutoresizesSubviews:TRUE]; 
  [itemImageView.cell setImageScaling:NSImageScaleAxesIndependently];
  
  float new_width = 50.0; 
  float new_height = 50.0; 
  NSRect newFrame = NSMakeRect(0.0, 0.0, new_width, new_height); 
  [itemImageView setFrame:newFrame]; 
  [itemImageView setImage:itemImageViewOriginal.image]; 
  [self addSubview:itemImageView];
  refreshInProgressActivityIndicator = [[NSProgressIndicator alloc] init]; 
  NSRect newProgressFrame = NSMakeRect(itemImageView.bounds.size.width / 2.0, itemImageView.bounds.size.height / 2.0, 0.0, 0.0); 
  [refreshInProgressActivityIndicator setFrame:newProgressFrame]; 
  [refreshInProgressActivityIndicator setStyle:NSProgressIndicatorSpinningStyle]; 
  [refreshInProgressActivityIndicator setIndeterminate:YES]; 
  [refreshInProgressActivityIndicator setDisplayedWhenStopped:FALSE]; 
  [refreshInProgressActivityIndicator setHidden:NO]; [refreshInProgressActivityIndicator setControlSize:NSRegularControlSize]; 
  [refreshInProgressActivityIndicator sizeToFit]; 
  [refreshInProgressActivityIndicator setAutoresizingMask:(NSViewMaxXMargin | NSViewMinXMargin | NSViewMaxYMargin | NSViewMinYMargin)]; 
  // [refreshInProgressActivityIndicator setUsesThreadedAnimation:YES]; 
  [refreshInProgressActivityIndicator startAnimation:self]; 
  [refreshInProgressActivityIndicator stopAnimation:self];
   itemImageView addSubview:refreshInProgressActivityIndicator];
 */
}

@end
