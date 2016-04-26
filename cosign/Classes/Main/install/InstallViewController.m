//
//  InstallViewController.m
//  cosign
//
//  Created by mac on 15/10/13.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import "InstallViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "AppDelegate.h"


#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/375.0
#define H(y) WinHeight*y/667.0

@interface InstallViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation InstallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"网上会签系统";
    
    [self subitView];
    
    [self addFooterButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setUpNavBar];
}


- (void)setUpNavBar{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [NAVBAR_SECOND_COLOR CGColor]);
    CGContextFillRect(context, rect);
    //       UIImage *imge = [UIImage imageNamed:@"Login_back"];
    
    UIImage *imge = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:imge forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    NSMutableDictionary *attrs=[[NSMutableDictionary alloc]init];
    attrs[NSForegroundColorAttributeName]=[UIColor whiteColor];
    attrs[NSFontAttributeName]=[UIFont boldSystemFontOfSize:19];
    [self.navigationController.navigationBar setTitleTextAttributes:attrs];
}

-(void)subitView{
   
    self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    [self.view addSubview:self.tableView];


}
//一共几组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

//一组有几行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  2;
    
}

//设置section头部间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
    
        return 10;
    }
    return 1
    
    ;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //1,定义一个共同的标识
    static NSString *ID = @"cell";
    //2,从缓存中取出可循环利用的cell
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ID];
    //3,如果缓存中没有可利用的cell，新建一个。
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.section ==0 )
         if(indexPath.row == 0){
             
        cell.textLabel.text = @"自动登录";
        
        UISwitch* mySwitch = [[ UISwitch alloc]init];

             
        Account *account = [Account shareAccount];
        [account loadAccountFromSanbox];

             
        [ mySwitch setOn:account.autoLogin.boolValue animated:YES];
        [ mySwitch addTarget: self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
             
        cell.accessoryView = mySwitch;
        
    }
    if (indexPath.section == 0)
        if (indexPath.row == 1) {
            
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WinWidth, 55)];
        label.text = @"清除缓存数据";
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        
            
            
    }
    
    return cell;
    
    
    
}
//返回每行cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==1) {
        NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *str = [NSString stringWithFormat:@"缓存大小为%.1fM.确定需要清理缓存吗?", [self folderSizeAtPath:document]];
        UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

#pragma  mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
       NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *str = [NSString stringWithFormat:@"缓存已清除%.1fM", [self folderSizeAtPath:document]];
        NSLog(@"%@",str);
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:document];
        for (NSString *p in files) {
            NSError *error;
            NSString *Path = [document stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:Path]) {
                [[NSFileManager defaultManager] removeItemAtPath:Path error:&error];
            }
        }
        [MBProgressHUD showSuccess:@"清理成功"];
        
    }
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}



//使cell的下划线顶头，沾满整个屏幕宽
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//点击开关的事件
- (void) switchValueChanged:(id)sender{
    
    UISwitch *switchView = (UISwitch *)sender;
    
    Account *account = [Account shareAccount];
    [account loadAccountFromSanbox];
    if (switchView.isOn) {
       
        account.autoLogin=@"YES";
        account.savePwd = @"YES";
        account.passWord = account.tempPwd;
    }
    else {
        account.autoLogin=@"NO";
        account.savePwd = @"NO";
        account.passWord = nil;
    }
    [account saveAccountToSanbox];

   
    
}

//底部的退出按钮
-(void)addFooterButton{
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginBtn setTitle:@"退出" forState:UIControlStateNormal];
    
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 10.0;
    loginBtn.frame =  CGRectMake(20, 160, self.view.frame.size.width-40, 40);
    
    loginBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:189/255.0 blue:244/255.0 alpha:1.0];
    
    [loginBtn addTarget:self action:@selector(ending:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView addSubview:loginBtn];
}

//点击退出按钮的事件
-(void)ending:(UIButton *)button{
    
    UIActionSheet *actioSheet = [[UIActionSheet alloc]initWithTitle:@"确定要退出当前的账号" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定退出"otherButtonTitles: nil];
    [actioSheet showInView:self.view];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    if (buttonIndex == 0) {
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdelegate signOut];
        
        }
    
    
}





@end
