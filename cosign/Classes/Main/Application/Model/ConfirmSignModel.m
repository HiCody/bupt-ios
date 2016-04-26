//
//  ConfirmSignModel.m
//  cosign
//
//  Created by mac on 15/11/17.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import "ConfirmSignModel.h"
static id shareConfirmSign;
@implementation ConfirmSignModel
+ (instancetype)shareConfirmSign
{
    if (shareConfirmSign == nil) {
        shareConfirmSign = [[ConfirmSignModel alloc] init];
    }
    
    return shareConfirmSign;
}


@end
