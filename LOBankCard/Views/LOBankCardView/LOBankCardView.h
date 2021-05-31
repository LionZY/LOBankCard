//
//  LOBankCardView.h
//  Demo
//  本视图是银行卡卡片视图，以及对其子视图的组合封装
//  Created by Lion on 2021/5/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LOBankCard;
@class LOBankCardWorkFlow;
@interface LOBankCardView : UIView
@property (nonatomic, strong) LOBankCardWorkFlow *workflow;
@property (nonatomic, strong) LOBankCard *bankCard;
- (void)startLogoAnimation;
- (void)jumpToNextStep;
- (void)jumpToPreStep;
- (void)syncText:(NSString *)text;
- (void)resinLastResponder;
- (void)syncFirstResponder;
- (NSString *)currentStepText;
@end

NS_ASSUME_NONNULL_END
