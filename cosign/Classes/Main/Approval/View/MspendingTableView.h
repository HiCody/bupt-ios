//
//  MspendingTableView.h
//  cosign
//
//  Created by mac on 15/10/21.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MspendingDelegate <NSObject>

-(void)JumpToSecondView:(NSIndexPath *)indexPath;

- (void)loadNewData;

- (void)loadMoreDate;

@end

@interface MspendingTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataArry;

/** 代理对象 */
@property (nonatomic, weak) id<MspendingDelegate> MspendingDelegate;

@property(nonatomic,assign)BOOL isSpendHistory;

- (void)beginRefresh;
- (void)loadingNewData;
-(void)loadingMoreData;
@end
