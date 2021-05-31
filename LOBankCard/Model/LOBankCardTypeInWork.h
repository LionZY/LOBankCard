//
//  LOBankCardTypeInFlow.h
//  Demo
//
//  Created by Lion on 2021/5/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LOStringFormatter;
@interface LOBankCardTypeInWork : NSObject
@property (nonatomic, strong) LOStringFormatter *formatter;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSString *actionName;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@end

NS_ASSUME_NONNULL_END
