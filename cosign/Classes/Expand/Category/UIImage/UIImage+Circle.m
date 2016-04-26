//
//  UIImage+Circle.m
//  8、音乐播放器
//
//  Created by niit on 15/6/1.
//  Copyright (c) 2015年 niit. All rights reserved.
//

#import "UIImage+Circle.h"

@implementation UIImage (Circle)

+(instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
//1、获得原来的图片
    UIImage *oldImge=[UIImage imageNamed:name];
    
//2、要绘图，首先得创建上下文
    CGFloat imgW=oldImge.size.width+2*borderWidth;
    CGFloat imgH=oldImge.size.height+2*borderWidth;
    CGSize imgSize=CGSizeMake(imgW, imgH);
    UIGraphicsBeginImageContext(imgSize);
    
//3、得到绘图上下文
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    [borderColor set];//设置填充颜色
    
//4、画大圆（边框）
    CGFloat radius=imgW/2.0f;//大圆的半径
    CGFloat cenX=radius;
    CGFloat cenY=radius;
    CGContextAddArc(ctx, cenX, cenY, radius, 0, 2*M_PI, 0);
    CGContextFillPath(ctx);
//    CGContextStrokePath(ctx);
    
//5、画小圆
    CGFloat smallRadius=radius-borderWidth;//小圆的半径
    //画了一个小圆
    CGContextAddArc(ctx, cenX, cenY, smallRadius, 0,  2*M_PI, 0);
    //裁剪
    CGContextClip(ctx);
    
//6、画图
    [oldImge drawInRect:CGRectMake(borderWidth, borderWidth, oldImge.size.width, oldImge.size.height)];
    
//7、得到画好的后的图片
    UIImage *newImg=UIGraphicsGetImageFromCurrentImageContext();
//8、结束上下文
    UIGraphicsEndImageContext();
    
    return newImg;
}

@end
