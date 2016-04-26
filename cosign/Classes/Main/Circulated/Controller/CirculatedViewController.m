//
//  CirculatedViewController.m
//  cosign
//
//  Created by mac on 15/10/21.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import "CirculatedViewController.h"

#import <HMSegmentedControl.h>
#import "ApplicationsTableView.h"
#import "InquireViewController.h"
#import"NetRequestClass.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "NotfindView.h"
#import "ApplicationModel.h"
#import "MspendingTableView.h"
#import "THistorysViewController.h"
#import "AMattersViewController.h"

#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/375.0
#define H(y) WinHeight*y/667.0

@interface CirculatedViewController ()<UIScrollViewDelegate,MspendingDelegate,InquireVCdelegate>{
    
    NSInteger index;
    NSInteger page, page2;//各个tableview的加载数
    
    NSInteger total,total2;//各个tableview对应的总的页数
    
    NSString *title2;//各个tableview对应的网络请求所传的字段
    
    NSString *hqType2;//各个tableview对应的网络请求所传的字段
}

@property(nonatomic,strong)UIButton *rightBtn;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic ,strong) HMSegmentedControl *segmentedControl;
@property (nonatomic ,strong)MspendingTableView *spendingTableView;
@property (nonatomic ,strong)MspendingTableView *historyTableView;
@property (nonatomic ,strong)NotfindView *notfindView;
@property (nonatomic ,strong)NotfindView *passView;
@property (nonatomic ,strong)NSMutableArray *dataarry;
@property (nonatomic,strong)NSMutableArray *secondarry;


@end

@implementation CirculatedViewController
- (NSMutableArray *)dataarry{
    if (!_dataarry) {
        _dataarry = [[NSMutableArray alloc] init];
    }
    return _dataarry;
}

- (NSMutableArray *)secondarry{
    if (!_secondarry) {
        _secondarry = [[NSMutableArray alloc] init];
    }
    return _secondarry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNavBar];
    self.title = @"传阅给我的事项";
    
    page  = 1;
    page2 = 1;
    title2=@"";
    hqType2=@"0";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:CirculatedRefresh object:nil];

    
    [self coustomNavigtion];

    [self setUpSegment];
    [self addApplicationstableView ];
    [self  addpassedTableView];
    
    [self.spendingTableView beginRefresh];
    [self  requestData1];

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

//通知刷新
- (void)refreshData:(NSNotification *)notification{
    BOOL isRefresh  = [notification.object boolValue];
    if (isRefresh) {
        if (index==0) {
            [self.spendingTableView.mj_header beginRefreshing];
            [self.historyTableView.dataArry removeAllObjects];
            
            page2=1;
            [self requestData1];
            
        }else{
            [self.historyTableView.mj_header beginRefreshing];
            [self.spendingTableView.dataArry removeAllObjects];
            page=1;
            [self requestData];
        }


    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setUpNavBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpSegment{
    //界面布局，segmentedControl带动画的滑动
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.navigationController.navigationBar.frame) , W(375), 40)];
    self.segmentedControl.sectionTitles = @[@"待传阅的事项",@"传阅历史"];
    //中间竖线
    self.segmentedControl.verticalDividerWidth=0.5;
    self.segmentedControl.verticalDividerColor= [UIColor colorWithRed:56/255.0 green:193/255.0 blue:255/255.0 alpha:1.0];
    self.segmentedControl.verticalDividerEnabled = YES;
    
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.backgroundColor = [UIColor clearColor];
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName : [UIFont systemFontOfSize:17.0f]};
    //点击segmentedControl的title颜色的改变 及字体大小
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName :[UIColor colorWithRed:56/255.0 green:193/255.0 blue:255/255.0 alpha:1.0],NSFontAttributeName : [UIFont systemFontOfSize:17.0f]};
    //滑动线的颜色和高度
    self.segmentedControl.selectionIndicatorColor= [UIColor colorWithRed:56/255.0 green:193/255.0 blue:255/255.0 alpha:1.0];
    self.segmentedControl.selectionIndicatorHeight=2.0;
    
    self.segmentedControl.borderType=HMSegmentedControlBorderTypeBottom;
    self.segmentedControl.borderWidth=2.0;
    self.segmentedControl.borderColor=[UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1];
    
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    [self.view addSubview:self.segmentedControl];
    
    
    //当前的滑动控制器
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger indexg) {
        
        index =indexg;
        if (index == 0) {
            weakSelf.rightBtn.hidden = YES;
            
        }else if (index == 1){
            weakSelf.rightBtn.hidden = NO;
        }
        
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(WinWidth * index, 0, WinWidth, 200) animated:YES];
    }];
    
    
    //一面的动画的大小范围
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.navigationController.navigationBar.frame)+40,self.view.frame.size.width, self.view.frame.size.height-40-CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    //动画视图的大小范围
    self.scrollView.contentSize = CGSizeMake(WinWidth*2, 200);
    self.scrollView.delegate = self;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, WinWidth, 200) animated:NO];
    [self.view addSubview:self.scrollView];
    
    self.notfindView = [[NotfindView alloc] initWithFrame:  CGRectMake(0,0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)] ;
    
    self.passView = [[NotfindView alloc] initWithFrame:  CGRectMake(self.scrollView.frame.size.width,0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)] ;
}

