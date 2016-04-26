//
//  MApprovalViewController.m
//  cosign
//
//  Created by mac on 15/10/26.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import "MApprovalViewController.h"
#import "NetRequestClass.h"
#import "ARemarksViewController.h"
#import "PopMenuTableView.h"
#import "KLCPopup.h"
#import "ApprovalStatusController.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/375.0
#define H(y) WinHeight*y/667.0

@interface MApprovalViewController ()<UITableViewDataSource,UITableViewDelegate,PopMenuDelegate,UIDocumentInteractionControllerDelegate>{
    
    BOOL isShow;
}
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)NSArray *fileArr;
@property(nonatomic,strong)UIDocumentInteractionController *docController;
@property(nonatomic,strong)KLCPopup* popup;
@end

@implementation MApprovalViewController{
    UIButton *rightBtn;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"待审批事项详细";
    [self setUpNavBar];
    [self customNavigationItem];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:231/255.0 green:235/255.0 blue:238/255.0 alpha:1.0];
    isShow = YES;
    self.tableView.bounces = NO;
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    self.tableView.tableHeaderView = view1;
    
    UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    firstLabel.text = self.aModel.title;
    firstLabel.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:firstLabel];
    
    
    UIView *backView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 400)];
    //底部的webview
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(8, 0, WinWidth-15,400)];
    self.webView.scrollView.bounces=NO;
    [backView addSubview:self.webView];
    
    self.tableView.tableFooterView = backView;
    
    //自定义分割线
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
    view3.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:223/255.0 alpha:1.0];
    [self.webView addSubview:view3];
    
    [self setUpBackBtn];
    [self requertData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
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
    
    self.navigationController.navigationBar.barTintColor = NAVBAR_SECOND_COLOR;
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    NSMutableDictionary *attrs=[[NSMutableDictionary alloc]init];
    attrs[NSForegroundColorAttributeName]=[UIColor whiteColor];
    attrs[NSFontAttributeName]=[UIFont boldSystemFontOfSize:19];
    [self.navigationController.navigationBar setTitleTextAttributes:attrs];
}

- (void)setUpBackBtn{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

//导航栏上的审批按钮
-(void)customNavigationItem{
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -10;
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ rightBtn setTitle:@"审批" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor hexFloatColor:@"a40410"] forState:UIControlStateNormal];
    [ rightBtn addTarget:self action:(@selector(goBack:))
        forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    rightBtn.frame = CGRectMake(0, 0, 50,20);
    UIBarButtonItem *rightBarBtn= [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[negativeSeperator,rightBarBtn];
    
    
}
//点击跳转到审批备注页面

-(void)goBack:(UIButton *)button{
    
    ARemarksViewController * ARemarksVC =[[ARemarksViewController alloc]init];
    ARemarksVC.appModel = self.aModel;
    [self.navigationController pushViewController:ARemarksVC animated:YES];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

//一组里有几行，判断有无附件
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(isShow &&![self.aModel.fileUrls isEqualToString:@""]){
        return 4;
    }
    else if (isShow &&[self.aModel.fileUrls isEqualToString:@""]){
        return 3;
        
    }
    return 0;
}

//头部间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 40;
    }
    return 0;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor =[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    if (section == 0) {
        UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0,self.view.frame.size.width/4, 40)];
        firstLabel.text = @"提交时间 :";
        firstLabel.font = [UIFont systemFontOfSize:12];
        firstLabel.textColor = [UIColor grayColor];
        [view  addSubview:firstLabel];
        
        UILabel *doteLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, self.view.frame.size.width/2, 40)];
        doteLabel.text = self.aModel.startDate ;
        doteLabel.font = [UIFont systemFontOfSize:12];
        doteLabel.textColor = [UIColor grayColor];
        [view addSubview:doteLabel];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-80, 0, 80, 40)];
        if (isShow) {
            [button setTitle:@"隐藏详情" forState:UIControlStateNormal];
        }
        else if (!isShow){
            [button setTitle:@"显示详情" forState:UIControlStateNormal];
        }
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.titleLabel.textAlignment =NSTextAlignmentRight
        ;
        [button setTitleColor:[UIColor hexFloatColor:@"003399"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
    }
    return view;
}

