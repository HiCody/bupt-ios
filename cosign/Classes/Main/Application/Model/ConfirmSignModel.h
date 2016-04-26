//
//  ConfirmSignModel.h
//  cosign
//
//  Created by mac on 15/11/17.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfirmSignModel : NSObject
@property(nonatomic,strong)NSString *userId;//用户登录账号
@property(nonatomic,strong)NSString *password;//密码
@property(nonatomic,strong)NSString *platform;//平台来源 1:web 2:android
@property(nonatomic,strong)NSString *id;//默认0 内容编号
@property(nonatomic,strong)NSString *title;//事项标题
@property(nonatomic,strong)NSString *contents;//事项内容(可不填)
@property(nonatomic,strong)NSString *hqType;//会签类型(id)
@property(nonatomic,strong)NSString *fileUrls;//文件名(可不填,多个文件名中间以|分隔,)
@property(nonatomic,strong)NSString *checkers;//会签人userId(多个以,分隔)
@property(nonatomic,strong)NSString *readers;//传阅人userId(可不填, 多个以,分隔)

@end
