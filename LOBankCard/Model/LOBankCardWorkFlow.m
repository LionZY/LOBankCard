//
//  LOBankCardTypeInWorkFlow.m
//  Demo
//
//  Created by Lion on 2021/5/29.
//

#import "LOBankCardWorkFlow.h"
#import "LOBankCardTypeInWork.h"
#import "LOStringFormatter.h"

@implementation LOBankCardWorkFlow

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentWork = self.bankCardTypeInWorkflow.firstObject;
    }
    return self;
}

#pragma mark - Public
- (void)jumpToNextStep{
    NSInteger currentIndex = [self.bankCardTypeInWorkflow indexOfObject:self.currentWork];
    NSInteger nextIndex = currentIndex + 1;
    if (nextIndex < self.bankCardTypeInWorkflow.count) {
        self.currentWork = self.bankCardTypeInWorkflow[nextIndex];
    }
}

- (void)jumpToPreStep{
    NSInteger currentIndex = [self.bankCardTypeInWorkflow indexOfObject:self.currentWork];
    NSInteger nextIndex = currentIndex - 1;
    if (nextIndex < self.bankCardTypeInWorkflow.count && nextIndex >= 0) {
        self.currentWork = self.bankCardTypeInWorkflow[nextIndex];
    }
}

- (NSInteger)step{
    NSInteger currentIndex = [self.bankCardTypeInWorkflow indexOfObject:self.currentWork];
    return currentIndex;
}

#pragma mark - Getter
- (NSMutableArray<LOBankCardTypeInWork *> *)bankCardTypeInWorkflow{
    if (!_bankCardTypeInWorkflow) {
        _bankCardTypeInWorkflow = [NSMutableArray arrayWithCapacity:4];
        
        //添加银行卡号需要的数据
        LOStringFormatter *formatter = [LOStringFormatter new];
        formatter.formatString = @"XXXX XXXX XXXX XXXX";
        formatter.seperator = @" ";
        LOBankCardTypeInWork *cardNo = [LOBankCardTypeInWork new];
        cardNo.formatter = formatter;
        cardNo.title = @"Card Number";
        cardNo.placeholder = @"XXXX XXXX XXXX XXXX";
        cardNo.actionName = @"Next";
        cardNo.keyboardType = UIKeyboardTypeNumberPad;
        [_bankCardTypeInWorkflow addObject:cardNo];
        
        //持卡人姓名
        LOBankCardTypeInWork *cardHolder = [LOBankCardTypeInWork new];
        cardHolder.title = @"Cardholder Name";
        cardHolder.placeholder = @"NAME SURNAME";
        cardHolder.actionName = @"Next";
        cardHolder.keyboardType = UIKeyboardTypeASCIICapable;
        [_bankCardTypeInWorkflow addObject:cardHolder];
        
        //过期时间
        formatter = [LOStringFormatter new];
        formatter.formatString = @"MM/YY";
        formatter.seperator = @"/";
        LOBankCardTypeInWork *validThru = [LOBankCardTypeInWork new];
        validThru.formatter = formatter;
        validThru.title = @"Valid Thru";
        validThru.placeholder = @"MM/YY";
        validThru.actionName = @"Next";
        validThru.keyboardType = UIKeyboardTypeNumberPad;
        [_bankCardTypeInWorkflow addObject:validThru];
        
        //安全码
        LOBankCardTypeInWork *cvv = [LOBankCardTypeInWork new];
        formatter = [LOStringFormatter new];
        formatter.formatString = @"XXX";
        formatter.seperator = @"";
        cvv.formatter = formatter;
        cvv.title = @"Security Code (CVV)";
        cvv.placeholder = @"XXX";
        cvv.actionName = @"Done";
        cvv.keyboardType = UIKeyboardTypeNumberPad;
        [_bankCardTypeInWorkflow addObject:cvv];
    }
    return _bankCardTypeInWorkflow;
}

#pragma mark - Setter
- (void)setCurrentWork:(LOBankCardTypeInWork *)currentWork{
    
    //回调block
    if (self.currentWorkWillChange) {
        self.currentWorkWillChange();
    }
    
    //当前处理的工作
    _currentWork = currentWork;
    
    //回调block
    if (self.currentWorkDidChanged) {
        self.currentWorkDidChanged();
    }
}

@end
