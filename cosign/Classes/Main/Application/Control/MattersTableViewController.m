//
//  MattersTableViewController.m
//  cosign
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import "MattersTableViewController.h"
#import "NetRequestClass.h"
#import "NewApplicationModel.h"


@interface MattersTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MattersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"事项列表";
    self.tableView.scrollEnabled = NO;
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self requestData];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
}

//延迟实例化
-(NSArray *)arry{
    if (!_array) {
        _array = [[NSMutableArray alloc]init];
    }
    
    return _array;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arry.count;
}

//返回没行cell的内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    NewApplicationModel *appsModel = self.array[indexPath.row];
    
    if ([self.matterTypeStr isEqualToString:appsModel.name]) {
        cell.accessoryType =UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType =UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = appsModel.name;
    
    
    return cell;
    
    
}
//选中cell出现打勾，点下一个cell，上次cell对勾消失
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSArray *array = [tableView visibleCells];
    for (UITableViewCell *cell in array) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.textLabel.textColor=[UIColor blackColor];
        
    }
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
    
    //点击cell 返回查询页面并且传值
    
    NewApplicationModel *appsModel = self.array[indexPath.row];
    cell.textLabel.text = appsModel.name;
    
    if (self.MattersDelegate&&[self.MattersDelegate respondsToSelector:@selector(changeTitle:WithValue:)]) {
         [self.MattersDelegate changeTitle:appsModel.name WithValue:appsModel.id];
    }
   
    
    [self.navigationController popViewControllerAnimated:YES];
    self.matterTypeStr = appsModel.name;
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    
}

-(void)requestData{
    Account *account = [Account shareAccount];
    [account loadAccountFromSanbox];
    
    NSDictionary *parameters=@{@"userId":account.userName,
                               @"password":account.tempPwd,
                               @"platform":@"2"};
    
    [NetRequestClass NetRequestPOSTWithRequestURL: MattersInterface
                                    WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
                                        NSDictionary *dict = returnValue;
                                        
                                        NSArray *temp  = [NewApplicationModel mj_objectArrayWithKeyValuesArray:dict[@"items"]];
                                        
                                        [self.array addObjectsFromArray:temp];
                                        
                                        [self.tableView reloadData];
                                        
                                    } WithErrorCodeBlock:^(id errorCode) {
                                        
                                    } WithFailureBlock:^{
                                        
                                    }];
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


//获取文字处理后的尺寸
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


@end
