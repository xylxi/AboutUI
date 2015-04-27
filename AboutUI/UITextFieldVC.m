//
//  UITextFieldVC.m
//  AboutUI
//
//  Created by WangZHW on 15/4/23.
//  Copyright (c) 2015年 RobuSoft. All rights reserved.
//

#import "UITextFieldVC.h"
#import "CustomTextField.h"
@interface UITextFieldVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet CustomTextField *textFiel;

@end

@implementation UITextFieldVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.textFiel.delegate = self;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSString *zhengze=@"[A-Za-z\u4E00-\u9FA5]+$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",zhengze];
    if ([pre evaluateWithObject:textField.text] && textField.text.length < 20) {
        NSLog(@"zhengqu");
    }else{
        NSLog(@"cuo wu");
    }
    return YES;
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
