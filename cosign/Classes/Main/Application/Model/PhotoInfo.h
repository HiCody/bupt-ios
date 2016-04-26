//
//  PhotoInfo.h
//  cosign
//
//  Created by 顾佳洪 on 15/11/16.
//  Copyright (c) 2015年 YuanTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoInfo : NSObject
@property(nonatomic,strong)NSString *imgName;
@property(nonatomic,assign)CGFloat imgSize;
@property(nonatomic,strong)UIImage *thumbnail;
@property(nonatomic,strong)UIImage *defaultImage;
@property(nonatomic,strong)NSURL *url;
@property(nonatomic,strong)NSData *data;
@property(nonatomic,strong)NSString *path;
@end
