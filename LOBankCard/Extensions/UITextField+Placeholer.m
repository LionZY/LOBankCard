//
//  UITextField+Placeholer.m
//  Demo
//
//  Created by Lion on 2021/5/29.
//

#import "UITextField+Placeholer.h"

@implementation UITextField(LOPlaceHolder)
- (UILabel *)loPlaceHolderLabel{
    Ivar ivar =  class_getInstanceVariable([self class], "_placeholderLabel");
    UILabel *placeholderLabel = object_getIvar(self, ivar);
    return placeholderLabel;
}
@end
