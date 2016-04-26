//
//  GJCFMyCustomStyle.m
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-13.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFMyCustomStyle.h"
#import "DeepCustomPickerOverlayView.h"
@implementation GJCFMyCustomStyle

+ (UIColor *)sysButtonTitleNormalColor
{
    return [UIColor colorWithRed:81/255.0 green:189/255.0 blue:3/255.0 alpha:1.0];
}
+ (UIColor *)sysButtonTitleHighlightColor
{
    return [UIColor colorWithRed:81/255.0 green:189/255.0 blue:3/255.0 alpha:1.0];
}



- (UIFont *)sysButtonFont
{
    return [UIFont systemFontOfSize:16];
}

- (UIColor *)sysNavigationBarBackgroundColor
{
    return [UIColor colorWithRed:56/255.0 green:193/255.0 blue:255/255.0 alpha:1.0];
}
- (UIFont *)sysNavigationBarTitleFont
{
    return [UIFont boldSystemFontOfSize:17];
}

- (UIColor *)sysNavigationBarTitleColor
{
    return [UIColor whiteColor];
}

- (Class)sysOverlayViewClass
{
    return [DeepCustomPickerOverlayView class];
}

//发送图片按钮
- (GJCFAssetsPickerCommonStyleDescription *)sysFinishDoneBtDes
{
    GJCFAssetsPickerCommonStyleDescription *aStyleDes = [[GJCFAssetsPickerCommonStyleDescription alloc]init];
    aStyleDes.normalStateTitle = @"发送";
    aStyleDes.highlightStateTextColor = [UIColor whiteColor];
    aStyleDes.normalStateTextColor = [UIColor whiteColor];
    aStyleDes.font = [UIFont systemFontOfSize:15.0];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    aStyleDes.originPoint = CGPointMake(screenWidth-10-60,7);
    aStyleDes.frameSize = CGSizeMake(60, 30);
    
    return aStyleDes;
    
}

- (GJCFAssetsPickerCommonStyleDescription *)sysAlbumsNavigationBarDes
{
    GJCFAssetsPickerCommonStyleDescription *aStyle = [[GJCFAssetsPickerCommonStyleDescription alloc]init];
    aStyle.backgroundColor = [self sysNavigationBarBackgroundColor];
    aStyle.title = @"选择相册";
    aStyle.font = [self sysNavigationBarTitleFont];
    aStyle.titleColor = [self sysNavigationBarTitleColor];
    
    return aStyle;
}

- (GJCFAssetsPickerCommonStyleDescription *)sysPhotoNavigationBarDes
{
    GJCFAssetsPickerCommonStyleDescription *aStyle = [[GJCFAssetsPickerCommonStyleDescription alloc]init];
    aStyle.backgroundColor = [self sysNavigationBarBackgroundColor];
    aStyle.title = @"选择照片";
    aStyle.font = [self sysNavigationBarTitleFont];
    aStyle.titleColor = [self sysNavigationBarTitleColor];
    
    return aStyle;
}

- (GJCFAssetsPickerCommonStyleDescription *)sysPreviewNavigationBarDes
{
    GJCFAssetsPickerCommonStyleDescription *aStyle = [[GJCFAssetsPickerCommonStyleDescription alloc]init];
    aStyle.backgroundColor = [self sysNavigationBarBackgroundColor];
    aStyle.font = [self sysNavigationBarTitleFont];
    aStyle.titleColor = [self sysNavigationBarTitleColor];
    
    return aStyle;
}

- (GJCFAssetsPickerCommonStyleDescription *)sysCancelBtnDes
{
    GJCFAssetsPickerCommonStyleDescription *aStyle = [super sysCancelBtnDes];
    aStyle.font = [self sysNavigationBarTitleFont];
    
    
    return aStyle;
}


//预览按钮
- (GJCFAssetsPickerCommonStyleDescription *)sysPreviewBtnDes
{
    GJCFAssetsPickerCommonStyleDescription *aStyle = [super sysPreviewBtnDes];
    aStyle.font = [self sysButtonFont];
    aStyle.normalStateTextColor = [self sysNavigationBarBackgroundColor];
    aStyle.highlightStateTextColor=[self sysNavigationBarBackgroundColor];
    aStyle.originPoint = CGPointMake(0, 12);
    aStyle.frameSize = CGSizeMake(80, 22);
    return aStyle;
}

- (GJCFAssetsPickerCommonStyleDescription *)sysPreviewChangeSelectStateBtnDes
{
    GJCFAssetsPickerCommonStyleDescription *aStyle = [super sysPreviewChangeSelectStateBtnDes];
    aStyle.selectedStateImage = [UIImage imageNamed:@"GjAssetsPicker_image_selected_blue.png"];
    
    return aStyle;
}






@end
