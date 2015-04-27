//
//  XYLXIPickerVC.h
//  AboutUI
//
//  Created by WangZHW on 15/4/27.
//  Copyright (c) 2015年 RobuSoft. All rights reserved.
//  展示所有照片组

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface XYLXIPickerVC : UITableViewController{
    NSOperationQueue *queue;
    
    ALAssetsLibrary *library;
}
@property (assign , nonatomic) id parent;
@property (strong , nonatomic)NSMutableArray *assetGroups;

- (void)selectedAssets:(NSArray *)assets;
@end
