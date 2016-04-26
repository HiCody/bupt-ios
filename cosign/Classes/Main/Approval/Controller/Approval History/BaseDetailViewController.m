//
//  BaseDetailViewController.m
//  cosign
//
//  Created by mac on 15/11/26.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import "BaseDetailViewController.h"
#import "NetRequestClass.h"
#import "KLCPopup.h"
#import "DCToolBar.h"
#import "ApprovalStatusController.h"
#import "CommentModel.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/375.0
#define H(y) WinHeight*y/667.0

@interface BaseDetailViewController ()<UITableViewDataSource,UITableViewDelegate,DCToolBarDelegate,UIDocumentInteractionControllerDelegate,UIAlertViewDelegate>{

    BOOL isShow;
    
    BOOL isShows;
}

@property (nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)UIDocumentInteractionController *docController;
@property(nonatomic,strong)KLCPopup* popup;
@property(nonatomic,strong)UIButton *rightBtn;


@property(nonatomic,strong)DCToolBar *dcToolBar;
@property(nonatomic,strong)NSArray *toolSoucreArr; //保存工具栏里的选项

@property(nonatomic,strong)NSString *urlString;
@property(nonatomic,strong)UITextField *passedText;
@property(nonatomic,strong)UITextField *refusedText;
@property(nonatomic,strong)NSString *remarkStr;
@property(nonatomic,strong)NSMutableArray *commentArr;
@end

@implementation BaseDetailViewController

- (NSMutableArray *)commentArr{
    if (!_commentArr) {
        _commentArr =[[NSMutableArray alloc] init];
    }
    return _commentArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"待审批事项详细";
    self.state = isShow;
    self.fileArr = [[NSArray alloc] init];
    
    isShow = NO;
    isShows=NO;
    
//    [self setUpNavBar];
    [self setUpBackBtn];
    [self customNavigationItem];
    
    [self configTableView];
    [self configHeadView];
    [self configToolBar];
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

//导航栏上的按钮
-(void)customNavigationItem{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -10;
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ self.rightBtn setTitle:@"流程" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:(@selector(trueExpression:))
            forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    self.rightBtn.frame = CGRectMake(0, 0, 50,20);
    UIBarButtonItem *rightBarBtn= [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItems = @[negativeSeperator,rightBarBtn];
    
    
}

#pragma mark 审批流程
-(void)trueExpression:(UIButton *)button{
    
    ApprovalStatusController *AStatusVC = [[ApprovalStatusController alloc]init];
    
    AStatusVC.apps =self.aModel;
    
    [self.navigationController pushViewController:AStatusVC  animated:YES];
    
}
//添加底部工具栏
- (void)configToolBar{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, WinWidth, 50)];
    
    UIImageView *imgView=[[UIImageView alloc] initWithFrame: self.bottomView.bounds];
    imgView.image =[UIImage imageNamed:@"toolbar_bg"];
    [ self.bottomView addSubview:imgView];
    
    self.dcToolBar = [[DCToolBar alloc] init];
    
    self.dcToolBar.frame = CGRectMake(0, 0, WinWidth, 50);
    
    self.dcToolBar.backgroundColor=[UIColor clearColor];
    
    self.dcToolBar.delegate = self;
    [self.dcToolBar addTabButtonWithImgName:@"singn_yes" andImaSelName:@"singn_yes" andTitle:@"同意"];
    [self.dcToolBar addTabButtonWithImgName:@"singn_no" andImaSelName:@"singn_no" andTitle:@"拒绝"];
    
    // if (self.toolSoucreArr.count==3) {
    [self.dcToolBar addTabButtonWithImgName:@"singn_transfer" andImaSelName:@"singn_transfer" andTitle:@"转交上级"];
    //}
    
    [ self.bottomView addSubview:self.dcToolBar];
    for (int i=0; i<2; i++) {
        UIView *lineView= [[UIView alloc] initWithFrame:CGRectMake((i+1)*WinWidth/3, (self.dcToolBar.frame.size.height-20)/2.0, 0.5, 20)];
        lineView.backgroundColor=[UIColor lightGrayColor];
        [ self.bottomView addSubview:lineView];
    }
    
    [self.view addSubview:self.bottomView];
}

