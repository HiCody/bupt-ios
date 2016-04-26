//
//  AcknowledgerTableView.h
//  cosign
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AcknowledgerTableView : UITableView<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)NSMutableArray *dataArry;

@property(nonatomic,strong)NSMutableArray *selectedArr;



@end
