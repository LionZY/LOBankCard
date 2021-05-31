//
//  LOBankCardTypeInWorkFlow.h
//  Demo
//
//  Created by Lion on 2021/5/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LOBankCardTypeInWork;
@interface LOBankCardWorkFlow : NSObject
@property (nonatomic, strong) LOBankCardTypeInWork *currentWork;
@property (nonatomic, strong) NSMutableArray<LOBankCardTypeInWork *> *bankCardTypeInWorkflow;
@property (nonatomic, copy) void(^currentWorkWillChange)(void);
@property (nonatomic, copy) void(^currentWorkDidChanged)(void);
- (NSInteger)step;
- (void)jumpToNextStep;
- (void)jumpToPreStep;
@end

NS_ASSUME_NONNULL_END