- (void)willSelectIndex:(NSInteger)selIndex{
    if (selIndex==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"备注(非必填)" message:@" " delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alert.tag = 100;
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        
        alert.delegate = self;
        
        [alert show];
        
    }else if (selIndex==1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"备注(必填)" message:@" " delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alert.tag = 101;
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        
        alert.delegate = self;
        
        [alert show];
    }else{
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==100) {
        if (buttonIndex==1) {
            UITextField *field = [alertView textFieldAtIndex:0];
            self.remarkStr = field.text;
            [self requestDataWithIndex:1];
            
        }
        
    }
    else if (alertView.tag==101){
        if (buttonIndex==1) {
            UITextField *field = [alertView textFieldAtIndex:0];
            if (!field.text.length) {
                
                [self shakeActionWithTextField:self.refusedText];
                
            }else{
                
                self.remarkStr =field.text;
                [self requestDataWithIndex:0];
                
            }
            
            
            
            
        }
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView{
    if (alertView.tag==101) {
        UITextField *field = [alertView textFieldAtIndex:0];
        if (!field.text.length) {
            return NO;
        }
        return YES;
    }else{
        return YES;
    }
}



- (void)configTableView{
    self.tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,WinWidth ,WinHeight-50)];
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
//        self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 30)];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
   
    [self.view addSubview:self.tableView];
}

//获取文字处理后的尺寸
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (UIImage *)colorImageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)configHeadView{
    self.headView = [[UIView alloc] init];
    CGSize size=[self sizeWithText:self.aModel.title font:[UIFont boldSystemFontOfSize:18.0] maxSize:CGSizeMake(WinWidth-30, MAXFLOAT)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 4,WinWidth-20, size.height)];
    titleLabel.numberOfLines =0;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.text = self.aModel.title;
    titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:18];
    [self.headView addSubview:titleLabel];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-80, CGRectGetMaxY(titleLabel.frame)+8, 80, 30)];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.titleLabel.textAlignment =NSTextAlignmentRight
    ;
    button.adjustsImageWhenHighlighted = YES;
//      [button setBackgroundImage: forState:UIControlStateNormal];
        [button setBackgroundImage:[self colorImageWithColor:[UIColor redColor]] forState:UIControlStateHighlighted];
     button.adjustsImageWhenHighlighted = NO;
