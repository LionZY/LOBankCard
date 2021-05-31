//
//  CALayer+Shadow.h
//  Demo
//  本layer包含了一个处理圆角的layer，保证能同时展示圆角和阴影
//
//  Created by Lion on 2021/5/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView(ShadowAndCornerRadius)
- (void)setLOBackgroundColor:(UIColor *)backgroundColor;
- (void)setLOCornerRadius:(CGFloat)loCornerRadius;
- (void)setLOMasksToBounds:(BOOL)loMasksToBounds;
@end

NS_ASSUME_NONNULL_END

