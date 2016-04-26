//
//  BaseDetailViewController.h
//  cosign
//
//  Created by mac on 15/11/26.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationModel.h"
typedef NS_ENUM(NSInteger,State){
    isShow1=1,
    isHide1=0
};
@interface BaseDetailViewController : UIViewController

@property(nonatomic, strong)ApplicationModel *aModel;
@property(nonatomic,assign)State state;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)NSArray *fileArr;
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSDictionary *parameters;
@property(nonatomic,strong)NSString *interfaceString;
-(void)configHeadView;
- (void)configToolBar;
- (void)requestData;
@end
