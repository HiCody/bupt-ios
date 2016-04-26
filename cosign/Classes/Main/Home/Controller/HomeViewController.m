//
//  HomeViewController.m
//  cosign
//
//  Created by steve on 15/10/12.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import "HomeViewController.h"
#import "ApplicationViewController.h"
#import "InstallViewController.h"
#import "MspendingViewController.h"
#import "CirculatedViewController.h"
#import "NetRequestClass.h"
#import "JSBadgeView.h"
#import "applicationModel.h"
#import "APService.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UserInfo.h"
#import "HomeBadgeModel.h"
#import <TSMessage.h>
#import <TSMessageView.h>
#import <AFDropdownNotification.h>
#import "ZMYVersionNotes.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/375.0
#define H(y) WinHeight*y/667.0


@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSString *url;
}

@property (nonatomic ,strong)NSArray *datalist;
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"网上会签系统";
  //[self setUpNavBar];
    [self configureJPush];
    
    [self customNavigationItem];
    
    [self subitTableView];
    
    [self requestData];
    
    [self updateVersion];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:HomeViewRefresh object:nil];
    
}

//检测版本更新
- (void)updateVersion{
    [ZMYVersionNotes isAppVersionUpdatedWithAppIdentifier:@"1055258879" updatedInformation:^(NSString *releaseNoteText, NSString *releaseVersionText, NSDictionary *resultDic) {
        
        UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"已更新版本:%@", releaseVersionText] message:releaseNoteText delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        createUserResponseAlert.tag = 1101;
        [createUserResponseAlert show];
        
    } latestVersionInformation:^(NSString *releaseNoteText, NSString *releaseVersionText, NSDictionary *resultDic) {
        NSLog(@"%@",releaseNoteText);
        UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"有新版本:%@", releaseVersionText] message:releaseNoteText delegate:self cancelButtonTitle:@"忽略" otherButtonTitles: @"进行下载", @"下次再说",nil];
        url = [resultDic objectForKey:@"trackViewUrl"];
        createUserResponseAlert.tag = 1102;
        [createUserResponseAlert show];
    } completionBlockError:^(NSError *error) {
        NSLog(@"An error occurred: %@", [error localizedDescription]);
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1102) {
        switch (buttonIndex) {
            case 1:
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
                break;
                
            default:
                break;
        }
    }
}

- (void)setUpNavBar{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [NAVBAR_COLOR CGColor]);
    CGContextFillRect(context, rect);
    //       UIImage *imge = [UIImage imageNamed:@"Login_back"];
    
    UIImage *imge = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:imge forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    NSMutableDictionary *attrs=[[NSMutableDictionary alloc]init];
    attrs[NSForegroundColorAttributeName]=[UIColor blackColor];
    attrs[NSFontAttributeName]=[UIFont boldSystemFontOfSize:19];
    [self.navigationController.navigationBar setTitleTextAttributes:attrs];
}

-(void)refreshData:(NSNotification *)notification{
    BOOL isRefresh  = [notification.object boolValue];
    if (isRefresh) {
        
        [self requestData];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setUpNavBar];
}


//导航栏上的搜索按钮
-(void)customNavigationItem{
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_setting.png"] style:UIBarButtonItemStylePlain target:self action:@selector(setting:)];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
}

-(void)setting:(UIButton *)button{
 
    InstallViewController *vc = [[InstallViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)subitTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    
    [self.view addSubview:self.tableView];
    
}
//一共几组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  3;
}

//一组有几行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;
    
}

//设置section头部间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 15;
}
//设置头部视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 375, 1)];
    view.backgroundColor=[UIColor whiteColor];
    return view;
}
//底部的间距
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   
    return 0;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //1,定义一个共同的标识
    static NSString *ID = @"cell";
    //2,从缓存中取出可循环利用的cell
