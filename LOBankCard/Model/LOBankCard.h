//
//  LOBankCard.h
//  Demo
//
//  Created by Lion on 2021/5/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LOBankCard : NSObject
@property (nonatomic, strong) NSString *cardNO;
@property (nonatomic, strong) NSString *cardHolder;
@property (nonatomic, strong) NSString *validThru;
@property (nonatomic, strong) NSString *cvv;
@end

NS_ASSUME_NONNULL_END
