//
//  NewApplicationBottomView.m
//  cosign
//
//  Created by mac on 15/11/13.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import "NewApplicationBottomView.h"
#define TOOLBAR_BUTTON_HEIGHT 36
#define TOOLBAR_BUTTON_WIDTH  42
@implementation NewApplicationBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupSubviewsForType];
    }
    return self;
}

- (void)setupSubviewsForType
{
    CGSize viewSize = self.frame.size;
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, 36+10+10)];
    UIImageView *bgImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    bgImgView.frame=CGRectMake(0, 0, viewSize.width, 36+10+10);
    [toolBar addSubview:bgImgView];
    
    self.backgroundColor = [UIColor clearColor];
    CGFloat insets = 30;
    
    _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_photoButton setFrame:CGRectMake(insets, 10, TOOLBAR_BUTTON_WIDTH, TOOLBAR_BUTTON_HEIGHT)];
    [_photoButton setImage:[UIImage imageNamed:@"icon_attach_toolbar_album"] forState:UIControlStateNormal];
    [_photoButton setImage:[UIImage imageNamed:@"icon_attach_toolbar_album_highlighted"] forState:UIControlStateHighlighted];
    [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    [bgImgView addSubview:_photoButton];
    
    _takePicButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_takePicButton setFrame:CGRectMake(CGRectGetMaxX(_photoButton.frame)+40, 10, TOOLBAR_BUTTON_WIDTH , TOOLBAR_BUTTON_HEIGHT)];
    [_takePicButton setImage:[UIImage imageNamed:@"icon_attach_toolbar_camera"] forState:UIControlStateNormal];
    [_takePicButton setImage:[UIImage imageNamed:@"icon_attach_toolbar_camera_highlighted"] forState:UIControlStateHighlighted];
    [_takePicButton addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
    [bgImgView addSubview:_takePicButton];
    
    UIView *bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, toolBar.frame.size.height)];
    [self addSubview:bottomView];
    [self addSubview:toolBar];
    CGRect frame = self.frame;
    frame.size.height = bottomView.frame.size.height+toolBar.frame.size.height;
    
    self.frame = frame;
}

- (void)takePicAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
        [_delegate moreViewTakePicAction:self];
    }
}

- (void)photoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}

@end
