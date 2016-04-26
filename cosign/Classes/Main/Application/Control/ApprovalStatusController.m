//
//  ApprovalStatusController.m
//  cosign
//
//  Created by mac on 15/10/15.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import "ApprovalStatusController.h"

#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0

@interface ApprovalStatusController ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger index;
}
@property (nonatomic,strong)NSMutableArray *nameArr;
@property (nonatomic,strong)NSMutableArray *statusArr;
@property (nonatomic, strong)UIView *oneView;
@property (nonatomic, strong)UIView *oneview;
@property (nonatomic, strong)UIButton *btn1;
@property (nonatomic, strong)UILabel *firstLabel;
@property (nonatomic, strong)UILabel *label;
@end

@implementation ApprovalStatusController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"审批流程";
    
    //    self.tableView.scrollEnabled = NO;
    //去掉cell的分割线
    self.tableView.separatorStyle = NO;
    //去掉没有内容的cell
    //    self.tableView.tableFooterView = [[UIView alloc]init];
    
    //获取参数数组里的字符串
    NSArray *arr = [self.apps.checkers componentsSeparatedByString:@","];
    
    for (NSString *str in arr) {
        NSRange range = [str rangeOfString:@"("];
        NSRange range1 = [str rangeOfString:@")"];
        if (range.location!=NSNotFound) {
            NSString *nameStr=[str substringToIndex:range.location];
            
            [self.nameArr addObject:nameStr];
            
            NSString *str2= [str substringWithRange:NSMakeRange(range.location+1, range1.location-range.location-1)];
            [self.statusArr addObject:str2];
            
        }
    }
    
    NSString *str4 = self.apps.userName;
    NSString *str3 = @"审批结束";
    [self.nameArr insertObject:str4 atIndex:0];
    [self.nameArr insertObject:str3 atIndex:self.nameArr.count];
    
    NSString *str5= @"创建审批";
    [self.statusArr insertObject:str5 atIndex:0];
    NSString *str6 =@"";
    [self.statusArr insertObject:str6 atIndex:self.statusArr.count];
    //
    //    for (NSString *str1 in self.nameArr) {
    //        NSLog(@"%@",str1);
    //
    //    }
    //
    
    //取到数组中第一个字符“未审批”标记它
    for (NSString *str in self.statusArr) {
        NSLog(@"%@",str);
    }
    __block NSUInteger integer=0;
    [self.statusArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:@"未审批"]||[obj isEqualToString:@"未通过"]) {
            integer = idx;
            *stop = YES;
        }
    }];
    index = integer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSMutableArray *)nameArr{
    if (!_nameArr) {
        _nameArr = [[NSMutableArray alloc] init];
    }
    return _nameArr;
}

- (NSMutableArray *)statusArr{
    if (!_statusArr) {
        _statusArr = [[NSMutableArray alloc] init];
    }
    return _statusArr;
}


#pragma mark - Table view data source
//一共几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

