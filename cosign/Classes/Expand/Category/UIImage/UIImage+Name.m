//
//  UIImage+Name.m
//  jsce
//
//  Created by mac on 15/10/22.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "UIImage+Name.h"
#define RGB(r,g,b) [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:1.]
@implementation UIImage (Name)

+ (UIImage *) imageWithView:(NSString *)str
{
    
    NSArray *arr =  @[RGB(138,199,250),
                      RGB(255,216,140),
                      RGB(136,174,246),
                      RGB(255,160,140),
                      RGB(242,137,249),
                      RGB(255,194,140),
                      RGB(255,140,181),
                      RGB(255,140,144),
                      RGB(139,252,193),
                      RGB(156,133,242),
                      ];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    lable.font =[UIFont systemFontOfSize:14.0];
    if (str.length>2) {
        str  =  [str substringFromIndex:str.length-2];
    }
    lable.text = str;
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment =NSTextAlignmentCenter;
    

    lable.backgroundColor =arr[arc4random()%10];
    
    UIGraphicsBeginImageContextWithOptions(lable.bounds.size, lable.opaque, [[UIScreen mainScreen] scale]);
    
    [lable.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
