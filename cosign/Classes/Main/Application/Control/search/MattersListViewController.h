//
//  MattersListViewController.h
//  cosign
//
//  Created by mac on 15/10/14.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MattersListDelegate <NSObject>

- (void)changeTitle:(NSString *)title WithValue:(NSInteger)integer;

@end

@interface MattersListViewController : UITableViewController

/** 代理对象 */
@property (retain, nonatomic) id<MattersListDelegate> MattersListDelegate;

@property(nonatomic,strong)NSString *matterTypeStr;
@end
