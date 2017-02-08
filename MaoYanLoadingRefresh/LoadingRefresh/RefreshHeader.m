//
//  QMRefreshHeader.m
//  QuanMinTV
//
//  Created by fdd on 16/11/28.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import "RefreshHeader.h"


@interface RefreshHeader()

@property (strong, nonatomic) LoadingView *loadingView;
@property (nonatomic, assign) BOOL isBackDrop;//已经拖拽过

@end

@implementation RefreshHeader
- (void)prepare {
    [super prepare];
//    NSMutableArray *images = [NSMutableArray array];
//    for (int i = 1; i <= 25; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"img_top_loading_xl_zhibo%d", i]];
//        if (image) {
//            [images addObject:image];
//        }
//    }
//    self.lastUpdatedTimeLabel.hidden = YES;
//    self.stateLabel.hidden = YES;

//    // 设置普通状态的动画图片
//    [self setImages:images duration:0.75  forState:MJRefreshStateIdle];
//    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    [self setImages:images duration:0.75  forState:MJRefreshStatePulling];
//    // 设置正在刷新状态的动画图片
//    [self setImages:images duration:0.75  forState:MJRefreshStateRefreshing];
    
    
    // 设置控件的高度
    self.mj_h = 50;
    
    // loading
    [self addSubview:self.loadingView];
    [self.loadingView show];
    
    [self layoutSubviews];
}

- (LoadingView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [LoadingView standardView];
    }
    return _loadingView;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.loadingView.center = CGPointMake(self.mj_w * 0.5, self.mj_h * 0.5);
}


#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
//            [self.loadingView removeAniamtions];
//            [self.loadingView show];
            self.isBackDrop = NO;
            
            break;
        case MJRefreshStatePulling:
//            [self.loadingView show];
            
            
            break;
        case MJRefreshStateRefreshing:
            self.isBackDrop = YES;
            
            [self.loadingView startAnimation];
            
            break;
            
        default:
            break;
    }
}


#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    if (self.isBackDrop) {
        return;
    }
    
    if (pullingPercent == 0) {
        [self.loadingView removeAniamtions];
        return;
    }
    
    if (pullingPercent > 0) {
        if (pullingPercent > 1.0) {
            pullingPercent = 1.0;
        }
        [self.loadingView dragAnimationWithFloat:pullingPercent];
    }
    
    NSLog(@"pullingPercent --- %f", pullingPercent);
}

@end
