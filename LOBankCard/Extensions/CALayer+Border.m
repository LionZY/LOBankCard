//
//  CALayer+Border.m
//  Demo
//
//  Created by Lion on 2021/5/27.
//

#import "CALayer+Border.h"

@implementation CALayer(LOBorder)
- (void)addBorder:(CGColorRef)color width:(CGFloat)width
{
    self.borderColor = color;
    self.borderWidth = width;
}
@end
