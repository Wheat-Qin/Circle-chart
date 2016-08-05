//
//  ViewController.m
//  CircleChart_demo
//
//  Created by TOMO on 16/8/5.
//  Copyright © 2016年 TOMO. All rights reserved.
//

#import "ViewController.h"
#import "CustomCircleChartView.h"
@interface ViewController ()
{
    CustomCircleChartView *_CircleChartView;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *circleView = [CustomCircleChartView CustomCircleViewWithFrame:CGRectMake((self.view.bounds.size.width - 200 ) * 0.5, 200, 200, 200) startAnimation:YES andRate:70] ;
    //_CircleChartView = circleView;

    [self.view addSubview:circleView];
    
}



@end





















