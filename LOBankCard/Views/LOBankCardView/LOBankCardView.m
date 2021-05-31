//
//  LOBankCardView.m
//  Demo
//
//  Created by Lion on 2021/5/26.
//

#import "LOBankCardView.h"
#import "LOFormatTextView.h"
#import "LOMasterCardLogoView.h"
#import "LOTextField.h"
#import "UIView+Shadow+CornerRadius.h"
#import "MacroTheme.h"
#import "LOBankCard.h"
#import "LOBankCardWorkFlow.h"
#import "LOBankCardTypeInWork.h"
#import "UITextField+Placeholer.h"
#import "NSString+Format.h"
#import "LOFocusProtocol.h"

#import <Masonry/Masonry.h>


@interface LOBankCardView ()

//正反面容器
@property (nonatomic, strong) UIView *frontView;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) LOMasterCardLogoView *logoView;
@property (nonatomic, strong) LOFormatTextView *cardNOView;
@property (nonatomic, strong) UILabel *cardHolderNameTitleView;
@property (nonatomic, strong) LOTextField *cardHolderNameView;
@property (nonatomic, strong) UILabel *cardValidThruTitleView;
@property (nonatomic, strong) LOFormatTextView *cardValidThruView;
@property (nonatomic, strong) LOTextField *cardCVVView;
@end

@implementation LOBankCardView

#pragma mark - Life's Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - Setup UI
- (void)setupUI{
        
    //设置圆角和阴影
    [self setupCornerRadiusAndShadow];
    
    //添加背面视图
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    //添加正面视图
    [self addSubview:self.frontView];
    [self.frontView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    //TODO: 根据传入的参数改变银行卡logo, 可以做一个配置模型
    [self.frontView addSubview:self.logoView];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-16);
        make.top.mas_equalTo(16.0);
        make.width.mas_equalTo(56.0);
        make.height.mas_equalTo(32.0);
    }];
    
    //TODO:添加卡号输入框
    [self.frontView addSubview:self.cardNOView];
    [self.cardNOView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.frontView);
        make.leading.mas_equalTo(10.0);
        make.trailing.mas_equalTo(-10.0);
        make.height.mas_equalTo(44.0);
    }];
    
    //TODO: 卡片持有人名字
    [self.frontView addSubview:self.cardHolderNameView];
    [self.cardHolderNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-10);
        make.leading.mas_equalTo(self.cardNOView);
        make.height.mas_equalTo(28.0);
        make.width.mas_greaterThanOrEqualTo(0.0);
    }];
    
    //TODO: 卡片持有人标签
    [self.frontView addSubview:self.cardHolderNameTitleView];
    [self.cardHolderNameTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.cardHolderNameView.mas_top);
        make.leading.mas_equalTo(self.cardNOView).offset(6.0);
        make.height.mas_greaterThanOrEqualTo(0.0);
        make.width.mas_greaterThanOrEqualTo(0.0);
    }];
    
    //TODO: 过期时间
    [self.frontView addSubview:self.cardValidThruView];
    [self.cardValidThruView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.cardHolderNameView);
        make.trailing.mas_equalTo(self.cardNOView);
        make.height.mas_equalTo(self.cardHolderNameView);
        make.width.mas_equalTo(64.0);
    }];
    
    //TODO: 过期时间标签
    [self.frontView addSubview:self.cardValidThruTitleView];
    [self.cardValidThruTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.cardHolderNameTitleView);
        make.trailing.mas_equalTo(self.cardNOView).offset(-6.0);
        make.height.mas_greaterThanOrEqualTo(0.0);
        make.width.mas_greaterThanOrEqualTo(0.0);
    }];
    
    //添加CVV
    [self.backView addSubview:self.cardCVVView];
    [self.cardCVVView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView);
        make.height.mas_equalTo(44);
        make.width.mas_greaterThanOrEqualTo(0.0);
        make.trailing.mas_equalTo(-10.0);
    }];
    
    //添加磁条
    UIView *grayView = [UIView new];
    grayView.backgroundColor = UIColor.lightGrayColor;
    [self.backView addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10);
        make.trailing.equalTo(self.cardCVVView.mas_leading).offset(-8);
        make.height.equalTo(self.cardCVVView);
        make.centerY.equalTo(self.cardCVVView);
    }];
}

