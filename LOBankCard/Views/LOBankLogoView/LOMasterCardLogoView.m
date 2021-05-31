//
//  LOBankLogoView.m
//  Demo
//
//  Created by Lion on 2021/5/28.
//

#import "LOMasterCardLogoView.h"
#import "LOCircleLoader.h"
#import "MacroTheme.h"

#import <Masonry/Masonry.h>

@interface LOMasterCardLogoView ()
@property (nonatomic, strong) LOCircleLoader *leftCircle;
@property (nonatomic, strong) LOCircleLoader *rightCircle;
@end

@implementation LOMasterCardLogoView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - SetupUI
- (void)setupUI{
    [self addSubview:self.rightCircle];
    [self.rightCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.equalTo(self.mas_height).multipliedBy(1.0);
    }];
    
    [self addSubview:self.leftCircle];
    [self.leftCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.equalTo(self.mas_height).multipliedBy(1.0);
    }];
}

#pragma mark - Public
- (void)startAnimation{
    __weak LOMasterCardLogoView *weakSelf = self;
    [self.rightCircle setRotateAnimationFinished:^{
        [weakSelf.leftCircle startFadeAnimation];
        [weakSelf.rightCircle startFadeAnimation];
    }];
    
    [self.leftCircle start];
    [self.rightCircle performSelector:@selector(start) withObject:nil afterDelay:0.25];
}

- (void)reset{
    [self.leftCircle reset];
    [self.rightCircle reset];
}

#pragma mark - Getter
- (LOCircleLoader *)leftCircle{
    if (!_leftCircle) {
        _leftCircle = [LOCircleLoader new];
        _leftCircle.progressTintColor = RGB(255.0, 0.0, 0.0);
        _leftCircle.trackTintColor = RGB(255.0, 0.0, 0.0);
        _leftCircle.lineWidth = 1.0;
    }
    return _leftCircle;
}

- (LOCircleLoader *)rightCircle{
    if (!_rightCircle) {
        _rightCircle = [LOCircleLoader new];
        _rightCircle.progressTintColor = RGB(0.0, 255.0, 255.0);
        _rightCircle.trackTintColor = RGB(0.0, 255.0, 255.0);
        _rightCircle.lineWidth = 1.0;
    }
    return _rightCircle;
}
@end
