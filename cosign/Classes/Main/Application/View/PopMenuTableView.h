//
//  PopMenuTableView.h
//  cosign
//
//  Created by mac on 15/10/30.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PopMenuDelegate<NSObject>

- (void)openFileWithIndex:(NSInteger )index;


@end


@interface PopMenuTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray *dataList;

@property(nonatomic,weak)id<PopMenuDelegate>menuDelegate;

@end
