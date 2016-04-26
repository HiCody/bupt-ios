//
//  NewApplicationBottomView.h
//  cosign
//
//  Created by mac on 15/11/13.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BottomViewDelegate;
@interface NewApplicationBottomView : UIView

@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) UIButton *takePicButton;
@property (nonatomic, strong) UIButton *fileButton;
@property (nonatomic,assign) id<BottomViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setupSubviewsForType;
@end

@protocol BottomViewDelegate <NSObject>

@required
- (void)moreViewTakePicAction:(NewApplicationBottomView *)bottomView;
- (void)moreViewPhotoAction:(NewApplicationBottomView *)bottomView;

@end
