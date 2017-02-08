//
//  LoadingView.m
//  MaoYanLoadingRefresh
//
//  Created by APPLE on 17/2/8.
//  Copyright © 2017年 David. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView()

@property (nonatomic, weak) UIView              *hudView;
@property (nonatomic, strong) NSArray           *ringsColor;
@property (nonatomic, strong) NSArray           *shapeLayers;
@property (nonatomic, assign) NSInteger         animationIndex;

@end

@implementation LoadingView

+ (instancetype)standardView {
    LoadingView *loadingView = [[LoadingView alloc] initWithFrame: CGRectZero];
    loadingView.bounds = CGRectMake(0.0, 0.0, 7*5, 7);//间距：14px, 圆形大小:14px
    return loadingView;
}

+ (instancetype)standardViewShowOnView:(UIView *)aView {
    LoadingView *loadingView = [[LoadingView alloc] initWithFrame:aView.bounds];
    return loadingView;
}

- (instancetype)initWithView:(UIView *)view {
    return [self initWithFrame:view.bounds];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0.0;
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            _diameter = 7.0;
        } else {
            _diameter = 7.0;
        }
        [self initSubviews];
        
        self.ringsColor = @[[UIColor grayColor],
                            [UIColor grayColor],
                            [UIColor grayColor]
                            ];
        
        self.backgroundColor = [UIColor clearColor];
        _hudView.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    [self layout];
}

- (void)layout {
    CGFloat hudWidth;
    CGFloat hudHeight;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        hudWidth = 200.0;
        hudHeight = 80.0;
    } else {
        hudWidth = 210.0;
        hudHeight = 90.0;
    }
    self.hudView.frame = CGRectMake((CGRectGetWidth(self.bounds)-hudWidth)*0.5, (CGRectGetHeight(self.bounds)-hudHeight)*0.5, hudWidth, hudHeight);
}

#pragma mark - init Method
- (void)initSubviews {
    UIView *hudView = [[UIView alloc] initWithFrame:CGRectZero];
    _hudView = hudView;
    _hudView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_hudView];
    
    UILabel *stringLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    stringLabel.backgroundColor = [UIColor clearColor];
    stringLabel.font = [UIFont systemFontOfSize:16.0f];
    stringLabel.textColor = [UIColor whiteColor];
    stringLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - Private Method
- (NSArray *)createColorShapes:(NSArray *)colors {
    NSMutableArray *shapesArray = [NSMutableArray array];
    
//    CGFloat x = (CGRectGetWidth(_hudView.bounds)-_diameter*(_ringsColor.count*2-1))*0.5;
    CGFloat x = CGRectGetWidth(_hudView.bounds)*0.5;
    CGFloat y;
    y = CGRectGetHeight(_hudView.bounds)*0.5;
    CGPoint lastPoint = CGPointMake(x, y);
    for (UIColor *color in colors) {
        CGRect rect = CGRectMake(lastPoint.x, lastPoint.y, self.diameter, self.diameter);
//        CGPoint newPoint = [self nextPointFromPoint:lastPoint];
//        lastPoint = newPoint;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddEllipseInRect(path, NULL, rect);
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = color.CGColor;
        shapeLayer.path = path;
        shapeLayer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerTopEdge | kCALayerBottomEdge;
        shapeLayer.allowsEdgeAntialiasing = YES;
        CGPathRelease(path);
        [shapesArray addObject:shapeLayer];
    }
    
    return shapesArray;
}

- (CGPoint)nextPointFromPoint:(CGPoint)point {
    CGPoint newPoint = CGPointZero;
    newPoint.x = point.x + _diameter*2;
    newPoint.y = point.y;
    return newPoint;
}

- (void)startAnimation {
    NSTimeInterval interval = 0;
    for (int i = 0; i< self.shapeLayers.count; i++) {
        
        CALayer *layer = [self.shapeLayers objectAtIndex:i];
        __weak typeof(self) wself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [wself addAnimationToLayer:layer];
        });
        interval += 0.22;
    }
}