//    button.showsTouchWhenHighlighted = NO;
    
    [button setTitleColor:[UIColor hexFloatColor:@"003399"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:button];
    if (self.state==isShow1) {
        
        [button setTitle:@"隐藏" forState:UIControlStateNormal];
        UILabel *applicationLable = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame)+8, 60, 30)];
        applicationLable.text = @"申请人 :";
        //applicationLable.textAlignment=NSTextAlignmentRight;
        applicationLable.textColor = [UIColor grayColor];
        applicationLable.font = [UIFont systemFontOfSize:14];
        [self.headView addSubview:applicationLable];
        
        UILabel *startLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(titleLabel.frame)+8, WinWidth-100, 30)];
        startLabel.text =self.aModel.starter;
        startLabel.font = [UIFont systemFontOfSize:14];
        [self.headView addSubview:startLabel];
        
        
        UILabel *copyLable = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(applicationLable.frame), 60, 30)];
        copyLable.text  = @"传阅人 :";
        //        copyLable.textAlignment=NSTextAlignmentRight;
        copyLable.textColor = [UIColor grayColor];
        copyLable.font = [UIFont systemFontOfSize:14];
        [self.headView addSubview:copyLable];
        
        UILabel *secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(applicationLable.frame), WinWidth-100, 30)];
        CGFloat padding=0;
        if ([self.aModel.readers isEqualToString:@""]) {
            secondLabel.text =@"无";
            padding=30;
            secondLabel.font = [UIFont systemFontOfSize:14];
            [self.headView addSubview:secondLabel];
        }
        else {
            NSArray *readerArr=[self.aModel.readers componentsSeparatedByString:@","];
            for (int i=0; i<readerArr.count; i++) {
                UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(applicationLable.frame)+30*i,  WinWidth-100,  30)];
                lable.text =readerArr[i];
                lable.font = [UIFont systemFontOfSize:14];
                [self.headView addSubview:lable];
                padding+=30;
            }
            //secondLabel.text =self.aModel.readers;
        }
        
        UILabel *dateLable = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(copyLable.frame)+padding-30, 60, 30)];
        dateLable.text=@"时间 :";
        //        dateLable.textAlignment=NSTextAlignmentRight;
        dateLable.textColor = [UIColor grayColor];
        dateLable.font = [UIFont systemFontOfSize:14];
        [self.headView addSubview:dateLable];
        
        UILabel *doteLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(copyLable.frame)+padding-30,WinWidth-100, 30)];
        doteLabel.text = self.aModel.startDate ;
        doteLabel.font = [UIFont systemFontOfSize:12];
        doteLabel.textColor = [UIColor grayColor];
        [self.headView addSubview:doteLabel];
        
        if (![self.aModel.fileUrls isEqualToString:@""]) {
            UILabel *attachLable = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(dateLable.frame), 60, 30)];
            attachLable.text = @"附件 :";
            attachLable.textColor = [UIColor grayColor];
            //            attachLable.textAlignment=NSTextAlignmentRight;
            attachLable.font =[UIFont systemFontOfSize:14];
            [self.headView addSubview:attachLable];
            
            UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(dateLable.frame), 20, 30)];
            imageview.contentMode =  UIViewContentModeCenter;
            imageview.image = [UIImage imageNamed:@"icon_status_attach.png"];
            [self.headView addSubview:imageview];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(120, CGRectGetMaxY(dateLable.frame), 40, 30)];
            if (self.fileArr.count==0) {
                label.text=@"";
            }else{
                label.text = [NSString stringWithFormat:@"%li个",self.fileArr.count];
                
                label.font =[UIFont systemFontOfSize:14];
            }
            [self.headView  addSubview:label];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(95, CGRectGetMaxY(dateLable.frame), 70, 30)];
            [btn addTarget:self action:@selector(moveToBottom) forControlEvents:UIControlEventTouchUpInside];
            [self.headView  addSubview:btn];
            
            //自定义分割线
            UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(attachLable.frame)-0.5, self.view.frame.size.width, 0.5)];
            headView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:223/255.0 alpha:1.0];
            [self.headView addSubview:headView];
            
            self.headView.frame = CGRectMake(0, 0, WinWidth, CGRectGetMaxY(headView.frame));
            
        }
        else{
            //自定义分割线
            UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(dateLable.frame)-0.5, self.view.frame.size.width, 0.5)];
            headView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:223/255.0 alpha:1.0];
            [self.headView addSubview:headView];
            
            self.headView.frame = CGRectMake(0, 0, WinWidth, CGRectGetMaxY(headView.frame));
        }
        
    }else{
        self.headView.frame = CGRectMake(0, 0, WinWidth, CGRectGetMaxY(titleLabel.frame)+31);
        //自定义分割线
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(titleLabel.frame)+30+8, self.view.frame.size.width, 0.5)];
        headView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:223/255.0 alpha:1.0];
        [self.headView addSubview:headView];
        
        [button setTitle:@"显示" forState:UIControlStateNormal];
        UILabel *applicationLable = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame)+8, 60, 30)];
        applicationLable.text = self.aModel.starter;
        applicationLable.textColor = [UIColor colorWithRed:34/255.0 green:172/255.0  blue:57/255.0  alpha:1.0];
        [self.headView addSubview:applicationLable];
        
        if (![self.aModel.fileUrls isEqualToString:@""]){
            UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(95, CGRectGetMaxY(titleLabel.frame)+8, 20, 30)];
            imageview.contentMode =  UIViewContentModeCenter;
            imageview.image = [UIImage imageNamed:@"icon_status_attach.png"];
            [self.headView addSubview:imageview];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(115, CGRectGetMaxY(titleLabel.frame)+8, 40, 30)];
            if (self.fileArr.count==0) {
                label.text=@"";
            }else{
                label.text = [NSString stringWithFormat:@"%li",self.fileArr.count];
                
                label.font = [UIFont systemFontOfSize:14];
            }
            [self.headView  addSubview:label];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(95, CGRectGetMaxY(titleLabel.frame)+8, 70, 30)];
            [btn addTarget:self action:@selector(moveToBottom) forControlEvents:UIControlEventTouchUpInside];
            [self.headView  addSubview:btn];
            
        }
    }
    
    self.tableView.tableHeaderView = self.headView;
    
}

