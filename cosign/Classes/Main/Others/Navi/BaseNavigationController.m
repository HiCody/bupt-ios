//
//  BaseNavigationController.m
//  cosign
//
//  Created by mac on 15/10/28.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(void)initialize{
    
    UINavigationBar *naviBar=[UINavigationBar appearance];
    naviBar.translucent=YES;
    naviBar.barTintColor = NAVBAR_SECOND_COLOR;
    
    [naviBar setTintColor:[UIColor whiteColor]];
    
    NSMutableDictionary *attrs=[[NSMutableDictionary alloc]init];
    attrs[NSForegroundColorAttributeName]=[UIColor whiteColor];
    attrs[NSFontAttributeName]=[UIFont boldSystemFontOfSize:19];
    [naviBar setTitleTextAttributes:attrs];
    
  
    UIBarButtonItem *item=[UIBarButtonItem appearance];
    NSMutableDictionary *attrs1=[[NSMutableDictionary alloc]init];
    attrs1[NSForegroundColorAttributeName]=[UIColor whiteColor];
    attrs1[NSFontAttributeName]=[UIFont systemFontOfSize:16];
    [item setTitleTextAttributes:attrs1 forState:UIControlStateNormal];
    

}


@end
