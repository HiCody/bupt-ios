//
//  UIImage+RenderedImage.m
//  ZJOL
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/1/6.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "UIImage+RenderedImage.h"

@implementation UIImage (RenderedImage)
+ (UIImage *)imageWithRenderColor:(UIColor *)color renderSize:(CGSize)size {
    
    UIImage *image = nil;
    UIGraphicsBeginImageContext(size);
    [color setFill];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0., 0., size.width, size.height));
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIImage *)resiableImage:(NSString *)name{
    UIImage *normal=[UIImage imageNamed:name];
    //UIEdgeInsetsMake(top,left,down,right)
    //拉升图片：上、左、下、右
    //这里分别是上面15个不参与拉升，左边15个不参与拉升，下面15个不参与拉升，下边15个不参与拉升。除这些规定部分不参与拉升之外，其他部分会随着区域大小进行拉升
    return [normal resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
}
@end
