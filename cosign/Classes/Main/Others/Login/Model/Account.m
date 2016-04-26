//
//  LoginModel.m
//  jsce
//
//  Created by mac on 15/9/15.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import "Account.h"

static id shareAccount;

@implementation Account
+ (instancetype)shareAccount
{
    if (shareAccount == nil) {
        shareAccount = [[Account alloc] init];
    }
    
    return shareAccount;
}

- (void)saveAccountToSanbox{
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    [userdefault setObject:self.userName forKey:K_UserName];
    [userdefault setObject:self.passWord forKey:K_PassWord];
    [userdefault setObject:self.shock forKey:K_Shock];
    [userdefault setObject:self.sound forKey:K_Sound];
    [userdefault setObject:self.autoLogin forKey:K_AutoLogin];
    [userdefault setObject:self.savePwd forKey:K_SavePwd];
  //  [userdefault setObject:self.tempPwd forKey:K_TempPwd];
    [userdefault synchronize];
}


- (void)loadAccountFromSanbox{
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    
    self.userName = [userdefault objectForKey:K_UserName];
    
    self.passWord = [userdefault objectForKey:K_PassWord];
    
    self.shock=[userdefault objectForKey:K_Shock];
    
    self.sound=[userdefault objectForKey:K_Sound];
    
    self.savePwd = [userdefault objectForKey:K_SavePwd];
    
    self.autoLogin = [userdefault objectForKey:K_AutoLogin];
    
  //  self.tempPwd  = [userdefault objectForKey:K_TempPwd];
    
}

@end


