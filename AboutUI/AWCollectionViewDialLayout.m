//
//  AWCollectionViewDialLayout.m
//
//
//  Created by Antoine Wette on 30.10.13.
//  Copyright (c) 2013 Antoine Wette. All rights reserved.
//
//  info@antoinewette.com
//  www.antoinewette.com
//

#import "AWCollectionViewDialLayout.h"

@implementation AWCollectionViewDialLayout



- (id)init
{
    if ((self = [super init]) != NULL)
    {
		[self setup];
    }
    return self;
}

-(id)initWithRadius: (CGFloat) radius andAngularSpacing: (CGFloat) spacing andCellSize: (CGSize) cell andAlignment:(WheelAlignmentType)alignment andItemHeight:(CGFloat)height andXOffset: (CGFloat) xOff{
    if ((self = [super init]) != NULL)
    {
        self.dialRadius = radius;//420.0f;
        self.cellSize = cell;//(CGSize){ 220.0f, 80.0f };
        self.itemHeight = height;
        self.AngularSpacing = spacing;//8.0f;
        self.xOffset = xOff;
        self.wheelType = alignment;
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.offset = 0.0f;    
}

// 1.准备所有view的layoutAttribute信息
- (void)prepareLayout
{
    [super prepareLayout];

    self.cellCount = (int)[self.collectionView numberOfItemsInSection:0];
    // 这个self.offset我的了解是，根据比例大概知道cell的样子.例如缩放的大小，旋转的角度，X轴的偏移量
    self.offset = -self.collectionView.contentOffset.y / self.itemHeight;
//    NSLog(@"offset->%f",self.offset);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

// 3.返回在可见区域的view的layoutAttribute信息
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *theLayoutAttributes = [[NSMutableArray alloc] init];
    
    float minY = CGRectGetMinY(rect);
    float maxY = CGRectGetMaxY(rect);
    
    // 可见(collectionView)区域的第一个
    int firstIndex = floorf(minY / self.itemHeight);
    // 可见(collectionView)区域的最后个
    int lastIndex = floorf(maxY / self.itemHeight);
    // 活动的个数?
    int activeIndex = (int)(firstIndex + lastIndex)/2;
    
    // 最多可以看见的个数？
    int maxVisibleOnScreen = 180 / self.AngularSpacing + 2;
    
    int firstItem = fmax(0, activeIndex - (int)(maxVisibleOnScreen/2) );
    int lastItem = fmin( self.cellCount-1 , activeIndex + (int)(maxVisibleOnScreen/2) );

    //float firstItem = fmax(0 , floorf(minY / self.itemHeight) - (90/self.AngularSpacing) );
    //float lastItem = fmin( self.cellCount-1 , floorf(maxY / self.itemHeight) );

    for( int i = firstItem; i <= lastItem; i++ ){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *theAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [theLayoutAttributes addObject:theAttributes];
    }
 
   
    return [theLayoutAttributes copy];
}

// 2.计算contentsize，显然这一步得在prepare之后进行
// 5.
- (CGSize)collectionViewContentSize
{
    const CGSize theSize = {
//        .height = self.collectionView.bounds.size.height,
//        .width  = (self.cellCount - 1) * self.itemHeight + self.collectionView.bounds.size.width,
        .width = self.collectionView.bounds.size.width,
        .height = (self.cellCount-1) * self.itemHeight + self.collectionView.bounds.size.height,
    };
    return(theSize);
}

// 4.
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    double newIndex = (indexPath.item + self.offset);
    
    UICollectionViewLayoutAttributes *theAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    theAttributes.size = self.cellSize;
    // 缩放系数
    float scaleFactor;
    // 偏移量
    float deltaX;
    
    CGAffineTransform translationT;
    CGAffineTransform rotationT = CGAffineTransformMakeRotation(self.AngularSpacing* newIndex *M_PI/180);
    NSLog(@"角度%f",self.AngularSpacing * newIndex * M_PI);
    if(indexPath.item == 3){
//        NSLog(@"angle 3 :%f", self.AngularSpacing* newIndex);

    }
    
    
    // 转动类型
    // CGAffineTransformMakeTranslation 每次都以自身对中心为起点
    if( self.wheelType == WHEELALIGNMENTLEFT){
        scaleFactor = fmax(0.6, 1 - fabs( newIndex *0.25));
        deltaX = self.cellSize.width/2;
        theAttributes.center = CGPointMake(-self.dialRadius + self.xOffset  , self.collectionView.bounds.size.height/2 + self.collectionView.contentOffset.y);
        // 位置偏移量
        translationT =CGAffineTransformMakeTranslation(self.dialRadius + (deltaX*scaleFactor) , 0);
    }else  {
        scaleFactor = fmax(0.4, 1 - fabs( newIndex *0.50));
        deltaX =  self.collectionView.bounds.size.width/2;
        theAttributes.center = CGPointMake(-self.dialRadius + self.xOffset , self.collectionView.bounds.size.height/2 + self.collectionView.contentOffset.y);
        // 位置偏移量
        translationT =CGAffineTransformMakeTranslation(self.dialRadius  + ((1 - scaleFactor) * -30) , 0);
    }
    
    
    CGAffineTransform scaleT = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    theAttributes.alpha = scaleFactor;

    // 根据scaleFactor缩放系数缩放
    theAttributes.transform = CGAffineTransformConcat(scaleT, CGAffineTransformConcat(translationT, rotationT));
    theAttributes.zIndex = indexPath.item;
    
    return(theAttributes);
}



@end
