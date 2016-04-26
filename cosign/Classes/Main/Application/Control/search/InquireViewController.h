//
//  InquireViewController.h
//  cosign
//
//  Created by mac on 15/10/14.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"MattersListViewController.h"

@protocol InquireVCdelegate <NSObject>

- (void)requestDataByRequirementWithIndex:(NSInteger)searchIndex WithHqType:(NSString *)hqType WithTitle:(NSString *)title;

@end

@interface InquireViewController : UIViewController<MattersListDelegate>

@property (nonatomic, weak)id<InquireVCdelegate>delegate;
////通过代理对象传值


@property(nonatomic,assign)NSInteger index;

@end
