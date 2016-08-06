# Circle-chart

- (Enlish) This is a circle chart. It use three class of CAShapeLayer、UIBezierPath and CADisplayLink .

-- 
- (Chiness) 这是一个圆形图，也叫饼图。使用到 iOS中的CAShapeLayer、UIBezierPath(贝塞尔曲线)、CADisplayLink(定时器)类

---
- Code:

####pragma mark --配置CAShapeLayer--

    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.strokeColor = [UIColor purpleColor].CGColor;
    _shapeLayer.fillColor  = [UIColor clearColor].CGColor;
    _shapeLayer.lineWidth  = LINEWIDTH;
    
    [self.layer addSublayer:_shapeLayer];

#### pragma mark --配置CADisplayLink--

    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawCircle)];
    
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    //默认暂停
    _displayLink.paused = !_isStart;
    



<p> 

####pragma mark --画圆--

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

