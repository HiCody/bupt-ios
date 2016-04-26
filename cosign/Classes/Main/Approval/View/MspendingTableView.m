//
//  MspendingTableView.m
//  cosign
//
//  Created by mac on 15/10/21.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import "MspendingTableView.h"
#import "ApplicationModel.h"
#import "NSDate+Category.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/375.0
#define H(y) WinHeight*y/667.0

@implementation MspendingTableView

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
        self.isSpendHistory=NO;
        self.dataArry = [[NSMutableArray alloc] init];
        [self setUpRefresh];
    }
    
    return self;
    
}

- (void)setUpRefresh{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadingNewData];
    }];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadLastData方法）
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadingMoreData)];
}

- (void)beginRefresh{
    // 马上进入刷新状态
    [self.mj_header beginRefreshing];
}

- (void)loadingNewData{
    if (self.MspendingDelegate&&[self.MspendingDelegate respondsToSelector:@selector(loadNewData)]) {
        
        [self.MspendingDelegate loadNewData];
    }
}

-(void)loadingMoreData{
    if (self.MspendingDelegate&&[self.MspendingDelegate respondsToSelector:@selector(loadMoreDate)]) {
        
        [self.MspendingDelegate loadMoreDate];
    }
}


//一共几组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

//一组有几行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArry.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //1,定义一个共同的标识
    static NSString *ID = @"cell";
    //2,从缓存中取出可循环利用的cell
    UITableViewCell *cell =   [tableView dequeueReusableCellWithIdentifier:ID];
    //3,如果缓存中没有可利用的cell，新建一个。
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ApplicationModel *app = self.dataArry[indexPath.row];
    
    UILabel *bigLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,15,50, 50)];
    bigLabel.layer.masksToBounds=YES;
    bigLabel.layer.cornerRadius=25;
    bigLabel.layer.borderColor=NAVBAR_SECOND_COLOR.CGColor;
    bigLabel.layer.borderWidth=1.0;
    
    if (app.hqTypeName.length==0) {
        bigLabel.text = @"";
    }else{
        if ([self isZhongWenFirst:[app.hqTypeName substringToIndex:1]]) {
            bigLabel.text = [app.hqTypeName substringToIndex:1];
        }else if([self pipeizimu:[app.hqTypeName substringToIndex:1]]){
            NSString *str1 = [[app.hqTypeName substringToIndex:1] uppercaseString];
            bigLabel.text = str1;
            if (app.hqTypeName.length>=2) {
                
                if ([self pipeizimu:[app.hqTypeName substringWithRange:NSMakeRange(1, 1)]]) {
                    bigLabel.text = [NSString stringWithFormat:@"%@%@",str1,[app.hqTypeName substringWithRange:NSMakeRange(1, 1)]];
                }
            }
            
        }else{
            bigLabel.text = [app.hqTypeName substringToIndex:1];
        }
        
    }
    
    bigLabel.font = [UIFont systemFontOfSize:24];
    bigLabel.textColor = [UIColor colorWithRed:56/255.0 green:193/255.0 blue:255/255.0 alpha:1.0];
    bigLabel.textAlignment = NSTextAlignmentCenter;
    bigLabel.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:bigLabel];
    