- (void)setupCornerRadiusAndShadow{
    
    [self setLOBackgroundColor:RGB(29.0, 13.0, 48.0)];
    [self setLOCornerRadius:15.0];
    [self setLOMasksToBounds:YES];
    
    [self.frontView.layer setCornerRadius:15.0];
    [self.frontView.layer setMasksToBounds:YES];
    [self.backView.layer setCornerRadius:15.0];
    [self.backView.layer setMasksToBounds:YES];
    
    self.layer.shadowColor = CGRGB(0.0, 0.0, 0.0);
    self.layer.shadowRadius = 10.0;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0.5;
    
}

#pragma mark - Public
- (void)startLogoAnimation{
    [self.logoView reset];
    [self.logoView startAnimation];
}

- (void)jumpToNextStep{
    //进入下一步
    NSInteger lastStep = self.workflow.step;
    [self.workflow jumpToNextStep];
    NSInteger steps = self.workflow.bankCardTypeInWorkflow.count;
    NSInteger currentStep = self.workflow.step;
    if (currentStep == steps - 1 && lastStep < currentStep) {
        [self animateForExchangeFrontAndBack:YES];
    }
}

- (void)jumpToPreStep{
    //进入上一步
    NSInteger lastStep = self.workflow.step;
    [self.workflow jumpToPreStep];
    NSInteger steps = self.workflow.bankCardTypeInWorkflow.count;
    NSInteger currentStep = self.workflow.step;
    if (lastStep == steps - 1 && lastStep > currentStep) {
        [self animateForExchangeFrontAndBack:NO];
    }
}

- (void)syncText:(NSString *)text{
    NSString *newValue = text;
    LOBankCardTypeInWork *currentWork = self.workflow.currentWork;
    LOStringFormatter *formatter = currentWork.formatter;
    NSInteger step = self.workflow.step;
    if (step == 0) {
        newValue = [text unformat:formatter];
    }
    NSArray *stepViews = @[self.cardNOView, self.cardHolderNameView, self.cardValidThruView, self.cardCVVView];
    NSArray *stepKeys = @[@"cardNO", @"cardHolder", @"validThru", @"cvv"];
    if (step == 0) {
        [stepViews[step] setText:newValue];
    } else if(step == 1){
        [stepViews[step] setText:newValue];
        [stepViews[step] setPlaceholder:newValue.length > 0? @"" : currentWork.placeholder];
    } else {
        [stepViews[step] setText:newValue];
    }
    [self.bankCard setValue:newValue forKey:stepKeys[step]];
}

- (void)resinLastResponder{
    NSArray *stepViews = @[self.cardNOView, self.cardHolderNameView, self.cardValidThruView, self.cardCVVView];
    NSObject<LOFocusProtocol> *obj = stepViews[self.workflow.step];
    if ([obj respondsToSelector:@selector(setFocus:)]) {
        [obj setFocus:NO];
    }
}

- (void)syncFirstResponder{
    NSArray *stepViews = @[self.cardNOView, self.cardHolderNameView, self.cardValidThruView, self.cardCVVView];
    NSObject<LOFocusProtocol> *obj = stepViews[self.workflow.step];
    if ([obj respondsToSelector:@selector(setFocus:)]) {
        [obj setFocus:YES];
    }
}

