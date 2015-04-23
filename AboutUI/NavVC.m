//
//  NavVC.m
//  AboutUI
//
//  Created by WangZHW on 15/4/23.
//  Copyright (c) 2015年 RobuSoft. All rights reserved.
//

#import "NavVC.h"

@interface NavVC ()

@end

@implementation NavVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置背景图片
    UIImage *backgroundImageForDefaultBarMetrics = [UIImage imageNamed:@"NavigationBarDefault"];
    backgroundImageForDefaultBarMetrics = [backgroundImageForDefaultBarMetrics resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, backgroundImageForDefaultBarMetrics.size.height - 1, backgroundImageForDefaultBarMetrics.size.width - 1)];
    id navigationBarAppearance = self.navigationBar;
    [navigationBarAppearance setBackgroundImage:backgroundImageForDefaultBarMetrics forBarMetrics:UIBarMetricsDefault];
    // 去掉导航栏边界的黑线
    self.navigationBar.shadowImage       = [[UIImage alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
