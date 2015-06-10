//
//  XYLXIAlertView.h
//  Echo
//
//  Created by WangZHW on 15/6/9.
//  Copyright (c) 2015年 Static Ga. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    AlertViewTypeLogin = 1,
    AlertViewTypeOther
}AlertViewType;

@interface XYLXIAlertView : UIView

- (instancetype)initWithTitle:(NSString *)title
                  contentText:(NSString *)content
            cancleButtonTitle:(NSString *)cancleTitle
           comfireButtonTitle:(NSString *)comfireTitle
                         type:(AlertViewType)type;
/**取消按钮block*/
@property (nonatomic, copy) dispatch_block_t cancleBlock;
/**确定按钮block*/
@property (nonatomic, copy) dispatch_block_t comfireBlock;
- (void)show;
@end

@interface UIImage (colorful)
+ (UIImage *)imageWithColor:(UIColor *)color;
@end