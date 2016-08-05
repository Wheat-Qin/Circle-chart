//
//  CustomCircleChartView.h
//  CircleChart_demo
//
//  Created by TOMO on 16/8/5.
//  Copyright © 2016年 TOMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCircleChartView : UIView

- (instancetype)initWithFrame:(CGRect)frame startAnimation:(BOOL)isStart andRate:(NSInteger)rate;

+ (UIView *)CustomCircleViewWithFrame:(CGRect)frame startAnimation:(BOOL)isStart andRate:(NSInteger)rate;


@end
