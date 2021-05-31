//
//  ViewController.m
//  Demo
//
//  Created by Lion on 2021/5/26.
//

#import "LOTypeYourCardVC.h"
#import "MacroTheme.h"
#import "LOStringFormatter.h"
#import "LOBankCardView.h"
#import "LOTextField.h"
#import "LOBankCardWorkFlow.h"
#import "LOBankCardTypeInWork.h"
#import "UITextField+Placeholer.h"
#import "LOCornerButton.h"
#import "LOBankCard.h"

#import <Masonry/Masonry.h>

@interface LOTypeYourCardVC ()
@property (nonatomic, strong) LOBankCardView *bankCardView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *typeInLabel;
@property (nonatomic, strong) LOTextField *typeInTextField;
@property (nonatomic, strong) LOCornerButton *completeBtn;
@end

@implementation LOTypeYourCardVC

#pragma mark - Life's Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //配置界面
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.bankCardView startLogoAnimation];
}

#pragma mark - Setup UI
- (void)setupUI{
    
    //设置标题
    self.title = @"Type Your Card";
    
    //添加卡片
    [self.view addSubview:self.bankCardView];
    [self.bankCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.top.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.height.equalTo(self.bankCardView.mas_width).multipliedBy(200.f/290.f);
    }];
    
    //标题
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bankCardView);
        make.top.equalTo(self.bankCardView.mas_bottom).offset(16);
        make.trailing.equalTo(self.bankCardView);
        make.height.mas_equalTo(24);
    }];
    
    //输入框标签
    [self.view addSubview:self.typeInLabel];
    [self.typeInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bankCardView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(16);
        make.trailing.equalTo(self.bankCardView);
        make.height.mas_equalTo(14);
    }];
    
    //添加输入框
    [self.view addSubview:self.typeInTextField];
    [self.typeInTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bankCardView);
        make.top.equalTo(self.typeInLabel.mas_bottom).offset(10);
        make.trailing.equalTo(self.bankCardView);
        make.height.mas_equalTo(50.0);
    }];
    
    //TODO: 下一步按钮
    [self.view addSubview:self.completeBtn];
    [self.completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeInTextField.mas_bottom).offset(8);
        make.trailing.equalTo(self.bankCardView);
        make.width.mas_equalTo(60.0);
        make.height.mas_equalTo(44.0);
    }];
}

#pragma mark - Getter
- (LOBankCardView *)bankCardView{
    if (!_bankCardView) {
        
        __weak LOTypeYourCardVC *weakSelf = self;
        _bankCardView = [LOBankCardView new];
        _bankCardView.workflow.currentWorkWillChange = ^{
            [weakSelf.bankCardView resinLastResponder];
        };
        
        _bankCardView.workflow.currentWorkDidChanged = ^{
            LOBankCardTypeInWork *currentWork =  weakSelf.bankCardView.workflow.currentWork;
            weakSelf.typeInLabel.text = currentWork.title;
            weakSelf.typeInTextField.text = weakSelf.bankCardView.currentStepText;
            weakSelf.typeInTextField.formatter = currentWork.formatter;
            weakSelf.typeInTextField.keyboardType = currentWork.keyboardType;
            [weakSelf.completeBtn setTitle:currentWork.actionName forState:UIControlStateNormal];
            [weakSelf.bankCardView syncFirstResponder];
            [weakSelf.typeInTextField reloadInputViews];
        };
    }
    return _bankCardView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"Tape in your card details:";
        _titleLabel.textColor = UIColor.blackColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:24];
    }
    return _titleLabel;
}

- (UILabel *)typeInLabel{
    if (!_typeInLabel) {
        LOBankCardTypeInWork *currentWork =  self.bankCardView.workflow.currentWork;
        _typeInLabel = [UILabel new];
        _typeInLabel.text = currentWork.title;
    }
    return _typeInLabel;
}

- (LOTextField *)typeInTextField{
    if (!_typeInTextField) {
        
        //当前的工作
        LOBankCardTypeInWork *currentWork = self.bankCardView.workflow.currentWork;
        
        _typeInTextField = [[LOTextField alloc] initWithFormatter:currentWork.formatter];
        _typeInTextField.layer.cornerRadius = 10.0;
        _typeInTextField.layer.masksToBounds = YES;
        _typeInTextField.layer.borderColor = CGRGB(138, 135, 106);
        _typeInTextField.layer.borderWidth = 1.0;
        
        //左右边距和填充视图
        CGRect leftRect = CGRectMake(0, 0, 10, 10);
        UIView *leftView = [[UIView alloc] initWithFrame:leftRect];
        UIView *rightView = [[UIView alloc] initWithFrame:leftRect];
        _typeInTextField.leftView = leftView;
        _typeInTextField.rightView = rightView;
        _typeInTextField.leftViewMode = UITextFieldViewModeAlways;
        _typeInTextField.rightViewMode = UITextFieldViewModeAlways;
        
        _typeInTextField.keyboardType = UIKeyboardTypeNumberPad;
        _typeInTextField.tintColor = RGB(0, 0, 0);
        _typeInTextField.loPlaceHolderLabel.textColor = RGB(128, 128, 128);
        _typeInTextField.textColor = RGB(138, 135, 106);
        _typeInTextField.font = [UIFont boldSystemFontOfSize:20];
        
        //文字变化回调
        __weak LOTypeYourCardVC *weakSelf = self;
        _typeInTextField.textFieldValueDidChanged = ^(NSString *text) {
            [weakSelf.bankCardView syncText:text];
        };
        
    }
    return _typeInTextField;
}

- (LOCornerButton *)completeBtn{
    if (!_completeBtn) {
        _completeBtn = [LOCornerButton new];
        _completeBtn.backgroundColor = UIColor.blackColor;
        [_completeBtn setTitle:@"Next" forState:UIControlStateNormal];
        [_completeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        __weak LOTypeYourCardVC *weakSelf = self;
        [_completeBtn setDidTouchUpInside:^{
            NSInteger count = weakSelf.bankCardView.workflow.bankCardTypeInWorkflow.count;
            NSInteger currentStep = weakSelf.bankCardView.workflow.step;
            if (currentStep == count - 1) {
                [weakSelf.bankCardView jumpToPreStep];
            } else {
                [weakSelf.bankCardView jumpToNextStep];
            }
        }];
    }
    return _completeBtn;
}

@end