//    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ID];
    //3,如果缓存中没有可利用的cell，新建一个。

    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
 
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    CGFloat cellHeight = (WinHeight-CGRectGetMaxY(self.navigationController.navigationBar.frame)-H(45))/3;
    
    if (indexPath.section ==0) {
        cell.backgroundColor = [UIColor colorWithRed:150/255.0 green:199/255.0 blue:45/255.0 alpha:1.0];
        UIImageView *firstImage =[[UIImageView alloc]initWithFrame:CGRectMake(40, (cellHeight-120)/2.0, 162, 120)];
        firstImage.image  = [UIImage imageNamed:@"img_main1.png"];
        firstImage.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:firstImage];
        
         CGSize titleSize = [self sizeWithText:@"我提交的申请" font:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        UILabel *themeLabel = [[UILabel alloc]initWithFrame:CGRectMake(WinWidth/2+20,firstImage.frame.origin.y, titleSize.width, titleSize.height)];
        themeLabel.text = @"我提交的申请";
        themeLabel.font = [UIFont systemFontOfSize:18];
        themeLabel.textAlignment = NSTextAlignmentLeft;
        themeLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:themeLabel];
        
  //  申请中
        CGSize textSize= [self sizeWithText:@"申请中" font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT,MAXFLOAT)];
        UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(themeLabel.frame.origin.x, CGRectGetMaxY(themeLabel.frame)+3,textSize.width, textSize.height)];
        firstLabel.text = @"申请中";
        firstLabel.font = [UIFont systemFontOfSize:14];
        firstLabel.textAlignment = NSTextAlignmentLeft;
        firstLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:firstLabel];

        //更新的角标
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn1.frame = CGRectMake(CGRectGetMaxX(firstLabel.frame)+4, firstLabel.frame.origin.y,textSize.height,textSize.height);
        btn1.backgroundColor = [UIColor whiteColor];
        btn1.layer.cornerRadius = textSize.height/2;
        btn1.layer.masksToBounds =YES;
        btn1.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [btn1 setTitleColor:[UIColor colorWithRed:150/255.0 green:199/255.0 blue:45/255.0 alpha:1.0]forState:UIControlStateNormal];
         [btn1 setTitle:@"0" forState:UIControlStateNormal];
        [cell.contentView addSubview:btn1];
        
 //  已通过
        UILabel *secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(firstLabel.frame.origin.x,CGRectGetMaxY(firstLabel.frame)+5,textSize.width, textSize.height)];
        secondLabel.text = @"已通过";
        secondLabel.font = [UIFont systemFontOfSize:14];
        secondLabel.textAlignment = NSTextAlignmentLeft;
        secondLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:secondLabel];
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn2.frame = CGRectMake(CGRectGetMaxX(secondLabel.frame)+4,secondLabel.frame.origin.y,textSize.height,textSize.height);
        btn2.backgroundColor = [UIColor whiteColor];
        btn2.layer.cornerRadius = textSize.height/2;
        btn2.layer.masksToBounds =YES;
        btn2.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [btn2 setTitleColor:[UIColor colorWithRed:150/255.0 green:199/255.0 blue:45/255.0 alpha:1.0]forState:UIControlStateNormal];
         [btn2 setTitle:@"0" forState:UIControlStateNormal];
        [cell.contentView addSubview:btn2];
        

