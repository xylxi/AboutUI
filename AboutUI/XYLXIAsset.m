//
//  XYLXIAsset.m
//  AboutUI
//
//  Created by WangZHW on 15/4/27.
//  Copyright (c) 2015年 RobuSoft. All rights reserved.
//

#import "XYLXIAsset.h"


@interface XYLXIAsset (){
    UIImageView *assetImageView;
}
@end
@implementation XYLXIAsset

-(id)initWithAsset:(ALAsset*)asset{
    if (self = [super initWithFrame:CGRectMake(0, 0, 0, 0)]) {
        self.asset = asset;
        assetImageView = [[UIImageView alloc]init];
        [assetImageView setContentMode:UIViewContentModeScaleAspectFill];
        [assetImageView setImage:[UIImage imageWithCGImage:[self.asset thumbnail]]];
        [self addSubview:assetImageView];
        
        overlayView = [[UIImageView alloc]init];
        [overlayView setImage:[UIImage imageNamed:@"Overlay.png"]];
        overlayView.hidden = YES;
        [self addSubview:overlayView];
    }
    return self;
}

-(BOOL)selected{
    return !overlayView.hidden;
}
-(void)setSelected:(BOOL)_selected {
    [overlayView setHidden:!_selected];
}
-(void)toggleSelection {
    overlayView.hidden = !overlayView.hidden;
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    assetImageView.frame = self.bounds;
    overlayView.frame    = self.bounds;
}

@end
