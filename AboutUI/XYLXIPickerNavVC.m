//
//  XYLXIPickerNavVC.m
//  AboutUI
//
//  Created by WangZHW on 15/4/27.
//  Copyright (c) 2015年 RobuSoft. All rights reserved.
//

#import "XYLXIPickerNavVC.h"
#import "XYLXIAsset.h"
@interface XYLXIPickerNavVC ()

@end

@implementation XYLXIPickerNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)cancelImagePicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)selectedAssets:(NSArray*)_assets {
    
    NSMutableArray *returnArray = [NSMutableArray new];
    
    for(ALAsset *asset in _assets) {
        NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
        [workingDictionary setObject:[asset valueForProperty:ALAssetPropertyType] forKey:@"UIImagePickerControllerMediaType"];
        [workingDictionary setObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]] forKey:@"UIImagePickerControllerOriginalImage"];
        [workingDictionary setObject:[[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]] forKey:@"UIImagePickerControllerReferenceURL"];
        [returnArray addObject:workingDictionary];
    }
    if([_xylxiPickerDelegate respondsToSelector:@selector(xylxiPickerNavVC:didFinishPickingMediaWithInfo:)]) {
        [_xylxiPickerDelegate xylxiPickerNavVC:self didFinishPickingMediaWithInfo:[NSArray arrayWithArray:returnArray]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
