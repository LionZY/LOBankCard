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
    //??????
    BOOL flag = YES;
    
    //???????????????????????????
    SEL delegateSel = @selector(loTextField:shouldChangeCharactersInRange:replacementString:);
    
    //???????????????
    NSString *upperCaseStr = [string uppercaseString];
    
    //?????????????????????
    NSString *currentStr = [textField.text uppercaseString];
    
    //???????????????????????????
    NSString *willReplaceStr = [currentStr substringWithRange:range];
    
    //?????????????????????????????????
    NSString *beingStr = [currentStr stringByReplacingCharactersInRange:range withString:upperCaseStr] ? : upperCaseStr;
    
    //????????????????????????????????????, ?????????????????????????????????
    BOOL isDelete = (string.length == 0);
    
    //??????formatter??????
    if (self.formatter) {

        BOOL isSeperator = [willReplaceStr isEqualToString:self.formatter.seperator];
        if (isSeperator && isDelete) {
            //????????????????????????
            NSRange realRange = NSMakeRange(range.location - 1, range.length + 1);
            beingStr = [currentStr stringByReplacingCharactersInRange:realRange withString:upperCaseStr];
        }
        
        //???????????????
        beingStr = [beingStr formatForEdit:self.formatter];
        
        //????????????????????????
        if (beingStr.length > self.formatter.formatString.length) {
            return NO;
        }
    }
    
    //????????????
    textField.text = beingStr;
    
    if (self.textFieldValueDidChanged) {
        //??????
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
