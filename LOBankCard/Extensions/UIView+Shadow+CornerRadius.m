//
//  CALayer+Shadow.m
//  Demo
//
//  Created by Lion on 2021/5/26.
//

#import "UIView+Shadow+CornerRadius.h"

#import <objc/runtime.h>
#import <Masonry/Masonry.h>

static const void *loCornerRadiusViewKey = &loCornerRadiusViewKey;

@implementation UIView(ShadowAndCornerRadius)

#pragma mark - Getter
- (UIView *)cornerRadiusView{
    UIView *bottomView = objc_getAssociatedObject(self, loCornerRadiusViewKey);
    if(!bottomView){
        bottomView = [UIView new];
        objc_setAssociatedObject(self, loCornerRadiusViewKey, bottomView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self insertSubview:bottomView atIndex:0];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return bottomView;
}

#pragma mark - Setter
- (void)setLOBackgroundColor:(UIColor *)backgroundColor{
    self.cornerRadiusView.backgroundColor = backgroundColor;
}

- (void)setLOCornerRadius:(CGFloat)loCornerRadius{
    self.cornerRadiusView.layer.cornerRadius = loCornerRadius;
}

- (void)setLOMasksToBounds:(BOOL)loMasksToBounds{
    self.cornerRadiusView.layer.masksToBounds = loMasksToBounds;
}

@end

