//
//  QueryHqTypeList.h
//  cosign
//
//  Created by mac on 15/12/10.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Flows;
@interface QueryHqTypeList : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, strong) NSArray<Flows *> *flows;

@property (nonatomic, assign) NSInteger pointCount;

@property (nonatomic, copy) NSString *name;

@end
@interface Flows : NSObject

@property (nonatomic, assign) NSInteger flowid;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) NSInteger approves;

@property (nonatomic, assign) NSInteger pointOrder;

@property (nonatomic, assign) NSInteger pass;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, assign) NSInteger deptId;

@property (nonatomic, copy) NSString *pointName;

@property (nonatomic, assign) NSInteger fid;

@property (nonatomic, copy) NSString *typeName;

@property (nonatomic, copy) NSString *deptName;

@end

