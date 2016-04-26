//
//  LoginModel.h
//  jsce
//
//  Created by mac on 15/9/15.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import <Foundation/Foundation.h>
#define K_UserName     @"userName"
#define K_PassWord     @"passWord"
#define K_Shock        @"isShock"
#define K_Sound        @"isSound"
#define K_AutoLogin    @"isAutoLogin"
#define K_SavePwd      @"isSavePwd"
#define K_TempPwd      @"tempPwd"

@interface Account : NSObject

@property (nonatomic, copy) NSString *userName;//用户名
@property (nonatomic, copy) NSString *passWord;//密码
@property (nonatomic,copy)NSString *shock;
@property (nonatomic,copy)NSString *sound;
@property (nonatomic,copy)NSString *autoLogin;
@property (nonatomic,copy)NSString *savePwd;
@property (nonatomic,copy)NSString *tempPwd;
+ (instancetype)shareAccount;

- (void)saveAccountToSanbox;

-(void)loadAccountFromSanbox;


@end





