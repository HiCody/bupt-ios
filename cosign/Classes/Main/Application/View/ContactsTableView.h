//
//  ContactsTableView.h
//  cosign
//
//  Created by mac on 15/11/11.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApprovalPeopleModel.h"

@interface ContactsTableView : UITableView<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)NSMutableArray *dataArry;

@property(nonatomic, strong)NSMutableArray *selectedIndexes;

@property(nonatomic,strong)NSMutableArray *selectedArr;

@property(strong, nonatomic) NSMutableArray *treeResultArray;
///判断是否展开或者合上的数组.
@property (strong, nonatomic) NSMutableArray *treeOpenArray;
///判断是否展开或者合上的字符串.
@property (strong, nonatomic) NSString *treeOpenString;

@property (nonatomic,copy) void(^addSelectedUser)(NSInteger);

@property (nonatomic,copy) void(^deleteSelectedUser)(NSInteger);
///点击section的方法。
-(void)tapAction:(UIButton *)sender;



@end