- (void)moveToBottom{
    if (self.fileArr.count&&isShows) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.fileArr.count-1 inSection:2] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }else{

        isShows= YES;
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.fileArr.count-1 inSection:2] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }
    
}

- (void)open:(UIButton *)btn{
    btn.selected =!btn.selected;
    self.state = !self.state;
    [self configHeadView];
    [self.tableView reloadData];
}


#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1) {
        if (isShow&& self.commentArr.count) {
            return self.commentArr.count;
        }
        if (isShow &&self.commentArr.count ==0) {
            return 1;
        }
        else {
            return 0;
        }
        
    }else if(section==2){
        if (isShows&& self.fileArr.count==0) {
            return 1;
        }
        else if(isShows &&self.fileArr.count){
            return self.fileArr.count;
        }
        else{
            return 0;
        }
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        UIView *backView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 300)];
        //底部的webview
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(8, 0, WinWidth-15,300)];
        self.webView.scrollView.bounces=NO;
        [backView addSubview:self.webView];
        [cell.contentView addSubview:backView];
        
        [self.webView loadHTMLString:self.urlString baseURL:nil];
    }else if(indexPath.section==2){
        if (self.fileArr.count) {
            NSString *tempStr=[[self.fileArr[indexPath.row] pathExtension] lowercaseString];
            NSString *imgName;
            if ([tempStr isEqualToString:@"jpg"]||[tempStr isEqualToString:@"png"]||[tempStr isEqualToString:@"jpeg"]) {
                imgName=@"attachment_img_file_pic";
            }else if([tempStr isEqualToString:@"pdf"]){
                imgName=@"attachment_img_file_pdf";
            }else if([tempStr isEqualToString:@"doc"]||[tempStr isEqualToString:@"docx"]){
                imgName=@"attachment_img_file_doc";
            }else if([tempStr isEqualToString:@"xls"]||[tempStr isEqualToString:@"xlsx"]){
                imgName=@"attachment_img_file_xls";
            }else if([tempStr isEqualToString:@"ppt"]||[tempStr isEqualToString:@"pptx"]){
                imgName=@"attachment_img_file_ppt";
            }else if([tempStr isEqualToString:@"rar"]){
                imgName=@"attachment_img_file_rar";
            }else if([tempStr isEqualToString:@"zip"]||[tempStr isEqualToString:@"7z"]){
                imgName=@"attachment_img_file_zip";
            }
            cell.imageView.image = [UIImage imageNamed:imgName];
            cell.textLabel.text = self.fileArr[indexPath.row];
            cell.textLabel.font=[UIFont systemFontOfSize:14.0];
            cell.textLabel.lineBreakMode=NSLineBreakByTruncatingMiddle;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }else{
            cell.textLabel.text = @"暂无附件";
            cell.textLabel.textColor =[UIColor grayColor];
        }
    }
    else if(indexPath.section==1){
        if (self.commentArr.count) {
            CommentModel *commnet =self.commentArr[indexPath.row];
            UILabel *startLabel = [[UILabel alloc] init];
            startLabel.text = commnet.userName;
            startLabel.textAlignment = NSTextAlignmentRight;
            startLabel.font = [UIFont systemFontOfSize:15.0];
            CGSize firstSize = [self sizeWithText:startLabel.text font: startLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            startLabel.frame  =  CGRectMake(15, 5, firstSize.width, firstSize.height);
            [cell.contentView addSubview:startLabel];
         
            UILabel *detailLable=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(startLabel.frame), WinWidth-20, 60-CGRectGetMaxY(startLabel.frame))];
            NSString *str=[NSString stringWithFormat:@"审批意见：%@",[self filterHTML1:commnet.hqComment]];
            detailLable.numberOfLines =3;
            detailLable.font =[UIFont systemFontOfSize:13.0];
            detailLable.text=str;
            [cell.contentView addSubview:detailLable];
            
            //日期时间
            UILabel *fourthLabel = [[UILabel alloc] init];
            fourthLabel.text = commnet.hqDate;
            fourthLabel.textAlignment = NSTextAlignmentRight;
            fourthLabel.font = [UIFont systemFontOfSize:10];
            fourthLabel.textColor = [UIColor grayColor];
            CGSize fourthSize = [self sizeWithText:fourthLabel.text font: fourthLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            fourthLabel.frame  =  CGRectMake(WinWidth-fourthSize.width-5,startLabel.frame.origin.y, fourthSize.width, fourthSize.height);
            [cell.contentView addSubview:fourthLabel];
            
        }else{
            cell.textLabel.text = @"暂无审批意见";
            cell.textLabel.textColor =[UIColor grayColor];
        }
        UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(0,59, WinWidth, 0.5)];
        lineView.backgroundColor =[UIColor colorWithRed:220/255.0 green:220/255.0 blue:223/255.0 alpha:1.0];
        [cell.contentView addSubview:lineView];

    }
    
    return cell;
}

