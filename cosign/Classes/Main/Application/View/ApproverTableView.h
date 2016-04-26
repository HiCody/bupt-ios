//
//  ApproverTableView.h
//  cosign
//
//  Created by mac on 15/11/12.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApproverTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)NSMutableArray *approverArr;


@property(nonatomic,assign)NSInteger index;

@end
