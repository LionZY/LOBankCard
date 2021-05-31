//
//  LOCornerButton.h
//  Demo
//
//  Created by Lion on 2021/5/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LOCornerButton : UIButton
@property (nonatomic, copy) void(^didTouchUpInside)(void);
@end

NS_ASSUME_NONNULL_END
