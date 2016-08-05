//
//  CustomCircleChartView.m
//  CircleChart_demo
//
//  Created by TOMO on 16/8/5.
//  Copyright © 2016年 TOMO. All rights reserved.
//

#import "CustomCircleChartView.h"
#import "CommonLabel.h"
@interface CustomCircleChartView ()

//开始的角度
@property(assign,nonatomic)CGFloat startAngle;
//开始的比例
@property(assign,nonatomic)NSInteger startRate;

// CAShapeLayer
@property(strong,nonatomic)CAShapeLayer *shapeLayer;

// CADisplayLink 定时器
@property(strong,nonatomic)CADisplayLink *displayLink;

// UIBezierPath 贝塞尔曲线
@property(strong,nonatomic)UIBezierPath *bezierPath;
//圆形中的label
@property(strong,nonatomic)UILabel *rateLabel;
//中间显示的比例
@property (assign,nonatomic)NSInteger rate;


//是否开始画图
@property(assign,nonatomic)BOOL isStart;

@end
                            /**UIBezierPath*/
/**
   简单的使用UIBezierPath绘制：http://my.oschina.net/lanrenbar/blog/389379
    UIBezierPath精讲： http://www.jianshu.com/p/734b34e82135
 *  使用UIBezierPath类可以创建基于矢量的路径，这个类在UIKit中。此类是Core Graphics框架关于path的一个封装。使用此类可以定义简单的形状，如椭圆或者矩形，或者有多个直线和曲线段组成的形状。
 
 1.Bezier Path 基础
 UIBezierPath对象是CGPathRef数据类型的封装。path如果是基于矢量形状的，都用直线和曲线段去创建。我们使用直线段去创建矩形和多边形，使用曲线段去创建弧（arc），圆或者其他复杂的曲线形状。每一段都包括一个或者多个点，绘图命令定义如何去诠释这些点。每一个直线段或者曲线段的结束的地方是下一个的开始的地方。每一个连接的直线或者曲线段的集合成为subpath。一个UIBezierPath对象定义一个完整的路径包括一个或者多个subpaths。
 
 创建和使用一个path对象的过程是分开的。创建path是第一步，包含一下步骤：
 （1）创建一个Bezier path对象。
 （2）使用方法moveToPoint:去设置初始线段的起点。
 （3）添加line或者curve去定义一个或者多个subpaths。
 （4）改变UIBezierPath对象跟绘图相关的属性。
 */


                            /**CADisplayLink*/
/**
 *  CADisplayLink是一个能让我们以和屏幕刷新率同步的频率将特定的内容画到屏幕上的定时器类。 CADisplayLink以特定模式注册到runloop后， 每当屏幕显示内容刷新结束的时候，runloop就会向 CADisplayLink指定的target发送一次指定的selector消息，  CADisplayLink类对应的selector就会被调用一次。
 * iOS设备的屏幕刷新频率是固定的，CADisplayLink在正常情况下会在每次刷新结束都被调用，精确度相当高。
    NSTimer以指定的模式注册到runloop后，每当设定的周期时间到达后，runloop会向指定的target发送一次指定的selector消息。
 */

                            /**CAShapeLayer*/
/**
 *普通CALayer在被初始化时是需要给一个frame值的,这个frame值一般都与给定view的bounds值一致,它本身是有形状的,而且是矩形.
 *  CAShapeLayer在初始化时也需要给一个frame值,但是,它本身没有形状,它的形状来源于你给定的一个path,然后它去取CGPath值,它与CALayer有着很大的区别
 CAShapeLayer有着几点很重要:
 
 1. 它依附于一个给定的path,必须给与path,而且,即使path不完整也会自动首尾相接
 
 2. strokeStart以及strokeEnd代表着在这个path中所占用的百分比
 
 3. CAShapeLayer动画仅仅限于沿着边缘的动画效果,它实现不了填充效果
 */

@implementation CustomCircleChartView

static const NSInteger LINEWIDTH = 5;


- (instancetype)initWithFrame:(CGRect)frame startAnimation:(BOOL)isStart andRate:(NSInteger)rate
{
    self = [super initWithFrame: frame];
    if (self) {
        _startAngle = -90;
        _startRate  = 0;
        _rate       = rate;
        _isStart    = isStart;
        //initialize Bezier.
        _bezierPath = [UIBezierPath bezierPath];
        
        //初始化label
        [self initializeLabel];
        
        //先画一个底层圆
        [self drawBottomCircle];
        
        [self configShapeLayer];
        
        [self configDisplayLink];
    }
    return self;
}