//一组有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.nameArr.count;
}
//返回每行cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }
    
    //cell的不可点击
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //cell的自定义分割线
    self.oneView = [[UIView alloc]initWithFrame:CGRectMake(W(50),H(49),WinWidth-W(30), H(0.5))];
    self.oneView.backgroundColor = [UIColor grayColor];
    [cell.contentView addSubview:self.oneView];
    
    
    self.btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btn1.frame = CGRectMake(W(20), H(15),W(20),H(20));
    self.btn1.backgroundColor = [UIColor grayColor];
    self.btn1.layer.cornerRadius = W(10);
    self.btn1.layer.masksToBounds =YES;
    [self.btn1 setTitle:[NSString stringWithFormat:@"%ld",indexPath.row+1] forState:UIControlStateNormal];
    [self.btn1 setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [cell.contentView addSubview:self.btn1];
    
    //    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(W(60), H(10), W(25), H(30))];
    //    headImage.image = [UIImage imageNamed:@"price_1.pngng"];
    //    [cell addSubview:headImage];
    
    self.firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(W(80), 0,W(200) , H(50))];
    self.firstLabel.text = self.nameArr[indexPath.row];
    self.firstLabel.textColor = [UIColor grayColor];
    self.firstLabel.font = [UIFont systemFontOfSize:13];
    
    [cell.contentView  addSubview: self.firstLabel ];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(WinWidth-W(70), 0,W(60), H(50))];
    self.label.text = self.statusArr[indexPath.row];
    self.label.textColor = [UIColor grayColor];
    self.label.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview: self.label];
    
    self.oneview = [[UIView alloc]initWithFrame:CGRectMake(W(30),H(0), W(0.5), H(15))];
    self.oneview.backgroundColor = [UIColor grayColor];
    [cell.contentView addSubview:self.oneview];
    
    
    self.oneView = [[UIView alloc]initWithFrame:CGRectMake(W(30),H(35), W(0.5), H(15))];
    self.oneView.backgroundColor = [UIColor grayColor];
    [cell.contentView addSubview:self.oneView];
    
    if([self.statusArr[indexPath.row]isEqualToString:@"创建审批"]){
        
        self.oneview.hidden =YES;
        
        self.btn1.backgroundColor = [UIColor colorWithRed:34/255.0 green:172/255.0  blue:57/255.0  alpha:1.0];
        self.label.textColor = [UIColor colorWithRed:34/255.0 green:172/255.0  blue:57/255.0  alpha:1.0];
        
        self.firstLabel.textColor = [UIColor colorWithRed:34/255.0 green:172/255.0  blue:57/255.0  alpha:1.0];
        
    }
    
    if([self.nameArr[indexPath.row]isEqualToString:@"审批结束"]){
        
        self.oneView.hidden =YES;
        
    }
    
    if([self.statusArr[indexPath.row]isEqualToString:@"已通过"]){
        
        self.btn1.backgroundColor = [UIColor colorWithRed:34/255.0 green:172/255.0  blue:57/255.0  alpha:1.0];
        self.label.textColor = [UIColor colorWithRed:34/255.0 green:172/255.0  blue:57/255.0  alpha:1.0];
        
        self.firstLabel.textColor = [UIColor colorWithRed:34/255.0 green:172/255.0  blue:57/255.0  alpha:1.0];
        
    }
    //未审批或者未通过的颜色判断
    if(indexPath.row==index &&indexPath.row!=0){
        
        self.btn1.backgroundColor = [UIColor colorWithRed:243/255.0 green:59/255.0  blue:59/255.0  alpha:1.0];
        self.label.textColor = [UIColor colorWithRed:243/255.0 green:59/255.0  blue:59/255.0  alpha:1.0];
        
        self.firstLabel.textColor = [UIColor colorWithRed:243/255.0 green:59/255.0  blue:59/255.0  alpha:1.0];
        
    }
    else if ( indexPath.row==0){
        
        self.btn1.backgroundColor = [UIColor colorWithRed:34/255.0 green:172/255.0  blue:57/255.0  alpha:1.0];
        self.label.textColor = [UIColor colorWithRed:34/255.0 green:172/255.0  blue:57/255.0  alpha:1.0];
        
        self.firstLabel.textColor = [UIColor colorWithRed:34/255.0 green:172/255.0  blue:57/255.0  alpha:1.0];
    }
    
   
    for (int i=3;i<100;i++){
    if (self.nameArr.count ==i &&[self.statusArr[i-1]isEqualToString:@"已通过"]) {
//        if (indexPath.row==2) {
//            self.btn1.backgroundColor = [UIColor colorWithRed:243/255.0 green:59/255.0  blue:59/255.0  alpha:1.0];
//            self.label.textColor = [UIColor colorWithRed:243/255.0 green:59/255.0  blue:59/255.0  alpha:1.0];
//            
//            self.firstLabel.textColor = [UIColor colorWithRed:243/255.0 green:59/255.0  blue:59/255.0  alpha:1.0];
//        }
//        else if (indexPath.row ==0) {
//            
//            self.btn1.backgroundColor = [UIColor colorWithRed:34/255.0 green:172/255.0  blue:57/255.0  alpha:1.0];
//            self.label.textColor = [UIColor colorWithRed:34/255.0 green:172/255.0  blue:57/255.0  alpha:1.0];
//            
//            self.firstLabel.textColor = [UIColor colorWithRed:34/255.0 green:172/255.0  blue:57/255.0  alpha:1.0];
//        }
//
//        else{
        
            self.btn1.backgroundColor = [UIColor colorWithRed:34/255.0 green:172/255.0  blue:57/255.0  alpha:1.0];
            self.label.textColor = [UIColor colorWithRed:34/255.0 green:172/255.0  blue:57/255.0  alpha:1.0];
            
            self.firstLabel.textColor = [UIColor colorWithRed:34/255.0 green:172/255.0  blue:57/255.0  alpha:1.0];
    }
//
//        }
    }
    
    
    return cell;
}


//返回每行的cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return H(50);
}


@end
