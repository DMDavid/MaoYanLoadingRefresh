//
//  LoadingView.h
//  MaoYanLoadingRefresh
//
//  Created by APPLE on 17/2/8.
//  Copyright © 2017年 David. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LoadingAnimationStyle) {
    LoadingAnimationStyleDefault, //default
    LoadingAnimationStyleReset,   //animation with reset
};

@interface LoadingView : UIView

@property (nonatomic, assign) CGFloat diameter;//the radius of circular
@property (nonatomic, assign) BOOL isLoading;


/**
 *  Screen Frame bounds
 */
+ (instancetype)standardView;

/**
 *  According to superView
 */
+ (instancetype)standardViewShowOnView:(UIView *)aView;
- (instancetype)initWithView:(UIView *)view;
- (void)show;
- (void)dismiss;
- (void)startAnimation;
- (void)removeAniamtions;

/**
 *  animation for backgourd
 */
- (void)showWithAnimation:(BOOL)animated;
- (void)showWithAnimation:(BOOL)animated duration:(NSTimeInterval)duration;
- (void)dismissWithAnimation:(BOOL)animated;

- (void)setLoadingViewBackgroundViewColor:(UIColor *)color;//background Color
- (void)setLoadingViewHudViewColor:(UIColor *)color;//hud Color

/**
 *  Drag anamation
 */
- (void)dragAnimationWithFloat:(CGFloat)dragFloat;

//- (void)setRefreshStatus:(RefreshStatus)status;

@end
