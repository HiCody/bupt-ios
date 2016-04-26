//
//  MoveLine.m
//  cosign
//
//  Created by steve on 15/10/12.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import "MoveLine.h"

@implementation MoveLine

+(instancetype)getViewWithFrame:(CGRect)frame backgroudColor:(UIColor *)color{
    MoveLine *moveLine = [[MoveLine alloc]initWithFrame:frame];

    moveLine.backgroundColor = color;
   
    return moveLine;

}



@end
