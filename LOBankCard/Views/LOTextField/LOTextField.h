//
//  LOTextField.h
//  Demo
//
//  根据demo演示，文本输入框除了包含原声文本输入框的基本功能外，还需要包含以下功能：
//  1. 自定义分隔符
//     1.1 自定义分隔符是否默认添加到输入文字，默认添加
//     1.2 分隔符格式化
//     1.3 是否允许分隔符连续出现，默认不允许
//  2. 最大输入长度控制，默认0，表示不限制
//  3. 渐变色边框
//     3.1 自定义颜色
//  4. 边框长度自适应文字长度，默认不自适应
//
//  Created by Lion on 2021/5/26.
//

#import <UIKit/UIKit.h>
#import "LOStringFormatter.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LOTextFieldDelegate <NSObject>

@optional

- (BOOL)loTextFieldShouldBeginEditing:(UITextField *)textField;
- (void)loTextFieldDidBeginEditing:(UITextField *)textField;
- (BOOL)loTextFieldShouldEndEditing:(UITextField *)textField;
- (void)loTextFieldDidEndEditing:(UITextField *)textField;
- (void)loTextFieldDidEndEditing:(UITextField *)textField
                          reason:(UITextFieldDidEndEditingReason)reason API_AVAILABLE(ios(10.0));
- (BOOL)loTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (void)loTextFieldDidChangeSelection:(UITextField *)textField API_AVAILABLE(ios(13.0), tvos(13.0));

- (BOOL)loTextFieldShouldClear:(UITextField *)textField;
- (BOOL)loTextFieldShouldReturn:(UITextField *)textField;

@end


@interface LOTextField : UITextField
@property (nullable, nonatomic, weak) id<LOTextFieldDelegate> loDelegate;
@property (nonatomic, strong) LOStringFormatter *formatter;
@property (nonatomic, copy) void(^textFieldValueDidChanged)(NSString *);

/// 根据指定的格式化模型进行初始化
/// @param formatter  格式化模型
- (instancetype)initWithFormatter:(LOStringFormatter *)formatter;
@end

NS_ASSUME_NONNULL_END
