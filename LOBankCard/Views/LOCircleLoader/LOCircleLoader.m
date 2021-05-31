//
//  LOCircleLoader.m
//  Demo
//
//  Created by Lion on 2021/5/28.
//

#import "LOCircleLoader.h"

const CGFloat kRotateAnimationDuration = 0.45;
const CGFloat kDisplayDuration = 0.45;
const CGFloat kFadeAnimationDuration = 0.55;

@interface LOCircleLoader ()<CAAnimationDelegate>
@property (nonatomic, strong) CAShapeLayer *trackLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation LOCircleLoader

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self.layer addSublayer:self.trackLayer];
    [self.layer addSublayer:self.progressLayer];
}

- (void)drawBackgroundCircle {
    //贝塞尔曲线 0度是在十字右边方向   －M_PI/2相当于在十字上边方向
    CGFloat startAngle = - ((float)M_PI / 2); // 90 Degrees
    CGFloat endAngle = (2 * (float)M_PI) + - ((float)M_PI / 8);;
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = (self.bounds.size.width - _lineWidth)/2;
    
    UIBezierPath *processPath = [UIBezierPath bezierPath];
    UIBezierPath *trackPath = [UIBezierPath bezierPath];
    endAngle = (self.progressValue * 2 * (float)M_PI) + startAngle;
    
    [processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [trackPath addArcWithCenter:center radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    self.progressLayer.path = processPath.CGPath;
    self.trackLayer.path = trackPath.CGPath;
}

- (void)start {
    [self startRotationAnimation];
    [self startDisplayLink];
}

- (void)reset{
    [self setProgressValue:0.0];
    [self stopDisplayLink];
    [self.progressLayer removeAllAnimations];
    [self.trackLayer removeAllAnimations];
    [self.trackLayer setOpacity:0.0];
    [self drawBackgroundCircle];
}

- (void)startRotationAnimation{
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotateAnimation.beginTime = 0.0;
    rotateAnimation.duration = kRotateAnimationDuration;
    rotateAnimation.cumulative = YES;
    rotateAnimation.removedOnCompletion = NO;
    rotateAnimation.fillMode = kCAFillModeForwards;
    rotateAnimation.delegate = self;
    rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = @(0.0);
    fadeAnimation.toValue = @(1.0);
    fadeAnimation.removedOnCompletion = NO;
    fadeAnimation.beginTime = 0.0;
    fadeAnimation.duration = kFadeAnimationDuration;
    fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    fadeAnimation.fillMode = kCAFillModeForwards;
    fadeAnimation.delegate = self;
    
    CAAnimationGroup *group = [CAAnimationGroup new];
    [group setValue:@"groupAnimation" forKey:@"id"];
    group.animations = @[rotateAnimation, fadeAnimation];
    group.duration = MAX(kFadeAnimationDuration, kRotateAnimationDuration);
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.delegate = self;
    [self.progressLayer addAnimation:group forKey:@"rotationAnimation"];
}

- (void)startFadeAnimation{
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeAnimation setValue:@"fadeAnimation" forKey:@"id"];
    fadeAnimation.fromValue = @(0.0);
    fadeAnimation.toValue = @(1.0);
    fadeAnimation.removedOnCompletion = NO;
    fadeAnimation.beginTime = 0.0;
    fadeAnimation.duration = kFadeAnimationDuration;
    fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    fadeAnimation.fillMode = kCAFillModeForwards;
    fadeAnimation.delegate = self;
    [self.trackLayer addAnimation:fadeAnimation forKey:@"fadeAnimation"];
}

#pragma mark - CADisplayLink
- (void)startDisplayLink{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)handleDisplayLink:(CADisplayLink *)displayLink{
    self.progressValue += (1.0 / (60.0 * kDisplayDuration));
    if (self.progressValue > 1.0) {
        [self setProgressValue:1.0];
        [self stopDisplayLink];
    }
    [self drawBackgroundCircle];
}

- (void)stopDisplayLink{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished{
    NSString *animationID = [animation valueForKey:@"id"];
    if ([animationID isEqualToString:@"groupAnimation"]) {
        [self.progressLayer removeAllAnimations];
        if (self.rotateAnimationFinished) {
            self.rotateAnimationFinished();
        }
    } else {
        [self.trackLayer setOpacity:1.0];
        [self.trackLayer removeAllAnimations];
    }
}

#pragma mark - Getter
- (CAShapeLayer *)trackLayer{
    if (!_trackLayer) {
        _trackLayer = [CAShapeLayer layer];
        _trackLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _trackLayer.lineWidth = _lineWidth;
        _trackLayer.strokeColor = _trackTintColor.CGColor;
        _trackLayer.fillColor = _trackTintColor.CGColor;
        _trackLayer.lineCap = kCALineCapRound;
        _trackLayer.opacity = 0.0;
    }
    return _trackLayer;
}

- (CAShapeLayer *)progressLayer{
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _progressLayer.lineWidth = _lineWidth;
        _progressLayer.strokeColor = _progressTintColor.CGColor;
        _progressLayer.fillColor = UIColor.clearColor.CGColor;
        _progressLayer.lineCap = kCALineCapRound;
    }
    return _progressLayer;
}

@end
