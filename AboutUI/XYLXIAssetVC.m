//
//  XYLXIAssetVC.m
//  AboutUI
//
//  Created by WangZHW on 15/4/27.
//  Copyright (c) 2015年 RobuSoft. All rights reserved.
//

#import "XYLXIAssetVC.h"
#import "XYLXIAsset.h"
#import "XYLXIPickerVC.h"
#import "XYLXIAssetCell.h"
@interface XYLXIAssetVC ()

@end

@implementation XYLXIAssetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setAllowsSelection:NO];
    self.xylxiAssets = [NSMutableArray new];
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    [self.navigationItem setRightBarButtonItem:doneButtonItem];
    self.title = @"Loading...";
    
    [self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
}

- (void)preparePhotos{
    [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result == nil) {
            return ;
        }

        XYLXIAsset *xylxiAsset = [[XYLXIAsset alloc]initWithAsset:result];
        xylxiAsset.parent      = self;
        [self.xylxiAssets addObject:xylxiAsset];
    }];
    NSLog(@"nsthread = %@",[NSThread currentThread]);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"nsthread = %@",[NSThread currentThread]);
        [self.tableView reloadData];
        self.title = @"Pick Photos";
    });
}

- (void) doneAction:(id)sender {
    NSMutableArray *selectedAssetsImages = [[NSMutableArray alloc] init];
    for(XYLXIAsset *xylxiAsset in self.xylxiAssets)
    {
        if([xylxiAsset selected]) {
            [selectedAssetsImages addObject:[xylxiAsset asset]];
        }
    }
    [(XYLXIPickerVC *)self.parent selectedAssets:selectedAssetsImages];
}
- (NSArray*)assetsForIndexPath:(NSIndexPath*)indexPath {
    
    NSInteger index = (indexPath.row*4);
    NSInteger maxIndex = (indexPath.row*4+3);
    
    // NSLog(@"Getting assets for %d to %d with array count %d", index, maxIndex, [assets count]);
    if(maxIndex < [self.xylxiAssets count]) {
        return [NSArray arrayWithObjects:[self.xylxiAssets objectAtIndex:index],
                [self.xylxiAssets objectAtIndex:index+1],
                [self.xylxiAssets objectAtIndex:index+2],
                [self.xylxiAssets objectAtIndex:index+3],
                nil];
    }
    else if(maxIndex-1 < [self.xylxiAssets count]) {
        
        return [NSArray arrayWithObjects:[self.xylxiAssets objectAtIndex:index],
                [self.xylxiAssets objectAtIndex:index+1],
                [self.xylxiAssets objectAtIndex:index+2],
                nil];
    }
    else if(maxIndex-2 < [self.xylxiAssets count]) {
        
        return [NSArray arrayWithObjects:[self.xylxiAssets objectAtIndex:index],
                [self.xylxiAssets objectAtIndex:index+1],
                nil];
    }
    else if(maxIndex-3 < [self.xylxiAssets count]) {
        return [NSArray arrayWithObject:[self.xylxiAssets objectAtIndex:index]];
    }
    
    return nil;
}
#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ([self.assetGroup numberOfAssets] + 3) / 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80 * [self ratio];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    XYLXIAssetCell *cell = (XYLXIAssetCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[XYLXIAssetCell alloc] initWithAssets:[self assetsForIndexPath:indexPath] reuseIdentifier:CellIdentifier];
    }else{
        [cell setAssets:[self assetsForIndexPath:indexPath]];
    }
    return cell;
}
- (int)totalSelectedAssets {
    
    int count = 0;
    
    for(XYLXIAsset *asset in self.xylxiAssets)
    {
        if([asset selected])
        {
            count++;
        }
    }
    
    return count;
}

- (CGFloat)ratio{
    return [UIScreen mainScreen].bounds.size.width / 320.0;
}
@end
