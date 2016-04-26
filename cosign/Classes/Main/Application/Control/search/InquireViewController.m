//
//  InquireViewController.m
//  cosign
//
//  Created by mac on 15/10/14.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import "InquireViewController.h"
#import "MattersListViewController.h"
#import "ApplicationViewController.h"
@interface InquireViewController ()<UITableViewDataSource,UITableViewDelegate,MattersListDelegate,UITextFieldDelegate>{
    NSInteger num;
}

@property (nonatomic, strong)UILabel *label;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UITextField *nameText;

@end

@implementation InquireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查询";
    
    [self subitView];
    [self setUpBackBtn];
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
    
    self.navigationController.navigationBar.barTintColor = NAVBAR_SECOND_COLOR;
    
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
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    
}

- (void)setUpBackBtn{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
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
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.section ==0 )
        if(indexPath.row == 0){
            
            cell.textLabel.text = @"会签事项";
            self.label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-180, 0, 150, cell.contentView.frame.size.height)];
            self.label.text = @"不限";
            self.label.textAlignment = NSTextAlignmentRight;
            self.label.textColor = [UIColor blackColor];
            [cell addSubview:self.label];
            //cell后面的箭头
            cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
            
       
            
        }
    if (indexPath.section == 0)
        if (indexPath.row == 1) {
            cell.textLabel.text = @"标题事项";
            self.nameText = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3, 0, self.view.frame.size.width/3*2, 40)];
            self.nameText.delegate = self;
            self.nameText.backgroundColor = [UIColor whiteColor];
            self.nameText.placeholder = @"请输入标题事项";
            self.nameText.textColor = [UIColor grayColor];
            [cell.contentView addSubview:self.nameText];
            
        }
    
    return cell;
    
    
    
}
//返回每行cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
    
}


-(void)addFooterButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     button.layer.cornerRadius = 10.0;
     button.frame =  CGRectMake(60, 160, self.view.frame.size.width-120, 40);
    
     button.backgroundColor = [UIColor orangeColor];
    
    [button addTarget:self action:@selector(ending:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView addSubview:button];
}

//点击确定按钮的事件
-(void)ending:(UIButton *)button{
    if (self.nameText.text.length==0) {
        self.nameText.text=@"";
    }
    
    if ([self.label.text isEqualToString:@"不限"]) {
        num = 0;
    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(requestDataByRequirementWithIndex:WithHqType:WithTitle:)]) {
        [self.delegate requestDataByRequirementWithIndex:self.index WithHqType:[NSString stringWithFormat:@"%li",num] WithTitle:self.nameText.text];
        
       
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

//选中cell做的事件
//选中某行做某事
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 &&indexPath.row == 0) {
        MattersListViewController *vc = [[MattersListViewController alloc]init];
        vc.MattersListDelegate =self;
        vc.matterTypeStr  = self.label.text;
        [self.navigationController pushViewController:vc animated:YES];
        
    
    }
}


//代理传值
- (void)changeTitle:(NSString *)title WithValue:(NSInteger)integer {
   
    self.label.text = title ;
    num = integer;

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
