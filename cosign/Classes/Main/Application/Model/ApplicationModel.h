//
//  ApplicationModel.h
//  cosign
//
//  Created by mac on 15/10/14.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationModel : NSObject

@property(nonatomic,assign)NSInteger id;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *contents;
@property(nonatomic,strong)NSString *starter;
@property(nonatomic,assign)NSInteger status;
@property(nonatomic,strong)NSString *hqStatusName;
@property(nonatomic,strong)NSString *startDate;
@property(nonatomic,assign)NSInteger hqType;
@property(nonatomic,strong)NSString *hqTypeName;
@property(nonatomic,strong)NSString *fileUrls;
@property(nonatomic,strong)NSString *confirmByStarter;
@property(nonatomic,strong)NSString *fileLength;
@property(nonatomic,strong)NSString *checkers;
@property(nonatomic,strong)NSString *readers;
@property(nonatomic,strong)NSString *starterName;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *flowid;
@property(nonatomic,strong)NSString *flows;
@property(nonatomic,strong)NSString *hid;
@property(nonatomic,strong)NSString *rid;


@property(nonatomic,strong)NSString *hqComment;
@property(nonatomic,strong)NSString *hqDate;




@end
