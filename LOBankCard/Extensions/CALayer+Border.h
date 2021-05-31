//
//  CALayer+Border.h
//  Demo
//
//  Created by Lion on 2021/5/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer(LOBorder)
- (void)addBorder:(CGColorRef)color width:(CGFloat)width;
@end

NS_ASSUME_NONNULL_END
