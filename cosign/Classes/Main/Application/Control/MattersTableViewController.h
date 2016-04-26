//
//  MattersTableViewController.h
//  cosign
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MattersDelegate <NSObject>

- (void)changeTitle:(NSString *)title WithValue:(NSInteger)integer;

@end

@interface MattersTableViewController : UITableViewController

/** 代理对象 */
@property (retain, nonatomic) id<MattersDelegate> MattersDelegate;

@property(nonatomic, strong)NSMutableArray *array;


@property(nonatomic,strong)NSString *matterTypeStr;
@end