- (NSString *)filterHTML1:(NSString *)html{
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n"
                                                                                    options:0
                                                                                      error:nil];
    
    html=[regularExpretion stringByReplacingMatchesInString:html options:NSMatchingReportProgress range:NSMakeRange(0, html.length) withTemplate:@"-"];//替换所有html和换行匹配元素为"-"
    
    regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"-{1,}" options:0 error:nil] ;
    html=[regularExpretion stringByReplacingMatchesInString:html options:NSMatchingReportProgress range:NSMakeRange(0, html.length) withTemplate:@"-"];//把多个"-"匹配为一个"-"
    
    //根据"-"分割到数组
    NSArray *arr=[NSArray array];
    html=[NSString stringWithString:html];
    arr =  [html componentsSeparatedByString:@"-"];
    NSMutableArray *marr=[NSMutableArray arrayWithArray:arr];
    [marr removeObject:@""];
    
    NSString *str = [marr componentsJoinedByString:@","];
    
    
    return  str;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section!=0) {
        return 40;
    }
    return 0;
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor =[UIColor whiteColor];
    
    if (section == 1) {
        UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0,self.view.frame.size.width/4, 40)];
        firstLabel.text = @"审批意见:";
        firstLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:16];
        [view  addSubview:firstLabel];
        
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-80, 0, 80, 40)];
        if (isShow) {
            [button setTitle:@"隐藏" forState:UIControlStateNormal];
        }
        else if (!isShow){
            [button setTitle:@"显示" forState:UIControlStateNormal];
        }
        button.tag=100;
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.titleLabel.textAlignment =NSTextAlignmentRight
        ;
        [button setTitleColor:[UIColor hexFloatColor:@"003399"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(opens:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        //顶部的线
        UIView *linesView =[[UIView alloc]initWithFrame:CGRectMake(0,1, WinWidth, 0.5)];
        linesView.backgroundColor =[UIColor colorWithRed:220/255.0 green:220/255.0 blue:223/255.0 alpha:1.0];
        [view addSubview:linesView];
        
        UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(0,39, WinWidth, 0.5)];
        lineView.backgroundColor =[UIColor colorWithRed:220/255.0 green:220/255.0 blue:223/255.0 alpha:1.0];
        [view addSubview:lineView];

    }
    if (section == 2) {
        UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0,self.view.frame.size.width/4, 40)];
        firstLabel.text = @"附件:";
        firstLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:16];
        [view  addSubview:firstLabel];
        
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-80, 0, 80, 40)];
        if (isShows) {
            [button setTitle:@"隐藏" forState:UIControlStateNormal];
        }
        else if (!isShows){
            [button setTitle:@"显示" forState:UIControlStateNormal];
        }
        button.tag=101;
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.titleLabel.textAlignment =NSTextAlignmentRight
        ;
        [button setTitleColor:[UIColor hexFloatColor:@"003399"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(opens:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(0,39, WinWidth, 0.5)];
        lineView.backgroundColor =[UIColor colorWithRed:220/255.0 green:220/255.0 blue:223/255.0 alpha:1.0];
        [view addSubview:lineView];

    }
    return view;
}

