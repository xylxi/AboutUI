//
//  XYLXIPickerNavVC.h
//  AboutUI
//
//  Created by WangZHW on 15/4/27.
//  Copyright (c) 2015年 RobuSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XYLXIPickerNavVC;
@protocol XYLXIPickerNavVCDelegate <NSObject>
- (void)xylxiPickerNavVC:(XYLXIPickerNavVC *)picker didFinishPickingMediaWithInfo:(NSArray *)info;
- (void)xylxiPickerNavVCDidCancel:(XYLXIPickerNavVC *)picker;
@end

@interface XYLXIPickerNavVC : UINavigationController
/**XYLXIPickerNavVCDelegate*/
@property (assign , nonatomic) id<XYLXIPickerNavVCDelegate> xylxiPickerDelegate;

-(void)selectedAssets:(NSArray*)_assets;
-(void)cancelImagePicker;

@end
