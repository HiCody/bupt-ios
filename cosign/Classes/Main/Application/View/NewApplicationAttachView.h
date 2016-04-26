//
//  NewApplicationAttachView.h
//  cosign
//
//  Created by mac on 15/11/13.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewApplicationBottomView.h"
@interface NewApplicationAttachView : UIView

@property (strong, nonatomic) UIButton *attachBtn;

@property (nonatomic,strong)NewApplicationBottomView *bottomView;

@property (strong, nonatomic) UIView *toolbarView;
/**
 *  底部扩展页面
 */
@property (nonatomic) BOOL isShowButtomView;

@end
