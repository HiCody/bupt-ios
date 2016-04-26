//
//  ApplicationBaseTableView.h
//  cosign
//
//  Created by mac on 15/10/28.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DotView.h"

@protocol ApplicationsDelegate <NSObject>

-(void)JumpToSecondView:(NSIndexPath *)indexPath;

- (void)loadNewData;

- (void)loadMoreDate;
@end

@interface ApplicationBaseTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

/** 代理对象 */
@property (nonatomic, weak) id<ApplicationsDelegate> applicationDelegate;

@property(nonatomic,assign)NSInteger index;

@property(nonatomic,strong)NSMutableArray *dataList;


@property(nonatomic,strong)DotView *dotview;

- (void)beginRefresh;
- (void)loadingNewData;
-(void)loadingMoreData;

@end