//待传阅给我的事项
-(void)addApplicationstableView{
    
    self.spendingTableView = [[MspendingTableView alloc] initWithFrame:  CGRectMake(0,0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)] ;
    self.spendingTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.spendingTableView.MspendingDelegate =self;
    [self.scrollView addSubview: self.spendingTableView];
    
}
//传阅历史
-(void)addpassedTableView{
    self.historyTableView = [[MspendingTableView alloc] initWithFrame:  CGRectMake(self.scrollView.frame.size.width,0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)] ;
    self.historyTableView.MspendingDelegate =self;
    self.historyTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.scrollView addSubview: self.historyTableView];
    
}

//导航栏上的搜索按钮
-(void)coustomNavigtion{
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -20;
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.hidden = YES;
    [ self.rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_magnifying_glass.png"]
                              forState:UIControlStateNormal];
    [ self.rightBtn addTarget:self action:(@selector(searchFor:))
             forControlEvents:UIControlEventTouchUpInside];
    
    self.rightBtn.frame = CGRectMake(0, 0, 54, 40);
    self.rightBtn.contentMode =  UIViewContentModeCenter;
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: self.rightBtn];
    self.navigationItem.rightBarButtonItems  = @[negativeSeperator,rightBarButtonItem];

    
    
}
#pragma mark - UIScrollViewDelegate

//动画
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page1 = scrollView.contentOffset.x / pageWidth;
    
    index =page1;
    if (page1 == 0) {
        self.rightBtn.hidden = YES;
        
    }else if (page1 == 1){
        self.rightBtn.hidden = NO;
    }

    
    [self.segmentedControl setSelectedSegmentIndex:page1 animated:YES];
}

//点击搜索按钮的点击事件
-(void)searchFor:(UIButton *)button{
    InquireViewController *vc = [[InquireViewController alloc]init];
    vc.delegate = self;
    vc.index = index;

    [self.navigationController pushViewController:vc animated:YES];
    
};

//代理点击push下一个页面

- (void)JumpToSecondView:(NSIndexPath *)indexPath{
    
    if (index ==0) {

        AMattersViewController *AMattersVC =[[AMattersViewController alloc]init];
        
        AMattersVC.aModel = self.spendingTableView.dataArry[indexPath.row];
        
        [self.navigationController pushViewController:AMattersVC animated:YES];
        
        
    }
    if (index == 1) {
        THistorysViewController *THistoryVC = [[THistorysViewController alloc]init];
        
        THistoryVC.aModel = self.historyTableView.dataArry[indexPath.row];
        
        [self.navigationController pushViewController:THistoryVC animated:YES];
    }
   
    
}

