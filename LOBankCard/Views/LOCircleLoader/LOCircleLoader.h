//
//  LOCircleLoader.h
//  Demo
//
//  Created by Lion on 2021/5/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LOCircleLoader : UIView
@property (nonatomic, strong) UIColor *progressTintColor ;
@property (nonatomic, strong) UIColor *trackTintColor ;
@property (nonatomic, assign) float lineWidth;
@property (nonatomic, assign) float progressValue;
@property (nonatomic, copy) void(^rotateAnimationFinished)(void);

- (void)start;
- (void)reset;
- (void)startFadeAnimation;
@end

NS_ASSUME_NONNULL_END
