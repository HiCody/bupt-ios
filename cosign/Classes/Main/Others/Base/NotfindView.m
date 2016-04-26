//
//  NotfindView.m
//  cosign
//
//  Created by mac on 15/10/20.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import "NotfindView.h"

#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/375.0
#define H(y) WinHeight*y/667.0


@implementation NotfindView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(WinWidth/3,20,WinWidth/3, 80)];
        img.contentMode =  UIViewContentModeCenter;
        img.image = [UIImage imageNamed:@"pic_page_nodata.png"];
        [self addSubview:img];
        
        UILabel* lbl = [[UILabel alloc] init];
        lbl.text = @"没有找到符合条件的结果!";
        lbl.textColor = [UIColor lightGrayColor];
        lbl.font = [UIFont systemFontOfSize:15];
        lbl.frame = CGRectMake(W(80),H(100), WinWidth-W(160), H(60));
        lbl.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:lbl];
    }
    return self;
}



@end