//刷新
- (void)loadNewData{
    if (index==0) {
        page=1;
        [self requestData];
      
    }else if(index==1){
        page2=1;
        [self requestData1];
        
    }
}

//加载
- (void)loadMoreDate{
    if (index==0) {
        if (page<total) {
            
            page++;
            [self requestData];
            
        }else{
            page =total;
            
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.spendingTableView.mj_footer endRefreshingWithNoMoreData];
            
        }
    }else if(index==1){
        if (page2<total2) {
            
            page2++;
            [self requestData1];
            
        }else{
            page2 =total2;
            
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.historyTableView.mj_footer endRefreshingWithNoMoreData];
            
        }
        
        
    }
}


-(void)requestData{
    
    Account *account = [Account shareAccount];
    [account loadAccountFromSanbox];
    NSString *pageStr = [NSString stringWithFormat:@"%li",page];
    NSDictionary *parameters=@{@"userId":account.userName,@"password":account.tempPwd,@"title":@"",@"hqType":@"0",@"page":pageStr,@"rows":@"6"};
    
    [NetRequestClass NetRequestPOSTWithRequestURL:ToBeCirculatedInterface WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
        NSDictionary *dict = returnValue[@"items"];
        NSString *totalStr = dict[@"total"];
        total = totalStr.integerValue;
        NSArray *arr= dict[@"rows"];
        NSArray *temp  = [ApplicationModel mj_objectArrayWithKeyValuesArray:arr];
        
        if ([self.spendingTableView.mj_header isRefreshing]) {
            [self.spendingTableView.dataArry removeAllObjects];
            
        }
        
        [self.spendingTableView.dataArry addObjectsFromArray:temp];
        [self.spendingTableView reloadData];
        [self.spendingTableView.mj_header endRefreshing];
        [self.spendingTableView.mj_footer endRefreshing];
        
        
        //判断有无数据的时候的视图
        if (self.spendingTableView.dataArry.count == 0) {
            
            [self.scrollView addSubview: self.notfindView];
            
        }else{
            [self.notfindView removeFromSuperview];
        }
        
    } WithErrorCodeBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
}

-(void)requestData1{
    
    Account *account = [Account shareAccount];
    [account loadAccountFromSanbox];
    NSString *pageStr = [NSString stringWithFormat:@"%li",page2];
    NSDictionary *parameters=@{@"userId":account.userName,@"password":account.tempPwd,@"title":title2,@"hqType":hqType2,@"page":pageStr,@"rows":@"6"};
    
    [NetRequestClass NetRequestPOSTWithRequestURL:CirculatedHistoryInterface WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
        NSDictionary *dict = returnValue[@"items"];
        NSString *totalStr = dict[@"total"];
        total2 = totalStr.integerValue;
        NSArray *arr= dict[@"rows"];
        NSArray *temp  = [ApplicationModel mj_objectArrayWithKeyValuesArray:arr];

        if ([self.historyTableView.mj_header isRefreshing]) {
            [self.historyTableView.dataArry removeAllObjects];
            
        }
        
        [self.historyTableView.dataArry addObjectsFromArray: temp];
          [self.historyTableView reloadData];
        [self.historyTableView.mj_header endRefreshing];
        [self.historyTableView.mj_footer endRefreshing];
      
        
        //判断有无数据的时候的视图
        if (self.historyTableView.dataArry.count == 0) {
            
            [self.scrollView addSubview: self.passView];
            
        }else{
            [self.passView removeFromSuperview];
        }
        
    } WithErrorCodeBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
}

#pragma  mark InquireVCdelegate
- (void)requestDataByRequirementWithIndex:(NSInteger)searchIndex WithHqType:(NSString *)hqType WithTitle:(NSString *)title{
    if(searchIndex==1){
        hqType2=hqType;
        title2 = title;
        [self.historyTableView.mj_header beginRefreshing];
       
    }
}

@end