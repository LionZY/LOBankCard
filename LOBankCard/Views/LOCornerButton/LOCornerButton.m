//
//  LOCornerButton.m
//  Demo
//
//  Created by Lion on 2021/5/29.
//

#import "LOCornerButton.h"

@implementation LOCornerButton
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addTarget:self action:@selector(didTapSelf) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)didTapSelf{
    if (self.didTouchUpInside) {
        self.didTouchUpInside();
    }
}

@end
