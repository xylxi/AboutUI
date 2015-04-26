//
//  YLSwipeLockView.m
//  YLSwipeLockViewDemo
//
//  Created by 肖 玉龙 on 15/2/12.
//  Copyright (c) 2015年 Yulong Xiao. All rights reserved.
//

#import "YLSwipeLockView.h"
#import "YLSwipeLockNodeView.h"
@interface YLSwipeLockView()
@property (nonatomic, strong) NSMutableArray *nodeArray;
@property (nonatomic, strong) NSMutableArray *selectedNodeArray;
@property (nonatomic, strong) CAShapeLayer *polygonalLineLayer;
@property (nonatomic, strong) UIBezierPath *polygonalLinePath;
@property (nonatomic, strong) NSMutableArray *pointArray;

@property (nonatomic) YLSwipeLockViewState viewState;
@end

@implementation YLSwipeLockView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 这个不知道是什么
        [self.layer addSublayer:self.polygonalLineLayer];
        
        _nodeArray = [NSMutableArray arrayWithCapacity:9];
        // 这是那9个按钮
        for (int i = 0; i < 9; ++i) {
            YLSwipeLockNodeView *nodeView = [YLSwipeLockNodeView new];
            [_nodeArray addObject:nodeView];
            nodeView.tag = i;
            [self addSubview:nodeView];
        }
        //放置选择的按钮
        _selectedNodeArray = [NSMutableArray arrayWithCapacity:9];
        //
        _pointArray = [NSMutableArray array];
        // 滑动手势
        UIPanGestureRecognizer *panRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:panRec];
        // 设置按钮状态
        self.viewState = YLSwipeLockNodeViewStatusNormal;
        // 设置初始状态
        [self cleanNodes];
        
    }
    return self;
}

-(void)pan:(UIPanGestureRecognizer *)rec
{
    if  (rec.state == UIGestureRecognizerStateBegan){
        self.viewState = YLSwipeLockNodeViewStatusNormal;
    }
    CGPoint touchPoint = [rec locationInView:self];
    NSLog(@"touchPoint = %@",NSStringFromCGPoint(touchPoint));
    // 根据point获得
    NSInteger index = [self indexForNodeAtPoint:touchPoint];
    if (index >= 0) {
        YLSwipeLockNodeView *node = self.nodeArray[index];
        if (![self addSelectedNode:node]) {
            // 如果按钮已经添加过了。。
            [self moveLineWithFingerPosition:touchPoint];
        }
    }else{
        // 如果滑动没有经过按钮，则规划路径到滑动的点
        [self moveLineWithFingerPosition:touchPoint];
    }
    if (rec.state == UIGestureRecognizerStateEnded) {
        [self removeLastFingerPosition];
        if([self.delegate respondsToSelector:@selector(swipeView:didEndSwipeWithPassword:)]){
            NSMutableString *password = [NSMutableString new];
            for(YLSwipeLockNodeView *nodeView in self.selectedNodeArray){
                NSString *index = [@(nodeView.tag) stringValue];
                [password appendString:index];
            }
            self.viewState = [self.delegate swipeView:self didEndSwipeWithPassword:password];
        }
        else{
            self.viewState = YLSwipeLockViewStateSelected;
        }
    }
    
}

-(BOOL)addSelectedNode:(YLSwipeLockNodeView *)nodeView
{
    if (![self.selectedNodeArray containsObject:nodeView]) {
        nodeView.nodeViewStatus = YLSwipeLockNodeViewStatusSelected;
        [self.selectedNodeArray addObject:nodeView];
        [self addLineToNode:nodeView];
        return YES;
    }else{
        return NO;
    }
    
}

/**
 *  添加直线到哪个按钮
 *  @param nodeView 到那个按钮
 */
-(void)addLineToNode:(YLSwipeLockNodeView *)nodeView
{
    // 如果选中的按钮只有一个
    if(self.selectedNodeArray.count == 1){
        //path move to start point
        CGPoint startPoint = nodeView.center;
        [self.polygonalLinePath moveToPoint:startPoint];
        [self.pointArray addObject:[NSValue valueWithCGPoint:startPoint]];
        self.polygonalLineLayer.path = self.polygonalLinePath.CGPath;
    }else{
        //path add line to point
        //removeLastObject肯定是一个不是选中的按钮的位置，而是touchPoint
        [self.pointArray removeLastObject];
        CGPoint middlePoint = nodeView.center;
        [self.pointArray addObject:[NSValue valueWithCGPoint:middlePoint]];
        [self.polygonalLinePath removeAllPoints];
        // 规划路径
        CGPoint startPoint = [self.pointArray[0] CGPointValue];
        [self.polygonalLinePath moveToPoint:startPoint];
        for (int i = 1; i < self.pointArray.count; ++i) {
            CGPoint middlePoint = [self.pointArray[i] CGPointValue];
            [self.polygonalLinePath addLineToPoint:middlePoint];
        }
        self.polygonalLineLayer.path = self.polygonalLinePath.CGPath;
    }

}

/**
 *  该方法是设置线条 点为选中的按钮的中心点 ＋ 最后滑动到的点
 *  @param touchPoint 最后滑动到的点
 */
