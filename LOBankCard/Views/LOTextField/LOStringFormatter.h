//
//  LOStringFormatter.h
//  Demo
//
//  Created by Lion on 2021/5/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LOStringFormatter : NSObject

/// 格式化模板
@property(nonatomic, strong) NSString *formatString;

/// 分隔符
@property(nonatomic, strong) NSString *seperator;

/// 按分隔符分组后的分段长度数组
- (NSArray *)lengths;

@end

NS_ASSUME_NONNULL_END