- (NSString *)currentStepText{
    LOStringFormatter *formatter = self.workflow.currentWork.formatter;
    NSInteger step = self.workflow.step;
    if (step == 0) {
        NSString *cardNO =  [self.bankCard.cardNO format:formatter];
        return cardNO;
    }
    
    if (step == 1) {
        return self.bankCard.cardHolder;
    }
    
    if (step == 2) {
        return [self.bankCard.validThru format:formatter];
    }
    
    if (step == 3) {
        return self.bankCard.cvv;
    }
    
    return @"";
}

#pragma mark - Private
- (void)animateForExchangeFrontAndBack:(BOOL)showBack{
    
    UIView *fromView = showBack? self.frontView : self.backView;
    UIView *toView = showBack? self.backView : self.frontView;
    
    CGFloat m34 = 600;
    CGPoint point = CGPointMake(0.5, 0.5);
    self.layer.anchorPoint = point;
    __block CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / m34;
    self.layer.transform = transform;
    [self bringSubviewToFront:fromView];
    [UIView animateWithDuration:0.15 animations:^{
        transform = CATransform3DRotate(transform, showBack? M_PI_2 : -M_PI_2, 0, 1, 0);
        self.layer.transform = transform;
    } completion:^(BOOL finished) {
        [self bringSubviewToFront:toView];
        transform = CATransform3DRotate(transform, showBack? -M_PI : M_PI, 0, 1, 0);
        self.layer.transform = transform;
        [UIView animateWithDuration:0.15 animations:^{
            transform = CATransform3DRotate(transform, showBack? M_PI_2 : -M_PI_2, 0, 1, 0);
            self.layer.transform = transform;
        }];
    }];
}

#pragma mark - Getter
- (UIView *)frontView{
    if (!_frontView) {
        _frontView = [UIView new];
        _frontView.backgroundColor = RGB(29.0, 13.0, 48.0);
    }
    return _frontView;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = RGB(29.0, 13.0, 48.0);
    }
    return _backView;
}

- (LOBankCardWorkFlow *)workflow{
    if (!_workflow) {
        _workflow = [LOBankCardWorkFlow new];
    }
    return _workflow;;
}

- (LOMasterCardLogoView *)logoView{
    if (!_logoView) {
        _logoView = [LOMasterCardLogoView new];
    }
    return _logoView;
}

- (LOFormatTextView *)cardNOView{
    if (!_cardNOView) {
        
        //设置文字格式化
        LOBankCardTypeInWork *work = self.workflow.bankCardTypeInWorkflow.firstObject;
        LOStringFormatter *formatter = [work formatter];
        
        _cardNOView = [[LOFormatTextView alloc] initWithFormatter:formatter];
        _cardNOView.font = [UIFont boldSystemFontOfSize:24];
        _cardNOView.layer.cornerRadius = 10.0;
        _cardNOView.layer.masksToBounds = YES;
        _cardNOView.layer.borderColor = CGRGB(138, 135, 106);
        _cardNOView.layer.borderWidth = 1.0;
        
        
    }
    return _cardNOView;;
}

- (UILabel *)cardHolderNameTitleView{
    if (!_cardHolderNameTitleView) {
        _cardHolderNameTitleView = [UILabel new];
        _cardHolderNameTitleView.text = @"CARDHOLDER NAME";
        _cardHolderNameTitleView.textColor = RGB(255, 255, 255);
        _cardHolderNameTitleView.font = [UIFont boldSystemFontOfSize:14];
    }
    return _cardHolderNameTitleView;;
}

