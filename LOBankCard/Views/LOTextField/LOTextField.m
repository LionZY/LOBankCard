//
//  LOTextField.m
//  Demo
//
//  Created by Lion on 2021/5/26.
//

#import "LOTextField.h"
#import "NSString+Format.h"
#import "LOFocusProtocol.h"

@interface LOTextField ()<UITextFieldDelegate, LOFocusProtocol>
@end

@implementation LOTextField

#pragma mark - Life's Circle
- (instancetype)initWithFormatter:(LOStringFormatter *)formatter;
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.formatter = formatter;
        [self addObservers];
    }
    return self;
}

- (void)dealloc
{
    [self removeObservers];
}

#pragma mark - Observers
- (void)addObservers{
    [self addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)removeObservers{
    [self removeTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldValueChanged:(UITextField *)textField{
    if (self.textFieldValueDidChanged) {
        self.textFieldValueDidChanged(textField.text);
    }
}

#pragma mark - UITextFieldDelegate's Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    BOOL flag = YES;
    if ([self.loDelegate respondsToSelector:@selector(loTextFieldShouldBeginEditing:)]) {
        flag = [self.loDelegate loTextFieldShouldBeginEditing:textField];
    }
    return flag;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.loDelegate respondsToSelector:@selector(loTextFieldDidBeginEditing:)]) {
        [self.loDelegate loTextFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    BOOL flag = YES;
    if ([self.loDelegate respondsToSelector:@selector(loTextFieldShouldEndEditing:)]) {
       flag = [self.loDelegate loTextFieldShouldEndEditing:textField];
    }
    return flag;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.loDelegate respondsToSelector:@selector(loTextFieldDidEndEditing:)]) {
        [self.loDelegate loTextFieldDidEndEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
    if ([self.loDelegate respondsToSelector:@selector(loTextFieldDidEndEditing:reason:)]) {
        [self.loDelegate loTextFieldDidEndEditing:textField reason:reason];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //结果
    BOOL flag = YES;
    
    //要检查的方法选择器
    SEL delegateSel = @selector(loTextField:shouldChangeCharactersInRange:replacementString:);
    
    //大写字符串
    NSString *upperCaseStr = [string uppercaseString];
    
    //得到当前字符串
    NSString *currentStr = [textField.text uppercaseString];
    
    //当前要替换的字符串
    NSString *willReplaceStr = [currentStr substringWithRange:range];
    
    //将要替换为的结果字符串
    NSString *beingStr = [currentStr stringByReplacingCharactersInRange:range withString:upperCaseStr] ? : upperCaseStr;
    
    //如果当前要删除的是分隔符, 则表示要删除它的前一位
    BOOL isDelete = (string.length == 0);
    
    //拟合formatter规则
    if (self.formatter) {

        BOOL isSeperator = [willReplaceStr isEqualToString:self.formatter.seperator];
        if (isSeperator && isDelete) {
            //实际要替换的范围
            NSRange realRange = NSMakeRange(range.location - 1, range.length + 1);
            beingStr = [currentStr stringByReplacingCharactersInRange:realRange withString:upperCaseStr];
        }
        
        //重新格式化
        beingStr = [beingStr formatForEdit:self.formatter];
        
        //超出长度则不处理
        if (beingStr.length > self.formatter.formatString.length) {
            return NO;
        }
    }
    
    //重新设置
    textField.text = beingStr;
    
    if (self.textFieldValueDidChanged) {
        //回调
        [self textFieldValueChanged:textField];
    }
    
    if ([self.loDelegate respondsToSelector:delegateSel]) {
        flag = [self.loDelegate loTextField:textField shouldChangeCharactersInRange:range replacementString:upperCaseStr];
    }
    return NO;
}

- (void)textFieldDidChangeSelection:(UITextField *)textField{
    if ([self.loDelegate respondsToSelector:@selector(loTextFieldDidChangeSelection:)]) {
        [self.loDelegate loTextFieldDidChangeSelection:textField];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    BOOL flag = YES;
    if ([self.loDelegate respondsToSelector:@selector(loTextFieldShouldClear:)]) {
       flag = [self.loDelegate loTextFieldShouldClear:textField];
    }
    return flag;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    BOOL flag = YES;
    if ([self.loDelegate respondsToSelector:@selector(loTextFieldShouldReturn:)]) {
       flag = [self.loDelegate loTextFieldShouldReturn:textField];
    }
    return flag;
}

#pragma mark - LOFocusProtocol
- (void)setFocus:(BOOL)focus{
    self.layer.borderWidth = focus? 1.0 : 0.0;
}
@end
