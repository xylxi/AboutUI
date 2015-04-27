//
//  XYLXIAssetVC.h
//  AboutUI
//
//  Created by WangZHW on 15/4/27.
//  Copyright (c) 2015年 RobuSoft. All rights reserved.
//  展示该组中照片的控制器

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface XYLXIAssetVC : UITableViewController{

    int selectedAssets;
    
    NSOperationQueue *queue;
}

@property (assign , nonatomic) id parent;

@property (strong , nonatomic)ALAssetsGroup *assetGroup;

@property (strong , nonatomic)NSMutableArray *xylxiAssets;

-(int)totalSelectedAssets;
-(void)preparePhotos;

-(void)doneAction:(id)sender;

@end
