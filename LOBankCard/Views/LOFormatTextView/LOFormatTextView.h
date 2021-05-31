//
//  LOCardNoView.h
//  Demo
//
//  Created by Lion on 2021/5/28.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class LOStringFormatter;
@interface LOFormatTextView : UIView
@property (nonatomic, strong) LOStringFormatter *formatter;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;

/// 根据指定的格式化模型进行初始化
/// @param formatter  格式化模型
- (instancetype)initWithFormatter:(LOStringFormatter *)formatter;

@end

NS_ASSUME_NONNULL_END
