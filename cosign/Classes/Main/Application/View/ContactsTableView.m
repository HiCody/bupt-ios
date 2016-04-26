//
//  ContactsTableView.m
//  cosign
//
//  Created by mac on 15/11/11.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import "ContactsTableView.h"
#import "NewApplicationModel.h"

#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/375.0
#define H(y) WinHeight*y/667.0
@interface ContactsTableView()

@end

@implementation ContactsTableView 
- (NSMutableArray *)dataArry{
    if (!_dataArry) {
        _dataArry = [[NSMutableArray alloc] init];
    }
    return _dataArry;
}

- (NSMutableArray *)selectedIndexes{
    if (!_selectedIndexes) {
        _selectedIndexes = [[NSMutableArray alloc] init];
    }
    return _selectedIndexes;
}


- (NSMutableArray *)selectedArr{
    if (!_selectedArr) {
        _selectedArr = [[NSMutableArray alloc]init];
    }
    return _selectedArr;
}

- (NSMutableArray *)treeOpenArray{
    if (!_treeOpenArray) {
        _treeOpenArray = [[NSMutableArray alloc]init];
    }
    return _treeOpenArray;
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

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArry.count;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ApprovalPeopleModel *approval = self.dataArry[section];
    NSArray *tempArr =approval.userInfos;

    NSInteger tempNum =tempArr.count;

    NSString *tempSectionString = [NSString stringWithFormat:@"%ld",(long)section];
    if ([self.treeOpenArray containsObject:tempSectionString]) {
        return tempNum;
    }
    
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
 
    UIView *tempV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, H(50))];
    tempV.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(35, H(10), 200, H(30))];
    label1.backgroundColor = [UIColor clearColor];
    label1.font = [UIFont fontWithName:@"Arial" size:16];
    ApprovalPeopleModel *approval =self.dataArry[section];
  
    label1.text = approval.deptName;
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(WinWidth-115, H(10), 100,H(30))];
    label2.backgroundColor = [UIColor clearColor];
    label2.textAlignment =NSTextAlignmentRight;
    label2.font = [UIFont fontWithName:@"Arial" size:16];
    label2.text  =[NSString stringWithFormat:@"%li人",(long)approval.userInfos.count];
    [tempV addSubview:label2];
    
    UIImageView *tempImageV = [[UIImageView alloc]initWithFrame:CGRectMake(5, H(15), 20, H(20))];
    NSString *tempSectionString = [NSString stringWithFormat:@"%ld",(long)section];
    if ([self.treeOpenArray containsObject:tempSectionString]) {
        tempImageV.image = [UIImage imageNamed:@"buddy_header_arrow_down@2x.png"];
        
    }else{
        tempImageV.image = [UIImage imageNamed:@"buddy_header_arrow_right@2x.png"];
    }

    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(tempV.frame)-0.5, WinWidth, 0.5)];
    lineView.backgroundColor =[UIColor lightGrayColor];
    [tempV addSubview:label1];
    [tempV addSubview:tempImageV];
    [tempV addSubview:lineView];
    
    UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.frame = CGRectMake(0, 0, WinWidth, H(50));
    [tempBtn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    tempBtn.tag = section;
    [tempV addSubview:tempBtn];
    
    return tempV;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return H(50);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)tapAction:(UIButton *)sender{
    self.treeOpenString = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    if ([self.treeOpenArray containsObject:self.treeOpenString]) {
        [self.treeOpenArray removeObject:self.treeOpenString];
    }else{
        [self.treeOpenArray addObject:self.treeOpenString];
    }
    sender.selected =!sender.selected;//改变item的是否打开的属性
    [self reloadData];
//    //下面一句是用的时候刷新的。
//        [self reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationFade];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    ApprovalPeopleModel *approval = self.dataArry[indexPath.section];
    NSArray *tempArr =approval.userInfos;
    Userinfos *userInfo = tempArr[indexPath.row];
    
    NSInteger num =0;
    for (Userinfos *userInfo1 in self.selectedArr) {
        if ([userInfo1.userId isEqualToString:userInfo.userId]) {
            num++;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            if (![self.selectedIndexes containsObject:indexPath]) {
                [self.selectedIndexes  addObject:indexPath];
            }
            
        }
    }
    if (num==0) {
        cell.accessoryType =UITableViewCellAccessoryNone;
    }

    cell.detailTextLabel.text = userInfo.userName;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
    cell.detailTextLabel.textColor =[UIColor grayColor];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(0,43.5, WinWidth, 0.5)];
    lineView.backgroundColor =[UIColor lightGrayColor];
    [cell.contentView addSubview:lineView];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        UITableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath ];
        ApprovalPeopleModel *approval = self.dataArry[indexPath.section];
        NSArray *tempArr =approval.userInfos;
        Userinfos *userInfo = tempArr[indexPath.row];
        if (cell.accessoryType ==UITableViewCellAccessoryNone){
            NSInteger num =self.selectedArr.count;
            cell.accessoryType =UITableViewCellAccessoryCheckmark;
   
            [self.selectedArr addObject:userInfo];
            [self.selectedIndexes addObject:indexPath];

            self.addSelectedUser(num);
 
        }else{
            
            cell.accessoryType =UITableViewCellAccessoryNone;
      
            NSInteger index1=0;
            for (int  i =0 ;i<self.selectedArr.count;i++) {
                Userinfos *obj =self.selectedArr[i];
                if ([obj.userId isEqualToString:userInfo.userId]) {
                    index1 =i;
                    break;
                }
            }
            
            __block NSUInteger index2=0;
            [self.selectedArr enumerateObjectsUsingBlock:^(Userinfos *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.userId isEqualToString:userInfo.userId]) {
                    index2 = idx;
                    *stop  = YES;
                }
                
            }];
            [self.selectedArr removeObjectAtIndex:index2];
            
            [self.selectedIndexes removeObject:indexPath];
       
            self.deleteSelectedUser(index1);
 
        }
    
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
        
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
