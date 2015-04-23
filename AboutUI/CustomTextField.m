//
//  CustomTextField.m
//  AboutUI
//
//  Created by WangZHW on 15/4/23.
//  Copyright (c) 2015年 RobuSoft. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (void)awakeFromNib{
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2, 0)];
    self.leftViewMode = UITextFieldViewModeAlways;
}










// 改变占位符的颜色
- (void) drawPlaceholderInRect:(CGRect)rect
{
    NSDictionary *att = [NSDictionary dictionaryWithObjectsAndKeys:
                         [UIColor orangeColor],NSForegroundColorAttributeName,
                         self.font,NSFontAttributeName,
                         nil];
    [self.placeholder drawInRect:rect withAttributes:att];
}

-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(5,0, bounds.size.width - 20, self.font.xHeight * 2);
    return inset;
}

@end
