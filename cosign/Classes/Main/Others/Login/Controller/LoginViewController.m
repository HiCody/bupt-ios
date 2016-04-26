//
//  LoginViewController.m
//  cosign
//
//  Created by mac on 15/10/27.
//  Copyright © 2015年 YuanTu. All rights reserved.
//



#import "LoginViewController.h"
#import "NetRequestClass.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD+MJ.h"
#import "UserInfo.h"

#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *versionLable;
@property (weak, nonatomic) IBOutlet UIButton *checkbox;
@property (weak, nonatomic) IBOutlet UIButton *checkbox1;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIView *accountBackView;
@property (weak, nonatomic) IBOutlet UIView *pwdBackView;

@property (weak, nonatomic) IBOutlet UIButton *accountBtn;
@property (weak, nonatomic) IBOutlet UIButton *autoLoginBtn;

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [NSThread sleepForTimeInterval:1.0];
    [self setLayout];
    NSString *str=  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.versionLable.text = [NSString stringWithFormat:@"版本：V%@",str];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    CGFloat duration =[notification.userInfo [UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyBoardFrame =[notification.userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat transfomY=(keyBoardFrame.origin.y-self.view.frame.size.height)/3;
    // NSLog(@"%f",transfomY);
    [UIView animateWithDuration:duration animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, transfomY);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setLayout{
    
    self.nameTextField.delegate=self;
    self.passWordTextField.delegate=self;
    
    [self.nameTextField addTarget:self  action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passWordTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    
//从沙盒中加载保存的账户
    Account *account=[Account shareAccount];
    [account loadAccountFromSanbox];
    NSString *user=account.userName;
    self.nameTextField.text=user;
    
    NSString *passWord=account.passWord;
    self.passWordTextField.text=passWord;
    
    
    
    //记住密码在，自动登录的勾选
  
    [self.checkbox setImage:[UIImage imageNamed:@"checkbox_selected.png"] forState:UIControlStateSelected];
    self.checkbox.selected = account.savePwd.boolValue;
    

    [self.checkbox1 setImage:[UIImage imageNamed:@"checkbox_selected.png"] forState:UIControlStateSelected];
    self.checkbox1.selected = account.autoLogin.boolValue;
  
    
    //登陆按钮图片拉升
    self.loginBtn.backgroundColor=  [UIColor colorWithRed:0/255.0 green:189/255.0 blue:244/255.0 alpha:1.0];
    self.loginBtn.layer.borderWidth=1.0;
    self.loginBtn.layer.borderColor= [UIColor colorWithRed:0/255.0 green:189/255.0 blue:244/255.0 alpha:1.0].CGColor;
    self.loginBtn.layer.cornerRadius=4.0;
    
    
    
    
    
}

//限制输入的字数长度
- (void)textChange:(UITextField *)textField{
    
    
    //限制输入的字数长度
    if (textField == self.nameTextField) {
        if (textField.text.length > 15) {
            textField.text = [textField.text substringToIndex:15];
        }
    }
    
    if (textField == self.passWordTextField) {
        if (textField.text.length > 15) {
            textField.text = [textField.text substringToIndex:15];
        }
    }
}

//输入框为空时晃动
- (void)shakeActionWithTextField:(UITextField *)textField
{
    // 晃动次数
    static int numberOfShakes = 4;
    // 晃动幅度（相对于总宽度）
    static float vigourOfShake = 0.01f;
    // 晃动延续时常（秒）
    static float durationOfShake = 0.5f;
    
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // 方法一：绘制路径
    CGRect frame = textField.frame;
    // 创建路径
    CGMutablePathRef shakePath = CGPathCreateMutable();
    // 起始点
    CGPathMoveToPoint(shakePath, NULL, CGRectGetMidX(frame), CGRectGetMidY(frame));
    for (int index = 0; index < numberOfShakes; index++)
    {
        // 添加晃动路径 幅度由大变小
        CGPathAddLineToPoint(shakePath, NULL, CGRectGetMidX(frame) - frame.size.width * vigourOfShake*(1-(float)index/numberOfShakes),CGRectGetMidY(frame));
        CGPathAddLineToPoint(shakePath, NULL,  CGRectGetMidX(frame) + frame.size.width * vigourOfShake*(1-(float)index/numberOfShakes),CGRectGetMidY(frame));
    }
    // 闭合
    CGPathCloseSubpath(shakePath);
    shakeAnimation.path = shakePath;
    shakeAnimation.duration = durationOfShake;
    // 释放
    CFRelease(shakePath);
    
    [textField.layer addAnimation:shakeAnimation forKey:kCATransition];
}


//登陆按钮
- (IBAction)login:(id)sender {
    
    if (!self.nameTextField.text.length||!self.passWordTextField.text.length) {
        if (!self.nameTextField.text.length) {
            [self shakeActionWithTextField:self.nameTextField];
        }else{
            [self shakeActionWithTextField:self.passWordTextField];
        }
    }else{
        
        [self requestLoginWithName:self.nameTextField.text pwd:self.passWordTextField.text];
    }
    
    [self.passWordTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    
}

- (IBAction)changeIsSaveAccount:(id)sender {
    self.checkbox.selected = !self.checkbox.selected;
}
- (IBAction)changeIsAutoLogin:(id)sender {
    self.checkbox1.selected = !self.checkbox1.selected;
    if (self.checkbox1.selected) {
        self.checkbox.selected=YES;
    }
}

//记住密码及自动登录的标记判断
- (IBAction)checkboxClick:(id)sender {
    UIButton *btn = sender;
    btn.selected = !btn.selected;
    
//    //从沙盒中加载保存的账户
//    Account *account=[Account shareAccount];
//    [account loadAccountFromSanbox];
//    NSString *user=account.userName;
//    NSString *passWord=account.passWord;
//    self.nameTextField.text=user;
//    self.passWordTextField.text=passWord;
    
}



//登陆成功或失败
- (void)requestLoginWithName:(NSString*)name pwd:(NSString*)pwd{
    
    NSDictionary *parameters=@{@"userId":name,@"password":pwd};
    
    [MBProgressHUD showMessage:@"登录中..." toView:self.view];
    
    [NetRequestClass NetRequestPOSTWithRequestURL:LoginInterface WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dict=returnValue;
        if ([dict[@"status"] intValue] == 200) {
            Account *account=[Account shareAccount];
            if (self.nameTextField.text.length&&self.nameTextField.text.length) {
                account.userName=self.nameTextField.text;
                
                if (self.checkbox.selected) {
                    account.savePwd = @"YES";
                    account.passWord=self.passWordTextField.text;
                }else{
                    account.savePwd  =@"NO";
                    account.passWord=nil;
                }
                
                if (self.checkbox1.selected) {
                    account.autoLogin = @"YES";
                     account.passWord=self.passWordTextField.text;
                }else{
                    account.autoLogin  =@"NO";
                   
                }
                account.tempPwd = self.passWordTextField.text;
                [account saveAccountToSanbox];
            }
            
            NSDictionary *itemDict = dict[@"items"];
            
            UserInfo *user = [UserInfo shareUserInfo];
            
            user.userId =  itemDict[@"userId"];
            user.userName =  itemDict[@"userName"];
            user.userRoles =  itemDict[@"userRoles"];
            user.userRolesDisp =  itemDict[@"userRolesDisp"];
            user.stopped =  itemDict[@"stopped"];
            user.operateRoles = itemDict[@"operateRoles"];
            AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdelegate signIn];
        }
     
    } WithErrorCodeBlock:^(id errorCode) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"登陆失败" message:@"帐号或密码错误"delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    } WithFailureBlock:^{
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"登陆失败" message:@"请检查网络设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }];
}


//收回键盘的方法

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    [self.view endEditing:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}



@end