-(void)moveLineWithFingerPosition:(CGPoint)touchPoint
{
    if (self.pointArray.count > 0) {
        if (self.pointArray.count > self.selectedNodeArray.count) {
            [self.pointArray removeLastObject];
        }
        // 添加滑动的最后位置
        // 这时候self.pointArray有选中的按钮位置 + 最后的touchPoint
        [self.pointArray addObject:[NSValue valueWithCGPoint:touchPoint]];
        // UIBezierPath路径去除所有点
        [self.polygonalLinePath removeAllPoints];
        // 设置新的起点
        CGPoint startPoint = [self.pointArray[0] CGPointValue];
        [self.polygonalLinePath moveToPoint:startPoint];
        // 重新设置路线
        for (int i = 1; i < self.pointArray.count; ++i) {
            CGPoint middlePoint = [self.pointArray[i] CGPointValue];
            [self.polygonalLinePath addLineToPoint:middlePoint];
        }
        self.polygonalLineLayer.path = self.polygonalLinePath.CGPath;
        
    }
}

-(void)removeLastFingerPosition
{
    if (self.pointArray.count > 0) {
        if (self.pointArray.count > self.selectedNodeArray.count) {
            [self.pointArray removeLastObject];
        }
        [self.polygonalLinePath removeAllPoints];
        CGPoint startPoint = [self.pointArray[0] CGPointValue];
        [self.polygonalLinePath moveToPoint:startPoint];
        
        for (int i = 1; i < self.pointArray.count; ++i) {
            CGPoint middlePoint = [self.pointArray[i] CGPointValue];
            [self.polygonalLinePath addLineToPoint:middlePoint];
        }
        self.polygonalLineLayer.path = self.polygonalLinePath.CGPath;
        
    }
}

-(void)layoutSubviews{
    
    self.polygonalLineLayer.frame = self.bounds;
    CAShapeLayer *maskLayer = [CAShapeLayer new];
    maskLayer.frame = self.bounds;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    maskLayer.lineWidth = 1.0f;
    maskLayer.strokeColor = [UIColor blackColor].CGColor;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    //TODO: here should be more decent
    for (int i = 0; i < self.nodeArray.count; ++i) {
        YLSwipeLockNodeView *nodeView = _nodeArray[i];
        // TODO: change to use MIN marco in the future
        CGFloat min = self.bounds.size.width < self.bounds.size.height ? self.bounds.size.width : self.bounds.size.height;
        CGFloat width = min / 5;
        CGFloat height = min / 5;
        int row = i % 3;
        int column = i / 3;
        CGRect frame = CGRectMake(row *(width * 2), column * (width *2), width, height);
        nodeView.frame = frame;
        [maskPath appendPath:[UIBezierPath bezierPathWithOvalInRect:frame]];
    }
    
    maskLayer.path = maskPath.CGPath;
    self.polygonalLineLayer.mask = maskLayer;
}

/**
 *  根据point获得选中的按钮
 *  @param point 选中的按钮的位置
 */
-(NSInteger)indexForNodeAtPoint:(CGPoint)point
{
    for (int i = 0; i < self.nodeArray.count; ++i) {
        YLSwipeLockNodeView *node = self.nodeArray[i];
        // 坐标系转化
        CGPoint pointInNode = [node convertPoint:point fromView:self];
        // 判断pointInNode是否在node范围之内
        if ([node pointInside:pointInNode withEvent:nil]) {
            NSLog(@"indexForNodeAtPoint-点中了第%d个", i);
            return i;
        }
    }
    return -1;
}

-(void)cleanNodes
{
    for (int i = 0; i < self.nodeArray.count; ++i) {
        YLSwipeLockNodeView *node = self.nodeArray[i];
        node.nodeViewStatus = YLSwipeLockNodeViewStatusNormal;
    }
    
    [self.selectedNodeArray removeAllObjects];
    [self.pointArray removeAllObjects];
    self.polygonalLinePath = [UIBezierPath new];
    self.polygonalLineLayer.strokeColor = LIGHTBLUE.CGColor;
    self.polygonalLineLayer.path = self.polygonalLinePath.CGPath;
}

-(void)cleanNodesIfNeeded{
    if(self.viewState != YLSwipeLockNodeViewStatusNormal){
        [self cleanNodes];
    }
}

-(void)makeNodesToWarning
{
    for (int i = 0; i < self.selectedNodeArray.count; ++i) {
        YLSwipeLockNodeView *node = self.selectedNodeArray[i];
        node.nodeViewStatus = YLSwipeLockNodeViewStatusWarning;
    }
    self.polygonalLineLayer.strokeColor = [UIColor redColor].CGColor;
}

/**
 *  线条的layer
 *  @return
 */
-(CAShapeLayer *)polygonalLineLayer
{
    if (_polygonalLineLayer == nil) {
        _polygonalLineLayer = [[CAShapeLayer alloc] init];
        _polygonalLineLayer.lineWidth = 1.0f;
        _polygonalLineLayer.strokeColor = LIGHTBLUE.CGColor;
        _polygonalLineLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _polygonalLineLayer;
}

/**
 *  设置view的状态
 */
-(void)setViewState:(YLSwipeLockViewState)viewState
{
    _viewState = viewState;
    switch (_viewState){
        case YLSwipeLockViewStateNormal:
            [self cleanNodes];
            break;
        case YLSwipeLockViewStateWarning:
            // 手势匹配错误
            [self makeNodesToWarning];
            [self performSelector:@selector(cleanNodesIfNeeded) withObject:nil afterDelay:1];
            break;
        case YLSwipeLockViewStateSelected:
        default:
            break;
    }
}


@end
