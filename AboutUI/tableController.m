//
//  tableController.m
//  AboutUI
//
//  Created by WangZHW on 15/4/23.
//  Copyright (c) 2015年 RobuSoft. All rights reserved.
//

#import "tableController.h"
@interface tableController ()
@property (nonatomic,strong)NSArray *UIName;
@property (nonatomic,copy)NSString  *vctitle;
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

@end
