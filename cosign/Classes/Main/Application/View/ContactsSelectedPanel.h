//
//  ContactsSelectedPanel.h
//  cosign
//
//  Created by mac on 16/1/7.
//  Copyright © 2016年 YuanTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApprovalPeopleModel.h"
@class ContactsSelectedPanel;
@protocol ContactsSelectedPanelDelegate <NSObject>

- (void)willDeleteRowWithItem:(Userinfos *)user withMultiSelectedPanel:(ContactsSelectedPanel *)multiSelectedPanel;

@optional
- (void)updateConfirmButton;

@end
@interface ContactsSelectedPanel : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

//+ (instancetype)instanceFromNib;

@property (nonatomic, strong) NSMutableArray *selectedItems;
@property (nonatomic, weak) id<ContactsSelectedPanelDelegate> delegate;

@property (nonatomic,strong) UICollectionView  *collectionView;


//数组有变化之后需要主动激活
- (void)didDeleteSelectedIndex:(NSUInteger)selectedIndex;
- (void)didAddSelectedIndex:(NSUInteger)selectedIndex;

@end