//    //附件图片
//    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bigLabel.frame), 8, 24, 21)];
//    imageview.contentMode =  UIViewContentModeCenter;
//    imageview.image = [UIImage imageNamed:@"icon_status_attach.png"];
//    [cell.contentView  addSubview:imageview];
//    if ([app.fileUrls isEqualToString:@""]) {
//        imageview.hidden =YES;
//    }
//    else {
//        imageview.hidden =NO;
//    }
    
    //标题
    UILabel* headLabel = [[UILabel alloc] init];
    headLabel.text = app.title;
    headLabel.font = [UIFont systemFontOfSize:15];
    
    CGSize headSize =[self sizeWithText:headLabel.text font:headLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    headLabel.frame= CGRectMake(80, bigLabel.frame.origin.y-8, W(200), headSize.height);
    
    [cell.contentView addSubview:headLabel];
    
    
    
    UILabel* peopleLabel = [[UILabel alloc]init];
    NSString *Str=  [NSString stringWithFormat:@"申请人 :"];
    NSString *secondStr = [NSString stringWithFormat:@"%@",app.starterName];
    peopleLabel.text = [NSString stringWithFormat:@"%@ %@",Str,secondStr];
    peopleLabel.font = [UIFont systemFontOfSize:12];
    peopleLabel.textColor = [UIColor grayColor];
    CGSize peopleSize =[self sizeWithText:peopleLabel.text font:peopleLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    peopleLabel.frame = CGRectMake(headLabel.frame.origin.x, CGRectGetMaxY(headLabel.frame)+2, W(240), peopleSize.height);
    [cell.contentView addSubview: peopleLabel];
 
    
    
    UILabel *firstLabel = [[UILabel alloc] init];
    firstLabel.text = @"审批流程 :";
    firstLabel.font = [UIFont systemFontOfSize:12];
    firstLabel.textColor = [UIColor grayColor];
    CGSize firstSize =[self sizeWithText:firstLabel.text font:firstLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    firstLabel.frame = CGRectMake(headLabel.frame.origin.x, CGRectGetMaxY(peopleLabel.frame)+2, firstSize.width, firstSize.height);
    
    [cell.contentView addSubview:firstLabel];
 
    UILabel *contentsLabel = [[UILabel alloc] init];
    contentsLabel.text =app.checkers;
    contentsLabel.font = [UIFont systemFontOfSize:12];
    contentsLabel.textColor = [UIColor grayColor];
    contentsLabel.textAlignment = NSTextAlignmentLeft;
    CGSize contentsSize =[self sizeWithText:contentsLabel.text font:contentsLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    contentsLabel.frame = CGRectMake(CGRectGetMaxX(firstLabel.frame), firstLabel.frame.origin.y, W(200), contentsSize.height);
    [cell.contentView addSubview:contentsLabel];
    
    
    UILabel *secondLabel = [[UILabel alloc]init];
    secondLabel.text = @"传阅 :";
    secondLabel.font = [UIFont systemFontOfSize:12];
    secondLabel.textColor = [UIColor grayColor];
    CGSize secondSize =[self sizeWithText:secondLabel.text font:secondLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    secondLabel.frame = CGRectMake(headLabel.frame.origin.x, CGRectGetMaxY(firstLabel.frame)+2, secondSize.width, secondSize.height);
    [cell.contentView addSubview:secondLabel];
    
    UILabel *endLabel = [[UILabel alloc]init];
    
    if ([app.readers isEqualToString:@""]) {
        endLabel.text =@"无";
    }
    else {
        
        endLabel.text =app.readers;
    }
    endLabel .font = [UIFont systemFontOfSize:12];
    endLabel.textAlignment = NSTextAlignmentLeft;
    endLabel .textColor = [UIColor grayColor];
    CGSize endSize =[self sizeWithText:endLabel.text font:endLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    endLabel.frame = CGRectMake(CGRectGetMaxX(secondLabel.frame), secondLabel.frame.origin.y, W(220), endSize.height);
    [cell.contentView addSubview:endLabel ];
    
    //日期
    UILabel *fourthLabel = [[UILabel alloc] init];
    NSString *dateStr  = app.startDate;
    
    if (self.isSpendHistory) {
        dateStr=app.hqDate;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dateStr];
    
    NSString *dateStr2= [date timeIntervalDescription];
    
    fourthLabel.text = dateStr2;
    fourthLabel.font = [UIFont systemFontOfSize:8];
    fourthLabel.textColor = [UIColor grayColor];
    CGSize fourthSize = [self sizeWithText:fourthLabel.text font: fourthLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    fourthLabel.frame  =  CGRectMake(WinWidth-fourthSize.width-5, headLabel.frame.origin.y, fourthSize.width, fourthSize.height);

    [cell.contentView addSubview:fourthLabel];
    
    return cell;
    
}
//返回每行cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}

//选中某行做某事
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.MspendingDelegate&&[self.MspendingDelegate respondsToSelector:@selector(JumpToSecondView:)]) {
        
        [self.MspendingDelegate JumpToSecondView:indexPath];
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

//获取文字处理后的尺寸
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

-(BOOL)pipeizimu:(NSString *)str
{
    //判断是否以字母开头
    NSString *ZIMU = @"^[a-zA-Z]";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    
    if ([regextestA evaluateWithObject:str] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(BOOL)isZhongWenFirst:(NSString *)firstStr
{
    //是否以中文开头(unicode中文编码范围是0x4e00~0x9fa5)
    int utfCode = 0;
    void *buffer = &utfCode;
    NSRange range = NSMakeRange(0, 1);
    //判断是不是中文开头的,buffer->获取字符的字节数据 maxLength->buffer的最大长度 usedLength->实际写入的长度，不需要的话可以传递NULL encoding->字符编码常数，不同编码方式转换后的字节长是不一样的，这里我用了UTF16 Little-Endian，maxLength为2字节，如果使用Unicode，则需要4字节 options->编码转换的选项，有两个值，分别是NSStringEncodingConversionAllowLossy和NSStringEncodingConversionExternalRepresentation range->获取的字符串中的字符范围,这里设置的第一个字符 remainingRange->建议获取的范围，可以传递NULL
    BOOL b = [firstStr getBytes:buffer maxLength:2 usedLength:NULL encoding:NSUTF16LittleEndianStringEncoding options:NSStringEncodingConversionExternalRepresentation range:range remainingRange:NULL];
    if (b && (utfCode >= 0x4e00 && utfCode <= 0x9fa5))
        return YES;
    else
        return NO;
}


@end
