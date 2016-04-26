//
//  ApprovalPeopleModel.h
//  PMP
//
//  Created by mac on 16/1/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Userinfos;
@interface ApprovalPeopleModel : NSObject

@property (nonatomic, assign) NSInteger deptId;

@property (nonatomic, assign) NSInteger delFlag;

@property (nonatomic, assign) BOOL open;

@property (nonatomic, copy) NSString *deptName;// 部门名称

@property (nonatomic, assign) NSInteger deptSort;

@property (nonatomic, copy) NSString *deptParentName;

@property (nonatomic, assign) NSInteger deptParentId;

@property (nonatomic, strong) NSArray<Userinfos *> *userInfos;

@end
@interface Userinfos : NSObject

@property (nonatomic, copy) NSString *posiName;//部门的职位名称

@property (nonatomic, copy) NSString *stoppedDisp;

@property (nonatomic, copy) NSString *deptName;

@property (nonatomic, copy) NSString *operateRoles;

@property (nonatomic, copy) NSString *userRoles;

@property (nonatomic, assign) NSInteger deptId;

@property (nonatomic, assign) NSInteger posiId;

@property (nonatomic, copy) NSString *reloeations;

@property (nonatomic, assign) BOOL stopped;

@property (nonatomic, copy) NSString *reloeation;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *userName;//使用人名称

@property (nonatomic, assign) NSInteger relId;

@property (nonatomic, copy) NSString *mobilePhone;

@property (nonatomic, copy) NSString *userRolesDisp;

@property (nonatomic, copy) NSString *email;

@end

