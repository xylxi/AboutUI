//
//  XYLXIAssetCell.m
//  AboutUI
//
//  Created by WangZHW on 15/4/27.
//  Copyright (c) 2015年 RobuSoft. All rights reserved.
//

#import "XYLXIAssetCell.h"
#import "XYLXIAsset.h"
@implementation XYLXIAssetCell

-(instancetype)initWithAssets:(NSArray*)assets reuseIdentifier:(NSString*)identifier{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier])
    {
        self.rowAssets = assets;
    }
    return self;
}

-(void)setAssets:(NSArray*)assets{
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[XYLXIAsset class]]) {
            [view removeFromSuperview];
        }
    }
    self.rowAssets = assets;
}

#define topMargin 5

-(void)layoutSubviews {
    
    CGFloat h = self.bounds.size.height - topMargin;
    CGFloat margin =( self.bounds.size.width - 4 * h ) / 5.0;
    CGRect frame = CGRectMake(margin,topMargin, h, h);
    for(XYLXIAsset *xylxiAsset in self.rowAssets) {
        xylxiAsset.frame = frame;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:xylxiAsset action:@selector(toggleSelection)];
        [xylxiAsset addGestureRecognizer:tap];
        [self addSubview:xylxiAsset];
        frame.origin.x = frame.origin.x + frame.size.width + margin;
    }
}
@end