- (void)initializeLabel
{
    
    
    CGFloat labelX              = 10.f;
    CGFloat rateLabelHeight     = 40.f;
    CGFloat contentLabelHeight  = 20.f;
    
    CGFloat rateLabelWidth      = self.frame.size.height - 2 * labelX - 10;
    CGFloat rateLabelY          = self.frame.size.height * 0.5 ;
    
    // contentLabel
    CGFloat contentLabelWidth   = self.frame.size.height - 2 * labelX - 10;
    
    CGFloat contentLabelY       = self.frame.size.height * 0.5 - contentLabelHeight;
    
    CGRect contentLabelFrame    = CGRectMake(labelX, contentLabelY, contentLabelWidth, contentLabelHeight);
    
    UILabel *contentLabel       = [CommonLabel commonlabelWithFrame:contentLabelFrame labelText:@"目前的显示" textColor:[UIColor lightGrayColor] labelBGColor:nil fontSize:15 textAlignment:NSTextAlignmentCenter adjustsFontSize:YES];
   
    
    //rateLabel
    CGRect rateLabelFrame       = CGRectMake(labelX, rateLabelY, rateLabelWidth, rateLabelHeight);
    
    UILabel *rateLabel          = [CommonLabel commonlabelWithFrame:rateLabelFrame labelText:@"0%" textColor:[UIColor purpleColor] labelBGColor:nil fontSize:30 textAlignment:NSTextAlignmentCenter adjustsFontSize:YES];
    _rateLabel                  = rateLabel;
   
    
    [self addSubview:contentLabel];
    [self addSubview:rateLabel];
}
#pragma mark --draw circle--
- (void)drawBottomCircle
{
    CGFloat arcCenterX = self.frame.size.width * 0.5;
    CGFloat arcCenterY = self.frame.size.height * 0.5;
    CGFloat radius     = self.frame.size.width * 0.5;
    //UIBezierPath 贝塞尔曲线
    UIBezierPath *bezierPath    = [UIBezierPath bezierPathWithArcCenter:CGPointMake(arcCenterX, arcCenterY) radius:radius startAngle:0 endAngle:360 clockwise:YES];
    /**
     *  CAShapeLayer 是 CALayer 的子类，但是比 CALayer 更灵活，可以画出各种图形
     */
    CAShapeLayer *shapeLayer    = [CAShapeLayer layer];
    shapeLayer.fillColor        = [UIColor clearColor].CGColor;//闭环填充的颜色
    shapeLayer.strokeColor      = [UIColor lightGrayColor].CGColor;//边缘线的颜色
    shapeLayer.lineWidth        = LINEWIDTH;//线条宽度
    shapeLayer.lineCap          = kCALineCapSquare;//边缘线的类型
    shapeLayer.path             = bezierPath.CGPath;//从贝塞尔曲线获取到形状
    
    [self.layer addSublayer:shapeLayer];
}

/**
 *  使用CAShapeLayer与UIBezierPath可以实现不在view的drawRect方法中就画出一些想要的图形
 
 步骤：
 1、新建UIBezierPath对象bezierPath
 2、新建CAShapeLayer对象caShapeLayer
 3、将bezierPath的CGPath赋值给caShapeLayer的path，即caShapeLayer.path = bezierPath.CGPath
 4、把caShapeLayer添加到某个显示该图形的layer中
 */
#pragma mark --配置CAShapeLayer--
- (void)configShapeLayer
{
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.strokeColor = [UIColor purpleColor].CGColor;
    _shapeLayer.fillColor  = [UIColor clearColor].CGColor;
    _shapeLayer.lineWidth  = LINEWIDTH;
    
    [self.layer addSublayer:_shapeLayer];
}
#pragma mark --配置CADisplayLink--
//定时器
- (void)configDisplayLink
{
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawCircle)];
    
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    //默认暂停
    _displayLink.paused = !_isStart;
    
}

- (void)drawCircle
{
    //如果开始的比例大于要画出的比例，则重新初始化 贝赛尔曲线
    if (_startRate >= _rate) {
        _bezierPath = [UIBezierPath bezierPath];
        _displayLink.paused = YES;
        return;
    }
    //否则
    _startRate ++;
    
    _rateLabel.text = [NSString stringWithFormat:@"%li%%",_startRate];
    
    CGFloat arcCenterX = self.frame.size.width * 0.5;
    CGFloat arcCenterY = self.frame.size.height * 0.5;
    CGFloat radius     = self.frame.size.width * 0.5;
    
    [_bezierPath addArcWithCenter:CGPointMake(arcCenterX, arcCenterY) radius:radius startAngle:(M_PI / 180.0) * _startAngle endAngle:(M_PI / 180.0) * (_startAngle + 3.6) clockwise:YES];
    
    _shapeLayer.path   = _bezierPath.CGPath;
    _startAngle += 3.6;
}

- (void)setRate:(NSInteger)rate
{
    if (rate <= 0) {
        rate  = 0;
    }else if (rate >= 100){
        rate  = 100;
    }else{
        _rate = rate;
    }
}


+ (UIView *)CustomCircleViewWithFrame:(CGRect)frame startAnimation:(BOOL)isStart andRate:(NSInteger)rate
{
    return [[CustomCircleChartView alloc]initWithFrame:frame startAnimation:isStart andRate:rate];
}

@end





