//未通过
        UILabel *thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(firstLabel.frame.origin.x,CGRectGetMaxY(secondLabel.frame)+5,textSize.width, textSize.height)];
        thirdLabel.text = @"未通过";
        thirdLabel.font = [UIFont systemFontOfSize:14];
        thirdLabel.textAlignment = NSTextAlignmentLeft;
        thirdLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:thirdLabel];
        
        //更新的角标
        UIButton *btn3= [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn3.frame = CGRectMake(CGRectGetMaxX(thirdLabel.frame)+4, thirdLabel.frame.origin.y,textSize.height,textSize.height);
        btn3.backgroundColor = [UIColor whiteColor];
        btn3.layer.cornerRadius = textSize.height/2;
        btn3.layer.masksToBounds =YES;
        btn3.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [btn3 setTitleColor:[UIColor colorWithRed:150/255.0 green:199/255.0 blue:45/255.0 alpha:1.0]forState:UIControlStateNormal];
         [btn3 setTitle:@"0" forState:UIControlStateNormal];
        [cell.contentView addSubview:btn3];

        for (HomeBadgeModel *model in self.datalist) {
            if ([model.countName isEqualToString:@"申请中"]) {
                if (!model.countValue) {
                    
                    [btn1 setTitle:@"0" forState:UIControlStateNormal];
                }else{
                     [btn1 setTitle:[NSString stringWithFormat:@"%li",model.countValue] forState:UIControlStateNormal];
                }
                
                if (model.countValue>99) {
                    [btn1 setTitle:@"99+" forState:UIControlStateNormal];
                    btn1.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:8];
                }
            }else if([model.countName isEqualToString:@"已通过"]){
                
                if (!model.countValue) {
                    
                    [btn2 setTitle:@"0" forState:UIControlStateNormal];
                }else{
                    
                    [btn2 setTitle:[NSString stringWithFormat:@"%li",model.countValue] forState:UIControlStateNormal];
                }
                
               
                if (model.countValue>99) {
                    [btn2 setTitle:@"99+" forState:UIControlStateNormal];
                    btn2.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:8];
                }

                
            }else if([model.countName isEqualToString:@"未通过"]){
                if (!model.countValue) {
                    
                    [btn3 setTitle:@"0" forState:UIControlStateNormal];
                }else{
                    
                    [btn3 setTitle:[NSString stringWithFormat:@"%li",model.countValue] forState:UIControlStateNormal];
                }
          
                if (model.countValue>99) {
                    [btn3 setTitle:@"99" forState:UIControlStateNormal];
                    [btn3 setTitle:@"99+" forState:UIControlStateNormal];
                    btn3.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:8];

                }

                
            }
        }
        

    }
    if (indexPath.section ==1) {
        cell.backgroundColor = [UIColor orangeColor];
        UIImageView *firstImage =[[UIImageView alloc]initWithFrame:CGRectMake(60, (cellHeight-120)/2.0, 162, 120)];
        firstImage.image  = [UIImage imageNamed:@"img_main2.png"];
        firstImage.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:firstImage];
        
        CGSize titleSize = [self sizeWithText:@"待我审批的事项" font:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        UILabel *themeLabel = [[UILabel alloc]initWithFrame:CGRectMake(WinWidth/2+20,firstImage.frame.origin.y, titleSize.width, titleSize.height)];
        themeLabel.text = @"待我审批的事项";
        themeLabel.font = [UIFont systemFontOfSize:18];
        themeLabel.textAlignment = NSTextAlignmentCenter;
        themeLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:themeLabel];
        
        
        CGSize textSize= [self sizeWithText:@"待审核" font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT,MAXFLOAT)];
        UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(themeLabel.frame.origin.x, CGRectGetMaxY(themeLabel.frame)+3,textSize.width, textSize.height)];
        firstLabel.text = @"待审核";
        firstLabel.font = [UIFont systemFontOfSize:14];
        firstLabel.textAlignment = NSTextAlignmentLeft;
        firstLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:firstLabel];
       
        
        //更新的角标
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn1.frame = CGRectMake(CGRectGetMaxX(firstLabel.frame)+4,firstLabel.frame.origin.y,textSize.height,textSize.height);
        btn1.backgroundColor = [UIColor whiteColor];
        btn1.layer.cornerRadius = textSize.height/2;
        btn1.layer.masksToBounds =YES;
        btn1.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [btn1 setTitleColor:[UIColor orangeColor]forState:UIControlStateNormal];
         [btn1 setTitle:@"0" forState:UIControlStateNormal];
        [cell.contentView addSubview:btn1];

        for (HomeBadgeModel *model in self.datalist) {
            if ([model.countName isEqualToString:@"待审批"]) {
                
                if (!model.countValue) {
                    
                    [btn1 setTitle:@"0" forState:UIControlStateNormal];
                }else{
                    
                    [btn1 setTitle:[NSString stringWithFormat:@"%li",model.countValue] forState:UIControlStateNormal];
                }
        
                if (model.countValue>99) {
                    [btn1 setTitle:@"99" forState:UIControlStateNormal];
                    [btn1 setTitle:@"99+" forState:UIControlStateNormal];
                    btn1.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:8];

                }

            }
        }

        
    }
    if (indexPath.section ==2) {
        cell.backgroundColor = [UIColor colorWithRed:56/255.0 green:193/255.0 blue:255/255.0 alpha:1.0];
        UIImageView *firstImage =[[UIImageView alloc]initWithFrame:CGRectMake(50, (cellHeight-120)/2.0, 162, 120)];
        firstImage.image  = [UIImage imageNamed:@"img_main3.png"];
        firstImage.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:firstImage];
        
        
        CGSize titleSize = [self sizeWithText:@"传阅给我的事项" font:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        UILabel *themeLabel = [[UILabel alloc]initWithFrame:CGRectMake(WinWidth/2+20,firstImage.frame.origin.y, titleSize.width, titleSize.height)];
        themeLabel.text = @"传阅给我的事项";
        themeLabel.font = [UIFont systemFontOfSize:18];
        themeLabel.textAlignment = NSTextAlignmentCenter;
        themeLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:themeLabel];
        
        CGSize textSize= [self sizeWithText:@"待传阅" font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT,MAXFLOAT)];
        UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(themeLabel.frame.origin.x, CGRectGetMaxY(themeLabel.frame)+3,textSize.width, textSize.height)];
        firstLabel.text = @"待传阅";
        firstLabel.font = [UIFont systemFontOfSize:14];
        firstLabel.textAlignment = NSTextAlignmentLeft;
        firstLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:firstLabel];
