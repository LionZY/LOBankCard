//
//  LOStringFormatter.m
//  Demo
//
//  Created by Lion on 2021/5/27.
//

#import "LOStringFormatter.h"

@implementation LOStringFormatter

/// 按分隔符分组后的分段长度数组
- (NSArray *)lengths{
        
    if (!self.formatString ||
        ![self.formatString isKindOfClass:NSString.class] ||
        self.formatString.length == 0 ||
        ![self.seperator isKindOfClass:NSString.class] ||
        self.seperator.length == 0
        ) {
        return nil;
    }
    
    NSArray<NSString *> *components = [self.formatString componentsSeparatedByString:self.seperator];
    NSMutableArray *lengths = [NSMutableArray arrayWithCapacity:components.count];
    [components enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [lengths addObject:@(obj.length)];
    }];
    
    return lengths;
}

@end
