//
//  XYLXIAsset.h
//  AboutUI
//
//  Created by WangZHW on 15/4/27.
//  Copyright (c) 2015年 RobuSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface XYLXIAsset : UIView{
    UIImageView *overlayView;
    BOOL selected;
}

@property (strong , nonatomic)ALAsset *asset;
@property (assign , nonatomic) id parent;

-(id)initWithAsset:(ALAsset*)asset;
-(BOOL)selected;
-(void)toggleSelection;
@end
