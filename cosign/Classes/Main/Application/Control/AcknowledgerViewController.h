//
//  AcknowledgerViewController.h
//  cosign
//
//  Created by mac on 15/11/13.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AcknowlegeDelegate <NSObject>

- (void)changesTitle:(NSString *)title andUserId:(NSString *)userId;

- (void)acknowlegePassData:(NSArray *)arr;
@end

@interface AcknowledgerViewController : UIViewController


/** 代理对象 */
@property (retain, nonatomic) id<AcknowlegeDelegate>AcknowlegeDelegate;

@property(nonatomic,copy)NSArray *contactsArr;
@end
