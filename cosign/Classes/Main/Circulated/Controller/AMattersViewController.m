//
//  AMattersViewController.m
//  cosign
//
//  Created by mac on 15/11/25.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import "AMattersViewController.h"
#import "StateApprovalViewController.h"

#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/375.0
#define H(y) WinHeight*y/667.0


@interface AMattersViewController ()<UITableViewDelegate,UITableViewDataSource>

   
@end

@implementation AMattersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"待传阅的事项详细";
    self.view.backgroundColor = [UIColor whiteColor];
    self.bottomView.hidden =YES;
    
    Account *account = [Account shareAccount];
    [account loadAccountFromSanbox];
    NSString *str= [NSString stringWithFormat:@"%li",self.aModel.id];
    NSLog(@"%@",self.aModel.rid);
    self.parameters=@{@"userId":account.userName,
                      @"password":account.tempPwd,
                      @"id":str,
                      @"rid":self.aModel.rid};
    self.interfaceString = NeedReadDetaiInterface;
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configTableView{
    self.tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,WinWidth ,WinHeight)];
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
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
    [button setTitleColor:[UIColor hexFloatColor:@"003399"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:button];
    if (self.state==isShow1) {
        
        [button setTitle:@"隐藏" forState:UIControlStateNormal];
        UILabel *applicationLable = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame)+8, 80, 30)];
        applicationLable.text = @"申  请  人 :";
        //        applicationLable.textAlignment=NSTextAlignmentRight;
        applicationLable.textColor = [UIColor grayColor];
        applicationLable.font = [UIFont systemFontOfSize:14];
        [self.headView addSubview:applicationLable];
        
        UILabel *startLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(titleLabel.frame)+8, WinWidth-100, 30)];
        startLabel.text =self.aModel.starterName;
        startLabel.font = [UIFont systemFontOfSize:14];
        [self.headView addSubview:startLabel];
        
        UILabel *copyLable = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(applicationLable.frame), 80, 30)];
        copyLable.text  = @"传  阅  人 :";
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
        UILabel *processLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(copyLable.frame)+padding-30, 80, 30)];
        processLabel.text =@"流程类型  :";
        processLabel.textColor = [UIColor grayColor];
        processLabel.font = [UIFont systemFontOfSize:14];
        [self.headView addSubview:processLabel];
        
        UILabel *typeLabel =[[UILabel alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(copyLable.frame)+padding-30,WinWidth-100, 30)];
        typeLabel.text =self.aModel.hqTypeName;
        typeLabel.font = [UIFont systemFontOfSize:14];
        [self.headView addSubview:typeLabel];

        UILabel *dateLable = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(processLabel.frame), 80, 30)];
        dateLable.text=@"时        间 :";
        //        dateLable.textAlignment=NSTextAlignmentRight;
        dateLable.textColor = [UIColor grayColor];
        dateLable.font = [UIFont systemFontOfSize:14];
        [self.headView addSubview:dateLable];
        
        UILabel *doteLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(processLabel.frame),WinWidth-100, 30)];
        doteLabel.text = self.aModel.startDate ;
        doteLabel.font = [UIFont systemFontOfSize:12];
        doteLabel.textColor = [UIColor grayColor];
        [self.headView addSubview:doteLabel];
        
        if (![self.aModel.fileUrls isEqualToString:@""]) {
            UILabel *attachLable = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(dateLable.frame), 80, 30)];
            attachLable.text = @"附        件 :";
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
        
         CGSize nameSize =[self sizeWithText:self.aModel.starterName font:[UIFont systemFontOfSize:16.0] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        UILabel *applicationLable = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame)+8, nameSize.width, 30)];
        applicationLable.font = [UIFont systemFontOfSize:16.0];
        applicationLable.text = self.aModel.starterName;
        applicationLable.textColor = [UIColor colorWithRed:34/255.0 green:172/255.0  blue:57/255.0  alpha:1.0];
        [self.headView addSubview:applicationLable];
        
        if (![self.aModel.fileUrls isEqualToString:@""]){
            UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(applicationLable.frame)+4, CGRectGetMaxY(titleLabel.frame)+8, 20, 30)];
            imageview.contentMode =  UIViewContentModeCenter;
            imageview.image = [UIImage imageNamed:@"icon_status_attach.png"];
            [self.headView addSubview:imageview];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame)+4, CGRectGetMaxY(titleLabel.frame)+8, 40, 30)];
            if (self.fileArr.count==0) {
                label.text=@"";
            }else{
                label.text = [NSString stringWithFormat:@"%li",self.fileArr.count];
                
                label.font = [UIFont systemFontOfSize:14];
            }
            [self.headView  addSubview:label];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(applicationLable.frame)+4, CGRectGetMaxY(titleLabel.frame)+8, 70, 30)];
            [btn addTarget:self action:@selector(moveToBottom) forControlEvents:UIControlEventTouchUpInside];
            [self.headView  addSubview:btn];
        }
    }
    
    self.tableView.tableHeaderView = self.headView;
}


#pragma mark 审批流程
-(void)trueExpression:(UIButton *)button{
    
    StateApprovalViewController * StateApprovalVC = [[StateApprovalViewController alloc]init];
    
    StateApprovalVC.threeModel =self.aModel;
    
    [self.navigationController pushViewController:StateApprovalVC  animated:YES];
    
}




@end
