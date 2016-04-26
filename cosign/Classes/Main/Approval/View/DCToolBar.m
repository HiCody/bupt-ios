//
//  DCToolBar.m
//  jsce
//
//  Created by mac on 15/9/25.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "DCToolBar.h"

#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0

@interface DCButton : UIButton

@end

@implementation DCButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setTitleColor:NAVBAR_SECOND_COLOR forState:UIControlStateNormal];
//        [self setTitleColor:NAVBAR_SECOND_COLOR  forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat h = self.frame.size.height * 0.4;
    CGFloat w = h;
    CGFloat x =  self.frame.size.width * 0.25;
    CGFloat y = (self.frame.size.height - w) * 0.5;
    return CGRectMake(x, y, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake( self.frame.size.width * 0.45, (self.frame.size.height - self.frame.size.height * 0.3) * 0.5, self.frame.size.width*0.6, self.self.frame.size.height * 0.3);
}


@end


@implementation DCToolBar


- (void)addTabButtonWithImgName:(NSString *)name andImaSelName:(NSString *)selName andTitle:(NSString *)title{
    DCButton *btn=[[DCButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [btn  setImage:[UIImage imageNamed:selName] forState:UIControlStateHighlighted];
    [self addSubview:btn];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    if (self.subviews.count==1) {
//        [self  buttonClick:btn];
//    }
}

- (void)buttonClick:(id)sender{
    UIButton *btn=sender;
    btn.selected=YES;
    self.selectBtn.selected=NO;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(willSelectIndex:)]) {
        [self.delegate willSelectIndex:btn.tag-100];
    }
    self.selectBtn=btn;
}

- (void)layoutSubviews{
    [super layoutSubviews];
   
    
    NSInteger count=self.subviews.count;
    for (int i=0; i<count; i++) {
        UIButton *tmpBtn=self.subviews[i];
        tmpBtn.tag=i+100;
        
        CGFloat btnY=0;
        CGFloat btnWidth=WinWidth/count;
        CGFloat btnHeight=self.frame.size.height;
        CGFloat btnX=i*btnWidth;
        
        tmpBtn.frame=CGRectMake(btnX, btnY, btnWidth, btnHeight);
    }
}

//- (instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
//    
//    }
//    return  self;
//}

@end
