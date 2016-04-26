    //
//  HomeViewController.h
//  cosign
//
//  Created by steve on 15/10/12.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray *dataLists;


@end
