//
//  XYLXIAssetCell.h
//  AboutUI
//
//  Created by WangZHW on 15/4/27.
//  Copyright (c) 2015年 RobuSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYLXIAssetCell : UITableViewCell

-(instancetype)initWithAssets:(NSArray*)assets reuseIdentifier:(NSString*)identifier;
-(void)setAssets:(NSArray*)assets;

@property (nonatomic,retain) NSArray *rowAssets;

@end
