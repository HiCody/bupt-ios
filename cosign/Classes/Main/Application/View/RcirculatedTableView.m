//
//  RcirculatedTableView.m
//  cosign
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import "RcirculatedTableView.h"
#import "NewApplicationModel.h"

@implementation RcirculatedTableView

-(NSMutableArray *)approverArr{
    if (!_approverArr) {
        _approverArr = [[NSMutableArray alloc]init];
    }
    
    return  _approverArr;
    
}



-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.dataSource = self;
        
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            
            [self setSeparatorInset:UIEdgeInsetsZero];
            
        }
        
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            
            [self setLayoutMargins:UIEdgeInsetsZero];
            
        }
    }
    
    return self;
    
}

//一共几组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

//一组有几行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.approverArr.count;
  
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //1,定义一个共同的标识
    static NSString *ID = @"cell";
    //2,从缓存中取出可循环利用的cell
    UITableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
    //3,如果缓存中没有可利用的cell，新建一个。
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NewApplicationModel *apps = self.approverArr[indexPath.row];
    
    NSMutableArray *newArray =[[NSMutableArray alloc]init];
    
    NSArray *tempArr = [apps.readerDetails componentsSeparatedByString:@"|"];
    for (NSString *str in tempArr) {
        NSArray *tempArr1=[str componentsSeparatedByString:@","];
        [newArray addObject:[tempArr1 lastObject]];
    }
    NSString *tempStr=[newArray componentsJoinedByString:@","];
    
    
    cell.textLabel.text = tempStr ;
    
    
        return cell;
    
}
//返回每行cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

//选中cell出现打勾，点下一个cell，上次cell对勾消失
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSArray *array = [tableView visibleCells];
    for (UITableViewCell *cell in array) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
    }
    
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    self.cosignStr =  cell.textLabel.text;

    NewApplicationModel *apps = self.approverArr[indexPath.row];
    
    NSMutableArray *newArray =[[NSMutableArray alloc]init];
    
    NSArray *tempArr = [apps.readerDetails componentsSeparatedByString:@"|"];
    for (NSString *str in tempArr) {
        NSArray *tempArr1=[str componentsSeparatedByString:@","];
        [newArray addObject:[tempArr1 firstObject]];
    }
    NSString *tempStr=[newArray componentsJoinedByString:@","];
    self.userIdStr = tempStr;
    
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];

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
