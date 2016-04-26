//
//  MutiCollectionViewLayout.m
//  cosign
//
//  Created by 顾佳洪 on 15/11/16.
//  Copyright (c) 2015年 YuanTu. All rights reserved.
//

#import "MutiCollectionViewLayout.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0

#define ItemWidth 70
#define ItemHeight 100

@implementation MutiCollectionViewLayout

//准备布局,最先调用该方法
-(void)prepareLayout{
    [super prepareLayout];
    _cellCount=[self.collectionView numberOfItemsInSection:0];
}


//对每一个cell的进行布局
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    //某个cell的布局和属性
    UICollectionViewLayoutAttributes *attribues=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSInteger row=indexPath.row;
    CGFloat padding = 20;
    CGFloat x= padding*(row+1)+row*ItemWidth;
    attribues.frame = CGRectMake(x, 0, ItemWidth, ItemHeight);
    return attribues;
}


//区域内布局，返回的是所有cell的布局
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *attributes=[NSMutableArray array];
    for (NSInteger i=0;i<self.cellCount;i++) {
        NSIndexPath *path=[NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:path]];
    }
    return attributes;
}



- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}



- (CGSize)collectionViewContentSize

{
    
    CGSize contentSize = CGSizeMake(self.cellCount*(20+70), ItemHeight);
    
    return contentSize;
    
}


@end
