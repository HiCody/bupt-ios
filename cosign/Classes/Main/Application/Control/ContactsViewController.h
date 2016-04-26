//
//  ContactsViewController.h
//  cosign
//
//  Created by mac on 15/11/11.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsTableView.h"
@protocol ContactsDelegate <NSObject>

- (void)changeTitle:(NSString *)title andUserId:(NSString *)userId;

- (void)contactsPassData:(NSArray *)arr;

@end

@interface ContactsViewController : UIViewController
@property(nonatomic,strong)ContactsTableView *contactsTableView;
/** 代理对象 */
@property (weak, nonatomic) id<ContactsDelegate>ContactsDelegate;

@property(nonatomic,copy)NSArray *contactsArr;
@end
