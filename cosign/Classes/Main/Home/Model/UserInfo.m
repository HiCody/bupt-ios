//
//  UserInfo.m
//  cosign
//
//  Created by mac on 15/10/28.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import "UserInfo.h"
static id shareUserInfo;
@implementation UserInfo


+ (instancetype)shareUserInfo
{
    if (shareUserInfo == nil) {
        shareUserInfo = [[UserInfo alloc] init];
    }
    
    return shareUserInfo;
}


@end
