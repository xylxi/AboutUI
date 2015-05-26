//
//  XYLXIPickerVC.m
//  AboutUI
//
//  Created by WangZHW on 15/4/27.
//  Copyright (c) 2015年 RobuSoft. All rights reserved.
//

#import "XYLXIPickerVC.h"
#import "XYLXIPickerNavVC.h"
#import "XYLXIAssetVC.h"
@interface XYLXIPickerVC ()

@end

@implementation XYLXIPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Loading...";
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self.parent action:@selector(cancelImagePicker)];
    [self.navigationItem setRightBarButtonItem:cancelButton];
    
    self.assetGroups = [NSMutableArray array];
    library          = [[ALAssetsLibrary alloc]init];
    

    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        void (^assetGroupEnumerator)(ALAssetsGroup *,BOOL *) = ^(ALAssetsGroup *group,BOOL *stop)
        {
            if (group == nil) {
                return ;
            }
            [self.assetGroups addObject:group];
            
            // reload albums
            [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
        };
        
        // Group enumeratorFailure block
        void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            
            NSLog(@"A problem occured %@", [error description]);
        };
        
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:assetGroupEnumerator
                             failureBlock:assetGroupEnumberatorFailure];
    });
}

- (void)cancelImagePicker{
    
}
- (void)reloadTableView{
    [self.tableView reloadData];
    self.title = @"Select an Album";
}

-(void)selectedAssets:(NSArray*)_assets {
    [(XYLXIPickerNavVC*)self.parent selectedAssets:_assets];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.assetGroups count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Get count
    ALAssetsGroup *g = (ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row];
    [g setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSInteger gCount = [g numberOfAssets];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",[g valueForProperty:ALAssetsGroupPropertyName], (long)gCount];
    [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row] posterImage]]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XYLXIAssetVC *vc = [XYLXIAssetVC new];
    vc.parent        = self;
    
    // Move me
    vc.assetGroup    = [self.assetGroups objectAtIndex:indexPath.row];
#warning ALAssetsGroup 可以使用setAssetsFilter:(ALAssetsFilter *)filter过滤照片或者视频等。
    [vc.assetGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
