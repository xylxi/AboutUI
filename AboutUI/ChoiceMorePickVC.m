//
//  ChoiceMorePickVC.m
//  AboutUI
//
//  Created by WangZHW on 15/4/27.
//  Copyright (c) 2015年 RobuSoft. All rights reserved.
//

#import "ChoiceMorePickVC.h"
#import "XYLXIPickerVC.h"
#import "XYLXIPickerNavVC.h"
@interface ChoiceMorePickVC ()

@end

@implementation ChoiceMorePickVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)choiceBtn:(UIButton *)sender {
    XYLXIPickerVC *picVC = [XYLXIPickerVC new];
    XYLXIPickerNavVC *nav = [[XYLXIPickerNavVC alloc]initWithRootViewController:picVC];
    picVC.parent = nav;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
