//
//  ARemarksViewController.h
//  cosign
//
//  Created by mac on 15/10/28.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationModel.h"
#import "PlaceholderTextView.h"
@interface ARemarksViewController : UIViewController<UITextViewDelegate>


@property (nonatomic,retain)PlaceholderTextView *textView;

@property (nonatomic,strong)ApplicationModel *appModel;

@end
