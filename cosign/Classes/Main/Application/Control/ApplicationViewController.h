//
//  ApplicationViewController.h
//  cosign
//
//  Created by steve on 15/10/12.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSInteger {
    
    kCameraMoveDirectionNone,
    
    kCameraMoveDirectionUp,
    
    kCameraMoveDirectionDown,
    
    kCameraMoveDirectionRight,
    
    kCameraMoveDirectionLeft
    
} CameraMoveDirection ;
@interface ApplicationViewController : UIViewController{
    CGRect _rect;//保存当前物理屏幕大小
}

@end

