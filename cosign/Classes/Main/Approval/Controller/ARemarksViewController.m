//
//  ARemarksViewController.m
//  cosign
//
//  Created by mac on 15/10/28.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import "ARemarksViewController.h"
#import "NetRequestClass.h"
#import "MBProgressHUD+MJ.h"
#import "MspendingViewController.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0
@interface ARemarksViewController ()<UIAlertViewDelegate>
@property(nonatomic,strong)UILabel *statusLable;
@end

@implementation ARemarksViewController{
   
    UIButton *rightBtn;
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"待审批事项详细";
    self.view.backgroundColor = NAVBAR_COLOR;
    [self customNavigationItem];
    
    [self setUpView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)setUpView
{
    self.textView = [[PlaceholderTextView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 300)];
    self.textView.delegate=self;
    self.textView.font = [UIFont systemFontOfSize:16.0];
    self.textView.placeholder = @"请输入审批意见";
    self.textView.placeholderFont = [UIFont systemFontOfSize:16.0];
    [self.view addSubview:self.textView];
    
    _statusLable = [[UILabel alloc] init];
    _statusLable.text = [NSString stringWithFormat:@"0/100"];
    _statusLable.textAlignment =NSTextAlignmentRight;
    _statusLable.font = [UIFont systemFontOfSize:15.0];
    _statusLable.frame = CGRectMake(0,200, WinWidth-10, 16.0);
    _statusLable.textColor = [UIColor blackColor];
    [self.textView addSubview:_statusLable];
}

//导航栏上的审批按钮
-(void)customNavigationItem{
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -15;

    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ rightBtn setTitle:@"审批" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ rightBtn addTarget:self action:(@selector(ture:))
        forControlEvents:UIControlEventTouchUpInside];
 
    rightBtn.frame = CGRectMake(325, 0, 50, 20);
    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc] initWithCustomView: rightBtn];
    self.navigationItem.rightBarButtonItems = @[negativeSeperator,rightBarBtn];

}
-(void)ture:(UIButton *)button{

    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"审批" message:@"是否通过审批" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"通过",@"不通过", nil];
  
    [alertView show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
   if(buttonIndex==1){
       [self.textView resignFirstResponder];
       [self requestDataWithIndex:buttonIndex];
       
   }else if(buttonIndex==2){
       [self.textView resignFirstResponder];
       [self requestDataWithIndex:0];
   }

    
}

-(void)requestDataWithIndex:(NSInteger)integer{
//字段pass 1代表通过 0代表不通过
   
    Account *account = [Account shareAccount];
    [account loadAccountFromSanbox];
    if (self.textView.text.length ==0) {
        self.textView.text=@"";
    }
  
    NSDictionary *parameters=@{@"userId":account.userName,@"password":account.tempPwd,@"id":[NSString stringWithFormat:@"%li",self.appModel.id],@"comment":self.textView.text,@"pass":[NSString stringWithFormat:@"%li",integer],@"hid":self.appModel.hid};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [NetRequestClass NetRequestPOSTWithRequestURL:ApproveInterface WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
       
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dict = returnValue;
       
        [MBProgressHUD showSuccess:dict[@"msg"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MspendingRefresh" object:@YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"homeViewRefresh"  object:@YES];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        
    } WithErrorCodeBlock:^(id errorCode) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [MBProgressHUD showError:@"审批失败 "];
    } WithFailureBlock:^{
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"审批失败 "];
    }];
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger number = [textView.text length];
    if (number > 100) {
        
        textView.text = [textView.text substringToIndex:100];
        [textView resignFirstResponder];
    
        number = 100;
    }
    self.statusLable.text = [NSString stringWithFormat:@"%ld/100",number];
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
