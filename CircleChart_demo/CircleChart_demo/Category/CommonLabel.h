//
//  CommonLabel.h
//  App_Tracker
//
//  Created by TOMO on 16/7/27.
//  Copyright © 2016年 TOMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonLabel : UILabel

-(instancetype)initWithFrame:(CGRect)frame labelText:(NSString *)text textColor:(UIColor *)textColor labelBGColor:(UIColor *)labelBGColor fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)textAlignment adjustsFontSize:(BOOL)isAdjust;

+(UILabel *)commonlabelWithFrame:(CGRect)frame labelText:(NSString *)text textColor:(UIColor *)textColor labelBGColor:(UIColor *)labelBGColor fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)textAlignment adjustsFontSize:(BOOL)isAdjust;

@end
