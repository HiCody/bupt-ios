//
//  ContactsSelectedPanel.m
//  cosign
//
//  Created by mac on 16/1/7.
//  Copyright © 2016年 YuanTu. All rights reserved.
//

#import "ContactsSelectedPanel.h"
#import "ContactsCollectionViewLayout.h"
#import "UIImage+Name.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0

@implementation ContactsSelectedPanel{
    NSIndexPath *currentIndexPath;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        ContactsCollectionViewLayout *flowLayout=[[ContactsCollectionViewLayout alloc] init];
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, 57.5) collectionViewLayout:flowLayout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.showsHorizontalScrollIndicator =  NO;
        self.collectionView.dataSource = self;
        self.collectionView.delegate =  self;
        
        self.collectionView.alwaysBounceHorizontal=YES;
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MultiSelectedPanelTableViewCell"];
        [self addSubview:self.collectionView];
        
        UIView *lineView= [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.collectionView.frame), WinWidth, 0.5)];
        lineView.backgroundColor =[UIColor lightGrayColor];
        [self addSubview:lineView];
        
        
    }
    return self;
}

#pragma mark - setter
- (void)setSelectedItems:(NSMutableArray *)selectedItems
{
    _selectedItems = selectedItems;
    
    [self.collectionView reloadData];
    
    //[self updateConfirmButton];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectedItems.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MultiSelectedPanelTableViewCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    
    //添加一个imageView
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 4, 50, 50)];
    imageView1.tag = 999;
    imageView1.layer.cornerRadius = 25.0f;
    imageView1.clipsToBounds = YES;
    imageView1.layer.masksToBounds=YES;
    imageView1.contentMode = UIViewContentModeScaleAspectFill;
    [cell.contentView addSubview:imageView1];
    
    
    //    UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:999];
    
    Userinfos *user = self.selectedItems[indexPath.row];
    

    // [imageView1 sd_setImageWithURL:[NSURL URLWithString:item1.imageUrl]];
    imageView1.image =[UIImage imageWithView:user.userName];
    
    return cell;
}


#pragma mark  -- UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    Userinfos *user = self.selectedItems[indexPath.row];
    //删除某元素,实际上是告诉delegate去删除
    if (self.delegate&&[self.delegate respondsToSelector:@selector(willDeleteRowWithItem:withMultiSelectedPanel:)]) { //委托给控制器   删除列表中item
        [self.delegate willDeleteRowWithItem:user withMultiSelectedPanel:self];
    }
    
    
    //确定没了删掉
    if ([self.selectedItems indexOfObject:user]==NSNotFound) {
        if (self.delegate &&[self.delegate respondsToSelector:@selector(updateConfirmButton)]) {
            [self.delegate updateConfirmButton];
        }
        
        [collectionView deleteItemsAtIndexPaths:@[indexPath]];
        
    }
    
}

#pragma mark - out call
- (void)didDeleteSelectedIndex:(NSUInteger)selectedIndex
{
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(updateConfirmButton)]) {
        [self.delegate updateConfirmButton];
    }
    
    //执行删除操作
    //[self.collectionView reloadData];
    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedIndex inSection:0]]];
}

- (void)didAddSelectedIndex:(NSUInteger)selectedIndex
{
    //找到index
    if (selectedIndex<self.selectedItems.count) {
        
        if (self.delegate &&[self.delegate respondsToSelector:@selector(updateConfirmButton)]) {
            [self.delegate updateConfirmButton];
        }
        //执行插入操作
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        //[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
        currentIndexPath = indexPath;
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        
        
    }
}


@end
