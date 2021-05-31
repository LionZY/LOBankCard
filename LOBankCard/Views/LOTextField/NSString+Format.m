//
//  NSString+Format.m
//  Demo
//
//  Created by Lion on 2021/5/26.
//

#import "NSString+Format.h"
#import "LOStringFormatter.h"

@implementation NSString(Format)

/// 格式化分段
/// @param format 格式化
- (NSArray *)components:(LOStringFormatter *)format{
    
    NSArray *lengths = [format lengths];
    
    //若没有拿到格式分段长度数组，则直接返回空
    if (!lengths) {
        return nil;
    }
    
    //得到未格式化过的字符串
    NSString *unformatString = [self unformat:format];
    
    //存储字符串分段
    __block NSMutableArray *components = [NSMutableArray arrayWithCapacity:lengths.count];
    
    //遍历需要格式化的长度分组
    __block NSInteger enumerateLength = 0;
    [lengths enumerateObjectsUsingBlock:^(NSNumber *lengthNum, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //得到当前遍历到的格式化分段长度
        NSInteger itemLength = lengthNum.integerValue;
        
        //计算截取范围的起始位置
        NSInteger location = enumerateLength;
        
        //下一个遍历到的分段的长度和
        NSInteger nextLength = enumerateLength + itemLength;
        
        //判断下一个最大长度是否小于等于未格式化字符串的长度
        BOOL check1 = nextLength <= unformatString.length;
        
        //判断已经枚举到的长度和是否小于未格式化字符串的长度
        BOOL check2 = enumerateLength < unformatString.length;
        
        //计算截取范围
        NSInteger length = 0;
        if(check1){
            length = itemLength;
        } else if (check2){
            length = unformatString.length - enumerateLength;
        }
        
        //如果存在截取范围，则截取字符串
        if (length > 0) {
            NSRange range = NSMakeRange(location, length);
            NSString *component = [unformatString substringWithRange:range];
            [components addObject:component];
        }
        
        //合并遍历总长度
        enumerateLength += itemLength;
        
    }];
    
    return components;
    
}

/// 格式化字符串
/// @param format 格式化
- (NSString *)format:(LOStringFormatter *)format{
    
    NSArray<NSString *> *components = [self components:format];
    if (components.count == 0) {
        return self;
    }
    
    NSString *result = [components componentsJoinedByString:format.seperator];
    return result;
    
}

/// 格式化字符串, 将原来的字符串映射到格式上返回
/// @param format 格式化
- (NSString *)formatForEdit:(LOStringFormatter *)format{
    NSArray<NSString *> *components = [self components:format];
    if (components.count == 0) {
        return self;
    }
    
    NSString *result = [components componentsJoinedByString:format.seperator];
    //补充后缀
    if (components.count > 0 &&
        components.count != format.lengths.count &&
        components.lastObject.length == [format.lengths[components.count - 1] integerValue]
        ) {
        result = [result stringByAppendingString:format.seperator];
    }
    return result;
}

/// 恢复被格式化过的字符串
/// @param format  格式化
- (NSString *)unformat:(LOStringFormatter *)format{
    
    //自身范围
    NSRange range = NSMakeRange(0, self.length);
    
    //分隔符
    NSString *seperator = format.seperator? : @"";
    
    //先清理掉分隔符
    NSMutableString *result =  [self mutableCopy];
    [result replaceOccurrencesOfString:seperator
                              withString:@""
                                 options:NSLiteralSearch
                                   range:range];
    return result;
}

@end