//
        //更新的角标
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn1.frame = CGRectMake(CGRectGetMaxX(firstLabel.frame)+4,firstLabel.frame.origin.y,textSize.height,textSize.height);
        btn1.backgroundColor = [UIColor whiteColor];
        btn1.layer.cornerRadius = textSize.height/2;
        btn1.layer.masksToBounds =YES;
        btn1.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [btn1 setTitleColor:[UIColor colorWithRed:56/255.0 green:193/255.0 blue:255/255.0 alpha:1.0]forState:UIControlStateNormal];
         [btn1 setTitle:@"0" forState:UIControlStateNormal];
        [cell.contentView addSubview:btn1];

        for (HomeBadgeModel *model in self.datalist) {
            if ([model.countName isEqualToString:@"待传阅"]) {
                if (!model.countValue) {
                    
                    [btn1 setTitle:@"0" forState:UIControlStateNormal];
                }else{
                    
                    [btn1 setTitle:[NSString stringWithFormat:@"%li",model.countValue] forState:UIControlStateNormal];
                }
                if (model.countValue>99) {
                    [btn1 setTitle:@"99" forState:UIControlStateNormal];
                    [btn1 setTitle:@"99+" forState:UIControlStateNormal];
                    btn1.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:8];

                }

            }
        }
        
    }
    
    return cell;
    
    
    
}
//返回每行cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (WinHeight-CGRectGetMaxY(self.navigationController.navigationBar.frame)-H(45))/3;
    
}

//选中某行做某事
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
       
     ApplicationViewController *ApplicationVc = [ApplicationViewController new];
            
     [self.navigationController pushViewController:ApplicationVc animated:YES];
         }
    if (indexPath.section == 1) {
       
        MspendingViewController *MspendingVC =[[MspendingViewController alloc]init];
        
        [self.navigationController pushViewController:MspendingVC animated:YES];
        
    }
    if (indexPath.section == 2) {
        
       CirculatedViewController * CirculatedVC =[[CirculatedViewController alloc]init];
        
        [self.navigationController pushViewController: CirculatedVC animated:YES];
    }
    
}


