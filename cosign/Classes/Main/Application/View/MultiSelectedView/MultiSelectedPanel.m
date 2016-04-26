//
//  MultiSelectedPanel.m
//  cosign
//
//  Created by 顾佳洪 on 15/11/16.
//  Copyright (c) 2015年 YuanTu. All rights reserved.
//

#import "MultiSelectedPanel.h"
#import "MutiCollectionViewLayout.h"

#define ItemWidth 70
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0
@implementation MultiSelectedPanel{
    NSIndexPath *currentIndexPath;
    NSInteger  deleteIndex;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        MutiCollectionViewLayout *flowLayout=[[MutiCollectionViewLayout alloc] init];
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30,self.frame.size.width, 100) collectionViewLayout:flowLayout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.showsHorizontalScrollIndicator =  NO;
        self.collectionView.dataSource = self;
        self.collectionView.delegate =  self;
        
        self.collectionView.alwaysBounceHorizontal=YES;
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MultiSelectedPanelTableViewCell"];
        [self addSubview:self.collectionView];
        

        
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
    while ([cell.contentView.subviews lastObject] != nil) {
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
    }
 
    //添加一个imageView
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0.0f, ItemWidth, ItemWidth)];
    imageView1.tag = 999;
    imageView1.layer.borderWidth = 0.5;
    imageView1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imageView1.layer.cornerRadius = 4.0f;
    imageView1.clipsToBounds = YES;
    imageView1.contentMode = UIViewContentModeScaleAspectFill;
    [cell.contentView addSubview:imageView1];
    
    PhotoInfo *photoInfo = self.selectedItems[indexPath.row];

    imageView1.image = photoInfo.thumbnail;
    
    UILabel *nameLable  =  [[UILabel alloc]  initWithFrame:CGRectMake(0, ItemWidth+5, ItemWidth, 13)];
    nameLable.font = [UIFont systemFontOfSize:12.0];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.text = photoInfo.imgName;
    [cell.contentView addSubview:nameLable];
    
    UILabel *fileLable =  [[UILabel alloc]  initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLable.frame), ItemWidth, 13)];
    fileLable.font = [UIFont systemFontOfSize:11.0];
    fileLable.textColor = [UIColor lightGrayColor];
    fileLable.textAlignment = NSTextAlignmentCenter;
    NSString *fileSize;
    CGFloat size=photoInfo.imgSize/1000;
    NSData *data = UIImageJPEGRepresentation(photoInfo.defaultImage ,0.1) ;
    CGFloat length = [data length]/1000;
    fileSize =[NSString stringWithFormat:@"%.2fK",length];
    if (length>1024) {
        length=length/1024;
        fileSize=[NSString stringWithFormat:@"%.2fM",length];
    }
    
    fileLable.text = [NSString stringWithFormat:@"%@",fileSize];
    [cell.contentView addSubview:fileLable];

    return cell;
}


#pragma mark  -- UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    PhotoInfo *photoInfo = self.selectedItems[indexPath.row];
    NSString *fileSize;
    CGFloat size=photoInfo.imgSize/1000;
    fileSize =[NSString stringWithFormat:@"%.2fK",size];
    if (size>1024) {
        size=size/1024;
        fileSize=[NSString stringWithFormat:@"%.2fM",size];
    }
    NSString *str=[NSString stringWithFormat:@"%@(%@)",photoInfo.imgName,fileSize];
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:str delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"预览", nil];
    [actionSheet showInView:self];
    deleteIndex = indexPath.row;
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        PhotoInfo *photoInfo = self.selectedItems[deleteIndex];
        //删除某元素,实际上是告诉delegate去删除
        if (self.delegate&&[self.delegate respondsToSelector:@selector(willDeleteRowWithItem:withMultiSelectedPanel:)]) { //委托给控制器   删除列表中item
            [self.delegate willDeleteRowWithItem:photoInfo withMultiSelectedPanel:self];
        }
        
        
        //确定没了删掉
        if ([self.selectedItems indexOfObject:photoInfo]==NSNotFound) {
            if (self.delegate &&[self.delegate respondsToSelector:@selector(updateConfirmButton)]) {
                [self.delegate updateConfirmButton];
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:deleteIndex inSection:0];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            
        }

    }else if(buttonIndex ==1){
        if (self.delegate&&[self.delegate respondsToSelector:@selector(previewPhotoAtIndex:)]) {
            [self.delegate previewPhotoAtIndex:deleteIndex];
        }
        
        
    }else{

        
    }
}

#pragma mark - out call
- (void)didDeleteSelectedIndex:(NSUInteger)selectedIndex
{
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(updateConfirmButton)]) {
        [self.delegate updateConfirmButton];
    }
    
    //执行删除操作
    
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
