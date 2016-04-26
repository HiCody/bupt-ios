//
//  RcirculatedTableView.h
//  cosign
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RcirculatedTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong)NSMutableArray *approverArr;


@property(nonatomic ,strong)NSString *cosignStr;
@property(nonatomic,strong)NSString *userIdStr;
@end
