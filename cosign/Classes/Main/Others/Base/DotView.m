//
//  DotView.m
//  cosign
//
//  Created by mac on 15/10/21.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import "DotView.h"

@implementation DotView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(130,20+70/3,10, 10)];
        img.backgroundColor = [UIColor greenColor];
        img.layer.masksToBounds =YES;
        img.layer.cornerRadius = 5;
        
        [self addSubview:img];
        
     }
    return self;
}



@end
