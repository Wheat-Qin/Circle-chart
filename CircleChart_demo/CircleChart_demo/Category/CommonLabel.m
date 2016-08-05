//
//  CommonLabel.m
//  App_Tracker
//
//  Created by TOMO on 16/7/27.
//  Copyright © 2016年 TOMO. All rights reserved.
//

#import "CommonLabel.h"

@implementation CommonLabel
{
    NSString *_text ;
    UIColor *_textColor , *_labelBGColor ;
    CGFloat _fontSize ;
    NSTextAlignment _textAlignment ;
    BOOL _isAdjust ;
}


-(instancetype)initWithFrame:(CGRect)frame labelText:(NSString *)text textColor:(UIColor *)textColor labelBGColor:(UIColor *)labelBGColor fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)textAlignment adjustsFontSize:(BOOL)isAdjust
{
    self = [super initWithFrame:frame];
    if (self) {
        _text           = text ;
        _textColor      = textColor;
        _labelBGColor   = labelBGColor ? labelBGColor : [UIColor whiteColor];
        _fontSize       = fontSize;
        _textAlignment  = textAlignment;
        _isAdjust       = isAdjust;
        [self updateLabelContent];
    }
    return self;
}

- (void)updateLabelContent
{
    self.text                       =   _text;
    self.textColor                  =   _textColor;
    self.backgroundColor            =   _labelBGColor;
    self.font                       =   [UIFont systemFontOfSize:_fontSize];
    self.textAlignment              =   _textAlignment;
    self.adjustsFontSizeToFitWidth  =   _isAdjust;
    
}

+ (UILabel *)commonlabelWithFrame:(CGRect)frame labelText:(NSString *)text textColor:(UIColor *)textColor labelBGColor:(UIColor *)labelBGColor fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)textAlignment adjustsFontSize:(BOOL)isAdjust
{
    return [[CommonLabel alloc]initWithFrame:frame labelText:text textColor:textColor labelBGColor:labelBGColor fontSize:fontSize textAlignment:textAlignment adjustsFontSize:isAdjust];
}

@end
