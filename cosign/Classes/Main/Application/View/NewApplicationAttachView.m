//
//  NewApplicationAttachView.m
//  cosign
//
//  Created by mac on 15/11/13.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import "NewApplicationAttachView.h"

@interface NewApplicationAttachView()<BottomViewDelegate>


@end

@implementation NewApplicationAttachView

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupConfigure];
    }
    return self;
}

- (void)setupConfigure{
    
    self.isShowButtomView = NO;
    self.toolbarView.frame = CGRectMake(0, 0, self.frame.size.width, 8 * 2 + 36);
    self.toolbarView.backgroundColor = [UIColor clearColor];
   
    [self addSubview:self.toolbarView];
}
- (void)setupSubviews
{
    //更多
    self.attachBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-80, 8, 70, 36)];
    self.attachBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.attachBtn setImage:[UIImage imageNamed:@"icon_status_attach"] forState:UIControlStateNormal];

    [self.attachBtn setImage:[UIImage imageNamed:@"icon_attachbtn_paperclip_highlighted"] forState:UIControlStateSelected];
    [self.attachBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.attachBtn.tag = 2;
   

}

#pragma mark - action

- (void)buttonAction:(id)sender
{
   
}

@end
