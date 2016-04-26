//
//  ApprovalViewController.h
//  cosign
//
//  Created by mac on 15/11/24.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationModel.h"
typedef NS_ENUM(NSInteger,State2){
    isShow2=1,
    isHide2=0
};
@interface ApprovalViewController : UIViewController
@property(nonatomic, strong)ApplicationModel *aModel;
@property(nonatomic,assign)State2 state;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)NSArray *fileArr;
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSDictionary *parameters;
@property(nonatomic,strong)NSString *interfaceString;
@property(nonatomic,assign)BOOL hasHighLevel;
-(void)configHeadView;
- (void)configToolBar;
- (void)requestData;
@end
