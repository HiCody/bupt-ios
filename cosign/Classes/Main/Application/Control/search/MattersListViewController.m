//
//  MattersListViewController.m
//  cosign
//
//  Created by mac on 15/10/14.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import "MattersListViewController.h"
#import "InquireViewController.h"
#import "NetRequestClass.h"
#import "QueryHqTypeList.h"
#import "NewApplicationModel.h"
@interface MattersListViewController (){
    
    
    NSInteger  index;
    
}
@property(nonatomic,strong)NSMutableArray *Array;
@end

@implementation MattersListViewController
- (NSMutableArray *)Array{
    if (!_Array) {
        _Array = [[NSMutableArray alloc] init];
    }
    return _Array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"事项列表";
    [self requestData];
    self.tableView.scrollEnabled = NO;
    //去掉没有内容的cell
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
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

    return self.Array.count;
}

//返回没行cell的内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    
    NewApplicationModel *appsModel = self.Array[indexPath.row];
    cell.textLabel.text = appsModel.name;
    
    if ([self.matterTypeStr isEqualToString:appsModel.name]) {
        cell.accessoryType =UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType =UITableViewCellAccessoryNone;
    }

 
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
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    //点击cell 返回查询页面并且传值
    NewApplicationModel *appsModel = self.Array[indexPath.row];
    cell.textLabel.text = appsModel.name;
    
    if (self.MattersListDelegate&&[self.MattersListDelegate respondsToSelector:@selector(changeTitle:WithValue:)]) {
         [self.MattersListDelegate changeTitle:appsModel.name WithValue:appsModel.id];    }
    
    [self.navigationController popViewControllerAnimated:YES];
    self.matterTypeStr =appsModel.name;
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
   
    
}

//此时只设定了在可见范围内选择的是一行，还得设置滚动后的选中状态，
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *index=[tableView indexPathForSelectedRow];
    
    if (index.row==indexPath.row&& index!=nil)
    {
        cell.backgroundColor=[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0];
        cell.textLabel.textColor=[UIColor colorWithRed:0.0 green:206.0/255.0 blue:192.0/255.0 alpha:1.0];
    }
    else
    {
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.textColor=[UIColor blackColor];
    }

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
                                        
                                        [self.Array addObjectsFromArray:temp];
                                        
                                        [self.tableView reloadData];
                                        
                                    } WithErrorCodeBlock:^(id errorCode) {
                                        
                                    } WithFailureBlock:^{
                                        
                                    }];
}



//获取文字处理后的尺寸
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}




@end