- (void)removeAniamtions {
    for (int i = 0; i< self.shapeLayers.count; i++) {
        CALayer *layer = [self.shapeLayers objectAtIndex:i];
        [layer removeAllAnimations];
    }
}

- (CALayer *)layerOfIndex:(NSInteger)index {
    return [_shapeLayers objectAtIndex:index];
}

- (void)addAnimationToLayer:(CALayer *)layer {
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    fadeInAnimation.toValue = [NSNumber numberWithFloat:0.0];
    fadeInAnimation.autoreverses = YES;
    fadeInAnimation.removedOnCompletion = NO;
    fadeInAnimation.duration = 0.44f;
    fadeInAnimation.repeatCount = MAXFLOAT;
    [layer addAnimation:fadeInAnimation forKey:nil];
}


#pragma mark - Show/Dismiss Method
- (void)show {
    [self showWithAnimation:NO];
}

- (void)showWithAnimation:(BOOL)animated {
    self.isLoading = YES;
    
    [self layout];
    _animationIndex = 0;
    
    if (self.shapeLayers.count == 0) {
        self.shapeLayers = [self createColorShapes:_ringsColor];
        for (CAShapeLayer *layer in _shapeLayers) {
            [_hudView.layer addSublayer:layer];
        }
    }
    
    if (animated) {
        [UIView animateWithDuration:0.44f
                         animations:^{
                             self.alpha = 1.0f;
                         } completion:^(BOOL finished) {
                             
                         }];
    } else {
        self.alpha = 1.0f;
    }
}

- (void)showWithAnimation:(BOOL)animated duration:(NSTimeInterval)duration {
    [self showWithAnimation:animated];
    [self performSelector:@selector(dismissWithAnimation:) withObject:[NSNumber numberWithBool:YES] afterDelay:duration];
}

- (void)dismiss {
    self.isLoading = NO;
    for (CAShapeLayer *shapeLayer in self.shapeLayers) {
        [shapeLayer removeAllAnimations];
    }
    [self removeFromSuperview];
}

- (void)dismissWithAnimation:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.5f
                         animations:^{
                             self.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             [self dismiss];
                         }];
    } else {
        [self dismiss];
    }
}

- (void)setLoadingViewBackgroundViewColor:(UIColor *)color {
    self.backgroundColor = color;
}

- (void)setLoadingViewHudViewColor:(UIColor *)color {
    self.hudView.backgroundColor = color;
}

- (NSArray *)shapeLayers {
    if (!_shapeLayers) {
        _shapeLayers = [self createColorShapes:_ringsColor];
        for (CAShapeLayer *layer in _shapeLayers) {
            [_hudView.layer addSublayer:layer];
        }
    }
    return _shapeLayers;
}

#pragma mark - Drag animation

- (void)dragAnimationWithFloat:(CGFloat)dragFloat {
    NSAssert(dragFloat < 1 || dragFloat > 0, @"取值在0~1之间");
    
    CGFloat toValue = dragFloat * (2 *self.diameter);
    CAShapeLayer *fristLayer = self.shapeLayers.firstObject;
    CAShapeLayer *lastLayer = self.shapeLayers.lastObject;
    
    [self addDragAnimationWithShaplayer:fristLayer toValue:-toValue];
    [self addDragAnimationWithShaplayer:lastLayer toValue:toValue];
}

//扩展 动画
- (void)addDragAnimationWithShaplayer:(CAShapeLayer *)shaplayer toValue:(CGFloat)value {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.fromValue = 0;
    animation.toValue = @(value);
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [shaplayer addAnimation:animation forKey:nil];
}

//扩展 & 闭合 动画
- (void)addRepeatAnimationWithShaplayer:(CAShapeLayer *)shaplayer toValue:(CGFloat)value {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.fromValue = 0;
    animation.toValue = @(value);
    animation.repeatCount = INT_MAX;
    animation.duration = 0.5;
    animation.autoreverses = YES;
    animation.removedOnCompletion = NO;
    [shaplayer addAnimation:animation forKey:nil];
}


@end
