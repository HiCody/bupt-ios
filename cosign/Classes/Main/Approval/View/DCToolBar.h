//
//  DCToolBar.h
//  jsce
//
//  Created by mac on 15/9/25.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCToolBar;
@protocol DCToolBarDelegate <NSObject>

-(void)willSelectIndex:(NSInteger)selIndex;
@end

@interface DCToolBar : UIView

- (void)addTabButtonWithImgName:(NSString *)name andImaSelName:(NSString *)selName andTitle:(NSString *)title;

@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,weak)id<DCToolBarDelegate>delegate;

@end