//点击按钮收回分组cell
-(void)opens:(UIButton *)button{
    
    if (button.tag ==100){
        //        button.selected = !button.selected;
        isShow = !isShow;
        [self.tableView reloadData];
    }
    if (button.tag ==101) {
        //     button.selected = !button.selected;
        
        isShows = !isShows;
        [self.tableView reloadData];
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 300;
    }else if(indexPath.section==1){
        
        return 60;
    }else{
        return 60;
    }
    
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
        if (self.fileArr.count) {
            
            [self downloadFileWithIndex:indexPath.row];
            
        }
    }
    
}


#pragma mark UIDocumentInteractionController
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

-(void)requestData{
    
    
    
    MBProgressHUD *hud =  [MBProgressHUD showMessage:@"正在加载中..."];
    hud.dimBackground=NO;
    
    [NetRequestClass NetRequestPOSTWithRequestURL:self.interfaceString WithParameter:self.parameters WithReturnValeuBlock:^(id returnValue) {
        
        [MBProgressHUD hideHUD];
        hud.hidden = YES;
        
        NSDictionary *dict = returnValue[@"items"];
        ApplicationModel *model  = [ApplicationModel mj_objectWithKeyValues:dict];
        self.urlString =model.contents;
        self.aModel.userName = model.userName;
        [self.webView loadHTMLString:model.contents baseURL:nil];
        
        
        
        if (![model.fileUrls isEqualToString:@""]) {
            NSArray *tempArr = [model.fileUrls componentsSeparatedByString:@"|"];
            self.fileArr  = tempArr;
        }
        

        [self getCheckersRequest];
        
        
    } WithErrorCodeBlock:^(id errorCode) {
        
        [MBProgressHUD hideHUD];
        hud.hidden = YES;
        [MBProgressHUD showError:@"请求错误"];
        
    } WithFailureBlock:^{
        
        [MBProgressHUD hideHUD];
        hud.hidden = YES;
        [MBProgressHUD showError:@"请求错误"];
        
        
    }];
    
}

-(void)requestDataWithIndex:(NSInteger)integer{
    //字段pass 1代表通过 0代表不通过
    [self.view endEditing:YES];
    Account *account = [Account shareAccount];
    [account loadAccountFromSanbox];
    
    NSDictionary *parameters=@{@"userId":account.userName,
                               @"password":account.tempPwd,
                               @"id":[NSString stringWithFormat:@"%li",self.aModel.id],
                               @"comment":self.remarkStr,
                               @"pass":[NSString stringWithFormat:@"%li",integer],
                               @"hid":self.aModel.hid
                               };
    MBProgressHUD *hud =  [MBProgressHUD showMessage:@"正在加载中..."];
    hud.dimBackground=NO;
    
    [NetRequestClass NetRequestPOSTWithRequestURL:ApproveInterface WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
        
        [MBProgressHUD hideHUD];
        hud.hidden = YES;
        
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

- (void)getCheckersRequest{
    Account *account = [Account shareAccount];
    [account loadAccountFromSanbox];
    NSString *str= [NSString stringWithFormat:@"%li",(long)self.aModel.id];
    NSDictionary *parameters = @{@"userId":account.userName,
                                 @"password":account.tempPwd,
                                 @"platform":@"2",
                                 @"id":str
                                 };
    [NetRequestClass NetRequestPOSTWithRequestURL:kGetCheckersInterface WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
        NSDictionary *dict = returnValue;
        
        NSArray *tempArr=[CommentModel mj_objectArrayWithKeyValuesArray:dict[@"items"]];
        
        for (CommentModel *comment in tempArr) {
            if (comment.hqComment.length) {
                [self.commentArr addObject:comment];
            }
            NSLog(@"%@",self.commentArr);
        }
        
        [self configHeadView];
        
        [self.tableView reloadData];
        
    } WithErrorCodeBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
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



@end