- (LOTextField *)cardHolderNameView{
    if (!_cardHolderNameView) {
        
        //工作流程项
        LOBankCardTypeInWork *work = self.workflow.bankCardTypeInWorkflow[1];
        
        //初始化
        _cardHolderNameView = [LOTextField new];
        _cardHolderNameView.layer.cornerRadius = 10.0;
        _cardHolderNameView.layer.masksToBounds = YES;
        _cardHolderNameView.layer.borderColor = CGRGB(138, 135, 106);
        _cardHolderNameView.layer.borderWidth = 0.0;
        
        //左右边距
        CGRect leftRect = CGRectMake(0, 0, 6, 6);
        UIView *leftView = [[UIView alloc] initWithFrame:leftRect];
        UIView *rightView = [[UIView alloc] initWithFrame:leftRect];
        _cardHolderNameView.leftView = leftView;
        _cardHolderNameView.rightView = rightView;
        _cardHolderNameView.leftViewMode = UITextFieldViewModeAlways;
        _cardHolderNameView.rightViewMode = UITextFieldViewModeAlways;
        
        //设置键盘
        _cardHolderNameView.placeholder = work.placeholder;
        _cardHolderNameView.loPlaceHolderLabel.textColor = RGB(128, 128, 128);
        _cardHolderNameView.textColor = RGB(255, 255, 255);
        _cardHolderNameView.font = [UIFont boldSystemFontOfSize:16];
        _cardHolderNameView.enabled = NO;
        
    }
    return _cardHolderNameView;
}

- (UILabel *)cardValidThruTitleView{
    if (!_cardValidThruTitleView) {
        _cardValidThruTitleView = [UILabel new];
        _cardValidThruTitleView.text = @"VALID THRU";
        _cardValidThruTitleView.textColor = RGB(255, 255, 255);
        _cardValidThruTitleView.font = [UIFont boldSystemFontOfSize:14];
    }
    return _cardValidThruTitleView;;
}

- (LOFormatTextView *)cardValidThruView{
    if (!_cardValidThruView) {
        
        //格式化器
        LOBankCardTypeInWork *work = self.workflow.bankCardTypeInWorkflow[2];
        LOStringFormatter *formatter = [work formatter];
        
        _cardValidThruView = [[LOFormatTextView alloc] initWithFormatter:formatter];
        _cardValidThruView.font = [UIFont boldSystemFontOfSize:14];
        _cardValidThruView.layer.cornerRadius = 10.0;
        _cardValidThruView.layer.masksToBounds = YES;
        _cardValidThruView.layer.borderColor = CGRGB(138, 135, 106);
        _cardValidThruView.layer.borderWidth = 0.0;
    }
    return _cardValidThruView;
}

- (LOTextField *)cardCVVView{
    if (!_cardCVVView) {
               
        LOBankCardTypeInWork *work = self.workflow.bankCardTypeInWorkflow[3];
        
        //初始化
        _cardCVVView = [LOTextField new];
        _cardCVVView.backgroundColor = RGB(255, 255, 255);
        _cardCVVView.layer.cornerRadius = 10.0;
        _cardCVVView.layer.masksToBounds = YES;
        _cardCVVView.layer.borderColor = CGRGB(138, 135, 106);
        _cardCVVView.layer.borderWidth = 0.0;
        
        //左右边距
        CGRect leftRect = CGRectMake(0, 0, 6, 6);
        UIView *leftView = [[UIView alloc] initWithFrame:leftRect];
        UIView *rightView = [[UIView alloc] initWithFrame:leftRect];
        _cardCVVView.leftView = leftView;
        _cardCVVView.rightView = rightView;
        _cardCVVView.leftViewMode = UITextFieldViewModeAlways;
        _cardCVVView.rightViewMode = UITextFieldViewModeAlways;
        
        //设置键盘
        _cardCVVView.keyboardType = UIKeyboardTypeNumberPad;
        _cardCVVView.placeholder = work.placeholder;
        _cardCVVView.loPlaceHolderLabel.textColor = RGB(168, 168, 168);
        _cardCVVView.textColor = RGB(0, 0, 0);
        _cardCVVView.font = [UIFont boldSystemFontOfSize:20];
        _cardCVVView.textAlignment = NSTextAlignmentCenter;
        _cardCVVView.enabled = NO;
        
    }
    return _cardCVVView;
}

- (LOBankCard *)bankCard{
    if (!_bankCard) {
        _bankCard = [LOBankCard new];
    }
    return _bankCard;
}

@end
