//
//  CommentModel.h
//  cosign
//
//  Created by mac on 15/12/17.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *hqComment;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *passed;

@property (nonatomic, copy) NSString *hqDate;

@property (nonatomic, assign) NSInteger hqContentId;

@property (nonatomic, assign) NSInteger hqOrder;

@end
