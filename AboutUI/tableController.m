//
//  tableController.m
//  AboutUI
//
//  Created by WangZHW on 15/4/23.
//  Copyright (c) 2015年 RobuSoft. All rights reserved.
//

#import "tableController.h"
@interface tableController ()<UIScrollViewDelegate>
@property (nonatomic,strong)NSArray *UIName;
@property (nonatomic,copy)NSString  *vctitle;
@property (nonatomic,assign)BOOL     isHide;
@end

@implementation tableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _UIName = [NSArray arrayWithObjects:@"UITextFieldVC",@"滑动手势锁屏",@"照片选择器", nil];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.UIName.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text   = self.UIName[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.vctitle = self.UIName[indexPath.row];
    [self performSegueWithIdentifier:self.UIName[indexPath.row] sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *vc = segue.destinationViewController;
    vc.title = self.vctitle;
}

#pragma mark - 刷新的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.isHide == NO) {
        NSLog(@"before%@",NSStringFromCGRect(self.navigationController.navigationBar.frame));
        [UIView animateWithDuration:0.34 animations:^{
            self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, -64);
            NSLog(@"%f",self.tableView.contentInset.top);
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } completion:^(BOOL finished) {
            NSLog(@"after%@",NSStringFromCGRect(self.navigationController.navigationBar.frame));
        }];
    }else{
        NSLog(@"before%@",NSStringFromCGRect(self.navigationController.navigationBar.frame));
        [UIView animateWithDuration:0.34 animations:^{
            self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, 0);
            NSLog(@"%f",self.tableView.contentInset.top);
            self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        } completion:^(BOOL finished) {
            NSLog(@"after%@",NSStringFromCGRect(self.navigationController.navigationBar.frame));
        }];
    }
    self.isHide = !self.isHide;
}


@end
