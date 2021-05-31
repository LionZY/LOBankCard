//
//  LOCardNoView.m
//  Demo
//
//  卡号容器
//  Created by Lion on 2021/5/28.
//

#import "LOFormatTextView.h"
#import "LOStringFormatter.h"
#import "NSString+Format.h"
#import "MacroTheme.h"
#import "UITextField+Placeholer.h"
#import "LOFocusProtocol.h"

#import <Masonry/Masonry.h>

@interface LOFormatTextView ()<LOFocusProtocol>
@property (nonatomic, strong) NSMutableArray *childViews;
@property (nonatomic, strong) NSMutableArray *seperatorViews;
@end

@implementation LOFormatTextView

/// 根据指定的格式化模型进行初始化
/// @param formatter  格式化模型
- (instancetype)initWithFormatter:(LOStringFormatter *)formatter{
    self = [super init];
    if (self) {
        self.font = [UIFont boldSystemFontOfSize:14];
        self.formatter = formatter;
        [self setupUI];
    }
    return self;
}

#pragma mark - Setup UI
- (void)setupUI{
    
    //根据格式化器创建均分的显示试图
    __block NSInteger index = 0;
    NSArray *lengths = self.formatter.lengths;
    NSString *unformatStr = [self.formatter.formatString unformat:self.formatter];
    [lengths enumerateObjectsUsingBlock:^(NSNumber *lengthNum, NSUInteger idx, BOOL * _Nonnull stop) {
        //创建普通文字占位符
        NSInteger length = lengthNum.integerValue;
        NSMutableArray *segments = [NSMutableArray array];
        for (NSInteger i = 0; i < length; i++) {
            NSString *placeHolder = [unformatStr substringWithRange:NSMakeRange(index, 1)];
            UITextField *noView = [self createCardNoView:placeHolder];
            [segments addObject:noView];
            ++index;
        }
        [self.childViews addObject:segments];
    }];
    
    for (NSInteger i = 0; i < lengths.count - 1; i++) {
        UITextField *seperatorView = [self createSeperatorView];
        [self.seperatorViews addObject:seperatorView];
    }
}

#pragma mark - Private
- (UITextField *)createCardNoView:(NSString *)placeHolder{
    
    //创建不可编辑的输入框
    UITextField *textField = [UITextField new];
    textField.enabled = NO;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.placeholder = placeHolder;
    
    //设置颜色
    textField.textColor = RGB(255, 255, 255);
        
    //设置placeholder颜色
    textField.loPlaceHolderLabel.textColor = RGB(128, 128, 128);
    
    //添加到本视图
    [self addSubview:textField];
    
    return textField;
    
}

- (UITextField *)createSeperatorView{
    
    //创建不可编辑的输入框
    UITextField *textField = [UITextField new];
    textField.enabled = NO;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.placeholder = self.formatter.seperator;
    
    //设置颜色
    textField.textColor = RGB(255, 255, 255);
        
    //设置placeholder颜色
    textField.loPlaceHolderLabel.textColor = RGB(128, 128, 128);
    
    //添加到本视图
    [self addSubview:textField];
    
    return textField;
    
}

#pragma mark - Layout
- (void)layoutSubviews{
    [super layoutSubviews];
    [self updateChildViewsLayout];
}

- (void)updateChildViewsLayout{
    
    NSArray *lenghts = self.formatter.lengths;
    NSInteger segmentCount = lenghts.count;
    NSInteger seperatorCount = segmentCount - 1;
    NSString *unformatStr = [self.formatter.formatString unformat:self.formatter];
    
    __block CGFloat leftMargin = 6;
    __block CGFloat rightMargin = 6;
    __block CGFloat originX = leftMargin;
    __block CGFloat totalWidth = CGRectGetWidth(self.bounds);
    
    //根据格式化器创建均分的显示试图
    __block CGFloat childTotalWidth = 0;
    NSDictionary *attr = @{ NSFontAttributeName:self.font };
    NSMutableArray *childWidths = [NSMutableArray arrayWithCapacity:unformatStr.length];
    for (NSInteger idx = 0; idx < unformatStr.length; idx++) {
        NSString *placeHolder = [unformatStr substringWithRange:NSMakeRange(idx, 1)];
        CGFloat width = [placeHolder sizeWithAttributes:attr].width;
        [childWidths addObject:@(width)];
        childTotalWidth += width;
    }
    
    __block NSInteger index = 0;
    __block CGFloat seperatorWidth = (totalWidth - childTotalWidth - leftMargin - rightMargin) / seperatorCount;
    [self.childViews enumerateObjectsUsingBlock:^(NSArray *segments, NSUInteger idx1, BOOL * _Nonnull stop) {
        [segments enumerateObjectsUsingBlock:^(UITextField *cardNoView, NSUInteger idx2, BOOL * _Nonnull stop) {
            CGFloat width = [childWidths[index] floatValue];
            [cardNoView setFont:self.font];
            [cardNoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(originX);
                make.top.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
                make.width.mas_equalTo(width);
            }];
            originX += width;
            ++index;
        }];
        
        if (idx1 < self.seperatorViews.count) {
            UITextField *seperatorView = self.seperatorViews[idx1];
            [seperatorView setFont:self.font];
            [seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(originX);
                make.top.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
                make.width.mas_equalTo(seperatorWidth);
            }];
        }
        
        originX += seperatorWidth;
    }];
}

- (void)updateChildViewsText{
    __block NSInteger index = 0;
    NSString *unformatStr = [self.text unformat:self.formatter];
    [self.childViews enumerateObjectsUsingBlock:^(NSArray *segments, NSUInteger idx1, BOOL * _Nonnull stop1) {
        [segments enumerateObjectsUsingBlock:^(UITextField *item, NSUInteger idx2, BOOL * _Nonnull stop2) {
            NSRange range = NSMakeRange(index, 1);
            BOOL check = (index < unformatStr.length);
            NSString *value = check? [unformatStr substringWithRange:range] : @"";
            [item setText:value];
            ++index;
        }];
        
        if (idx1 < self.seperatorViews.count) {
            UITextField *seperatorView = self.seperatorViews[idx1];
            [seperatorView setText:unformatStr.length > 0? self.formatter.seperator  : @""];
        }
        
    }];
}

#pragma mark - Getter
- (NSMutableArray *)childViews{
    if (!_childViews) {
        _childViews = [NSMutableArray array];
    }
    return _childViews;
}

- (NSMutableArray *)seperatorViews{
    if (!_seperatorViews) {
        _seperatorViews = [NSMutableArray array];
    }
    return _seperatorViews;
}

#pragma mark - Setter
- (void)setText:(NSString *)text{
    _text = text;
    [self updateChildViewsText];
}

#pragma mark - LOFocusProtocol
- (void)setFocus:(BOOL)focus{
    self.layer.borderWidth = focus? 1.0 : 0.0;
}
@end
