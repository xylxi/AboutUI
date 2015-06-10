//
//  XYLXIAlertView.m
//  Echo
//
//  Created by WangZHW on 15/6/9.
//  Copyright (c) 2015年 Static Ga. All rights reserved.
//

#import "XYLXIAlertView.h"

#define kAlertWidth  280.0f
#define kAlertHeight 220.0f

@interface XYLXIAlertView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
@property (weak, nonatomic) IBOutlet UIButton *comfireButton;
@property (nonatomic, strong) UIView *backImageView;
@property (weak, nonatomic) IBOutlet UIButton *hintButton;

@end
/**防止多个展示*/
static int count = 0;
@implementation XYLXIAlertView

- (void)awakeFromNib{
    self.layer.cornerRadius = 10;
    _cancleButton.layer.cornerRadius  = 5;
    _comfireButton.layer.cornerRadius = 5;
    _cancleButton.clipsToBounds       = YES;
    _comfireButton.clipsToBounds      = YES;
}

- (instancetype)initWithTitle:(NSString *)title
                  contentText:(NSString *)content
            cancleButtonTitle:(NSString *)cancleTitle
           comfireButtonTitle:(NSString *)comfireTitle
                         type:(AlertViewType)type{
    self = [[[NSBundle mainBundle] loadNibNamed:@"XYLXIAlertView" owner:self options:nil] lastObject];
    self.titleLabel  .text = title;
    self.contentLabel.text = content;
    [self.cancleButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:252.0/255.0 green:119.0/255.0 blue:71.0/255.0 alpha:1]] forState:UIControlStateNormal];
    [self.cancleButton setTitle:cancleTitle forState:UIControlStateNormal];
    [self.comfireButton setTitle:comfireTitle forState:UIControlStateNormal];
    
    if (type == AlertViewTypeLogin) {
        _hintButton.hidden = YES;
    }else{
        _hintButton.hidden = NO;
    }
    // cancle Method
    [self.cancleButton addTarget:self action:@selector(clickCancleButton) forControlEvents:UIControlEventTouchUpInside];
    // comfire MEthod
    [self.comfireButton addTarget:self action:@selector(clickComfireButton) forControlEvents:UIControlEventTouchUpInside];
    // hint    Method
    [self.hintButton addTarget:self action:@selector(clickHintButton) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

- (UIView *)backImageView{
    if (_backImageView == nil) {
        _backImageView = [[UIView alloc]initWithFrame:[self appRootViewController].view.bounds];
        _backImageView.backgroundColor = [UIColor blackColor];
        _backImageView.alpha = 0.0f;
        _backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _backImageView;
}
- (void)isHideHintButton:(BOOL)hide{
    self.hintButton.hidden = hide;
    if (_hintButton.hidden) {
        _contentLabel.font = [UIFont boldSystemFontOfSize:17];
    }else{
        _contentLabel.font = [UIFont boldSystemFontOfSize:15];
    }
}
- (void)show{
    if (count > 0) {
        return ;
    }
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, - kAlertHeight - 30, kAlertWidth, kAlertHeight);
    [topVC.view addSubview:self];
    count++;
}
- (void)dismissAlert{
    [self removeFromSuperview];
    count--;
}
#pragma mark 按钮方法
- (void)clickCancleButton{
    [self dismissAlert];
    if (self.cancleBlock) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.cancleBlock();
        });
    }
}
- (void)clickComfireButton{
    [self dismissAlert];
    if (self.comfireBlock) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.comfireBlock();
        });
    }
}
- (void)clickHintButton{
    self.hintButton.selected = !self.hintButton.selected;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (self.hintButton.selected) {
        [defaults setValue:@"YES" forKey:@"hintButton"];
    }else{
        [defaults setValue:@"NO" forKey:@"hintButton"];
    }
    [defaults synchronize];
}
#pragma view的方法
- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (nil == newSuperview) {
        return ;
    }
    UIViewController *topVC = [self appRootViewController];
    [topVC.view addSubview:self.backImageView];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - kAlertHeight) * 0.5, kAlertWidth, kAlertHeight);
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.backImageView.alpha = 0.6;
        self.frame = afterFrame;
    } completion:^(BOOL finished) {
        [super willMoveToSuperview:newSuperview];
    }];
}
- (void)removeFromSuperview{
//    UIViewController *topVC = [self appRootViewController];
//    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, CGRectGetHeight(topVC.view.bounds), kAlertWidth, kAlertHeight);
//    self.layer.anchorPoint = CGPointMake(0.0, 0.0);
//    self.center            = CGPointMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, self.frame.origin.y);
    [UIView animateWithDuration:0.0 animations:^{
//        self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI/4);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.backImageView.alpha = 0.0;
            self.alpha               = 0.0;
        }completion:^(BOOL finished) {
            self.backImageView = nil;
            [super removeFromSuperview];
        }];
    }];
}
#pragma mark 获得控制器
- (UIViewController *)appRootViewController{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}
@end

@implementation UIImage(colorful)
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