-(void)requestData{
    Account *account = [Account shareAccount];
    [account loadAccountFromSanbox];
    
    NSDictionary*parameters=@{@"userId":account.userName,
                              @"password":account.tempPwd,
                              @"title":@"",
                              @"hqType":@"0",
                              @"page":@"1",
                              @"rows":@"6"};
    
    [NetRequestClass NetRequestPOSTWithRequestURL:HomeBadgeInteface WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
        NSDictionary *dict = returnValue[@"items"];
        NSArray *arr= dict[@"rows"];
        NSArray *temp  = [HomeBadgeModel mj_objectArrayWithKeyValuesArray:arr];
        
        self.datalist  = temp;

       [self.tableView reloadData];
        if (self.datalist.count ==0) {
            
            
        }
    
    } WithErrorCodeBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
}



//极光推送设置tag，并获取自定义消息
- (void)configureJPush{
    UserInfo *user=[UserInfo shareUserInfo];
    NSString *alias=[NSString stringWithFormat:@"r_%@",user.userId];
    
    [APService setTags:nil
                 alias:alias
      callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                target:self];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
    
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:@"RemoteNotification" object:nil];
}

#pragma mark 极光推送相关配置
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \n,\nalias: %@\n", iResCode, alias];
    
    NSLog(@"TagsAlias回调:%@", callbackString);
}

- (void)networkDidSetup:(NSNotification *)notification {
    NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    
    NSLog(@"未连接");
    
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"%@", [notification userInfo]);
    
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    
    NSLog(@"已登录");
    
    if ([APService registrationID]) {
        NSLog(@"get RegistrationID");
    }
}


//JPush自定义消息
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary *userInfo = notification.object;
    NSLog(@"%@",notification);
    
    NSString *typeId=userInfo[@"typeId"];
  
    NSString *path=[[NSBundle mainBundle]pathForResource:@"sound" ofType:@"caf"];
    NSURL *url1=[NSURL fileURLWithPath:path];
    SystemSoundID soundId;//声明一个系统音效的id
    //注册系统声音
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url1, &soundId);
    //注册回调函数
    AudioServicesAddSystemSoundCompletion(soundId, NULL, NULL, MySoundFinishedPlayingCallBack, NULL);
    //播放系统音效
    AudioServicesPlaySystemSound(soundId);
    
    //震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
 
    [TSMessage showNotificationInViewController:self.navigationController
                                          title:@"北邮国昊会签系统"
                                       subtitle:userInfo[@"aps"][@"alert"]
                                          image:[UIImage imageNamed:@"coin"]
                                           type:TSMessageNotificationTypeMessage
                                       duration:TSMessageNotificationDurationAutomatic
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionNavBarOverlay
                           canBeDismissedByUser:YES];
    if (typeId.integerValue==1) {
        MspendingViewController *MspendingVC =[[MspendingViewController alloc]init];
        
        [self.navigationController pushViewController:MspendingVC animated:YES];
    }else if(typeId.integerValue==2){
        
        CirculatedViewController * CirculatedVC =[[CirculatedViewController alloc]init];
        
        [self.navigationController pushViewController: CirculatedVC animated:YES];
    }
    
   
    
    
}

//播放系统音效完成执行的方法
void MySoundFinishedPlayingCallBack(SystemSoundID sound_id,void *user_data){
    //销毁系统音效
    AudioServicesDisposeSystemSoundID(sound_id);
}

- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
    NSLog(@"%@", error);
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData1 = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData1
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)dealloc {
    [self unObserveAllNotifications];
}

- (void)unObserveAllNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidSetupNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidCloseNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidRegisterNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidLoginNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidReceiveMessageNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFServiceErrorNotification
                           object:nil];
}



//获取文字处理后的尺寸
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


@end
