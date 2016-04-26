//
//  UserInfo.h
//  cosign
//
//  Created by mac on 15/10/28.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *userRolesDisp;

@property (nonatomic, assign) BOOL stopped;

@property (nonatomic, copy) NSString *stoppedDisp;

@property (nonatomic, copy) NSString *userRoles;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *mobilePhone;

@property (nonatomic, copy) NSString *operateRoles;

+ (instancetype)shareUserInfo;
@end
