//
//  NSString+Format.h
//  Demo
//
//  字符串格式化，用于银行卡，手机号的自动间隔符填充和删除
//  Created by Lion on 2021/5/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LOStringFormatter;
@interface NSString(Format)

/// 格式化分段
/// @param format 格式化
- (NSArray *)components:(LOStringFormatter *)format;

/// 格式化字符串, 将原来的字符串映射到格式上返回
/// @param format 格式化
- (NSString *)format:(LOStringFormatter *)format;

/// 格式化字符串, 将原来的字符串映射到格式上返回
/// @param format 格式化
- (NSString *)formatForEdit:(LOStringFormatter *)format;

/// 回复被格式化过的字符串
/// @param format  格式化
- (NSString *)unformat:(LOStringFormatter *)format;

@end

NS_ASSUME_NONNULL_END
