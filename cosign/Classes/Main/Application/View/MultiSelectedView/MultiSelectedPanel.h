//
//  MultiSelectedPanel.h
//  cosign
//
//  Created by 顾佳洪 on 15/11/16.
//  Copyright (c) 2015年 YuanTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoInfo.h"
@class MultiSelectedPanel;
@protocol MultiSelectedPanelDelegate <NSObject>
- (void)willDeleteRowWithItem:(PhotoInfo *)photoInfo withMultiSelectedPanel:(MultiSelectedPanel*)multiSelectedPanel;

- (void)updateConfirmButton;

-(void)previewPhotoAtIndex:(NSInteger)index;
@end

@interface MultiSelectedPanel : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate>

//+ (instancetype)instanceFromNib;

@property (nonatomic, strong) NSMutableArray *selectedItems;
@property (nonatomic, weak) id<MultiSelectedPanelDelegate> delegate;

@property (nonatomic,strong) UICollectionView  *collectionView;


//数组有变化之后需要主动激活
- (void)didDeleteSelectedIndex:(NSUInteger)selectedIndex;
- (void)didAddSelectedIndex:(NSUInteger)selectedIndex;

@end