//返回每行cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0 &&indexPath.row == 0) {
        cell.textLabel.text =  @"申请人 :";
        cell.textLabel.textColor =  [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, self.view.frame.size.width-cell.textLabel.frame.size.width-40, 40)];
        firstLabel.text =self.aModel.starter;
        firstLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:firstLabel];
    }
    if (indexPath.section == 0 &&indexPath.row == 1) {
        cell.textLabel.text =  @"审批流程 :";
        cell.textLabel.textColor =  [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, W(200), 40)];
        firstLabel.text =self.aModel.checkers;
        firstLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:firstLabel];
    }
    if (indexPath.section == 0 &&indexPath.row == 2) {
        cell.textLabel.text =  @"抄       送 :";
        cell.textLabel.textColor =  [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        UILabel *secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, W(200), 40)];
        if ([self.aModel.readers isEqualToString:@""]) {
            secondLabel.text =@"无";
        }
        else {
            
            secondLabel.text =self.aModel.readers;
        }
        secondLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:secondLabel];
        
    }
    if (indexPath.section ==0 &&indexPath.row ==3) {
        if (![self.aModel.fileUrls isEqualToString:@""]) {
            cell.textLabel.text =  @"附件 :";
            cell.textLabel.textColor =  [UIColor grayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
            
            UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(60, 10, 24, 21)];
            imageview.contentMode =  UIViewContentModeCenter;
            imageview.image = [UIImage imageNamed:@"icon_status_attach.png"];
            [cell.contentView  addSubview:imageview];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 50, 20)];
            if (self.fileArr.count==0) {
                label.text=@"";
            }else{
                label.text = [NSString stringWithFormat:@"%li个",self.fileArr.count];
            }
            
            [cell.contentView addSubview:label];
            
        }
        else {
            
            cell.textLabel.text =  @"审批意见 :";
            cell.textLabel.textColor =  [UIColor grayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            
            
            UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, self.view.frame.size.width-cell.textLabel.frame.size.width-40, 40)];
            firstLabel.text =self.aModel.hqStatusName;
            firstLabel.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:firstLabel];
            
            
        }
        
    }
    
    
    
    return cell;
}

//点击按钮收回分组cell
-(void)open:(UIButton *)button{
    
    button.selected = !button.selected;
    
    isShow = !isShow;
    
    [self.tableView  reloadData];
}


//返回cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

//选中某行做某事
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"审批流程 :"]) {
        ApprovalStatusController *ApprovalS = [[ApprovalStatusController alloc]init];
        
        ApprovalS.apps =self.aModel;
        
        [self.navigationController pushViewController:ApprovalS animated:YES];
        
    }else if([cell.textLabel.text isEqualToString:@"附件 :"]){
        [self popMenuView];
    }
    
}

- (void)popMenuView{
    PopMenuTableView *view = [[PopMenuTableView alloc] initWithFrame:CGRectMake(0, 0, 300, self.fileArr.count*44+40)];
    view.menuDelegate=self;
    view.dataList = self.fileArr;
    self.popup = [KLCPopup popupWithContentView:view
                                       showType:KLCPopupShowTypeNone
                                    dismissType:KLCPopupDismissTypeNone
                                       maskType:KLCPopupMaskTypeNone
                       dismissOnBackgroundTouch:YES
                          dismissOnContentTouch:NO];
    
    
    self.popup.backgroundColor =[UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:0.5f];
    [self.popup show];
}

#pragma mark PopMenuDelegate
- (void)openFileWithIndex:(NSInteger)index{
    [self.popup dismiss:YES];
    
    [self downloadFileWithIndex:index];
    
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    
    return self;
    
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    
    return self.tableView;
    
}



- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    
    return  self.tableView.frame;
    
}

- (void)downloadFileWithIndex:(NSInteger)index{
    Account *account = [Account shareAccount];
    [account loadAccountFromSanbox];
    
    
    NSString *str = [NSString stringWithFormat:@"fileName=%@&userId=%@&password=%@",self.fileArr[index],account.userName,account.tempPwd];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:AttachedFileInterface];
    NSData *postData=[str dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]init];
    [request setURL:URL];
    [request setValue:@"true" forHTTPHeaderField:@"IsMobile"];
    [request setHTTPMethod:@"POST"];//设置请求的方法
    [request setHTTPBody:postData];//把请求参数放到请求体里面
    [request setTimeoutInterval:60];//设置请求超时的时间
    
    
    MBProgressHUD *hud =  [MBProgressHUD showMessage:@"正在加载中..."];
    hud.dimBackground=NO;
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [MBProgressHUD hideHUD];
        hud.hidden = YES;
        
        _docController = [UIDocumentInteractionController interactionControllerWithURL:filePath];
        _docController.delegate =self;
        
        CGRect navRect =self.navigationController.navigationBar.frame;
        
        navRect.size =CGSizeMake(1500.0f,40.0f);
        
        [_docController presentOptionsMenuFromRect:navRect inView:self.tableView animated:YES];
        
        NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
    
    
}



-(void)requertData{
    
    Account *account = [Account shareAccount];
    [account loadAccountFromSanbox];
    NSString *str= [NSString stringWithFormat:@"%li",self.aModel.id];
    
    NSDictionary *parameters=@{@"userId":account.userName,
                               @"password":account.tempPwd,
                               @"id":str};
    
    MBProgressHUD *hud =  [MBProgressHUD showMessage:@"正在加载中..."];
    hud.dimBackground=NO;
    
    [NetRequestClass NetRequestPOSTWithRequestURL:DetailInterface WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
        
        [MBProgressHUD hideHUD];
        hud.hidden = YES;

        NSDictionary *dict = returnValue[@"items"];
        ApplicationModel *model  = [ApplicationModel mj_objectWithKeyValues:dict];
        
        [self.webView loadHTMLString:model.contents baseURL:nil];
        
        
        NSArray *tempArr = [model.fileUrls componentsSeparatedByString:@"|"];
        
        self.fileArr  = tempArr;
        
        
        [self.tableView reloadData];
        
        
    } WithErrorCodeBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
    
}
@end



