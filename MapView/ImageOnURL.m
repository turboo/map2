//
//  ImageOnURL.m
//  Cells
//
//  Created by student on 2011/10/28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ImageOnURL.h"


@implementation ImageOnURL
-(UIImage *)sendURLReturnImage:(NSString *)imageURL{
    return [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
}
@end
