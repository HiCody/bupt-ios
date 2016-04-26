//
//  NewApplicationModel.h
//  cosign
//
//  Created by mac on 15/11/12.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewApplicationModel : NSObject

@property(nonatomic,strong)NSString *email;
@property(nonatomic,assign)NSInteger mobilePhone;
@property(nonatomic,strong)NSString *stopped;
@property(nonatomic,strong)NSString *stoppedDisp;
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *userRoles;
@property(nonatomic,strong)NSString *userRolesDisp;

@property(nonatomic,strong)NSString *addDate;
@property(nonatomic,strong)NSString * checkerDetails;
@property(nonatomic,strong)NSString *checkers;
@property(nonatomic,assign)NSInteger id;
@property(nonatomic,strong)NSString *readerDetails;

@property(nonatomic,strong)NSString *name;




@property(nonatomic,assign)NSInteger deptId;
@property(nonatomic,assign)NSInteger posiId;
@property(nonatomic,strong)NSString *posiName;
@property(nonatomic,strong)NSString *deptName;
@property(nonatomic,assign)NSInteger relId;
@property(nonatomic,strong)NSString *reloeations;
@property(nonatomic,strong)NSString *reloeation;
@property(nonatomic,strong)NSString *operateRoles;//代表每个用户具体的审批权限





@end
