//
//  AcknowledgerViewController.m
//  cosign
//
//  Created by mac on 15/11/13.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import "AcknowledgerViewController.h"
#import <HMSegmentedControl.h>
#import"NetRequestClass.h"
#import "NewApplicationModel.h"
#import "NotfindView.h"
#import "AcknowledgerTableView.h"
#import "RcirculatedTableView.h"
#import "ContactsTableView.h"
#import "ContactsSelectedPanel.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/375.0
#define H(y) WinHeight*y/667.0


@interface AcknowledgerViewController ()<UITableViewDelegate,UIScrollViewDelegate,ContactsSelectedPanelDelegate>{

    NSInteger index;
    NSInteger page1;//各个tableview的加载数
    
    NSInteger total1;//各个tableview对应的总的页数

}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic ,strong) HMSegmentedControl *segmentedControl;
@property (nonatomic ,strong) UIButton *rightBtn;
@property(nonatomic,strong)ContactsTableView *contactsTableView;
@property(nonatomic,strong)NotfindView *notfindView1;
@property(nonatomic,strong)NotfindView *notfindView2;
@property(nonatomic,strong)RcirculatedTableView *circulatedTableView;
@property(nonatomic,strong)ContactsSelectedPanel *selectedPanel;
@end

@implementation AcknowledgerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    page1=1;
    self.title = @"选择传阅人";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNavBar];
    [self setUpSegment];
    
    [self customNavigationItem];
    
    [self addacknowledgerTableView];
    [self addcirculatedTableView];
    
    [self.contactsTableView.mj_header beginRefreshing];
    [self requestData1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (void)setUpBackBtn{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)setUpSegment{
    //    界面布局，segmentedControl带动画的滑动
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.navigationController.navigationBar.frame) , W(375), 40)];
    self.segmentedControl.sectionTitles = @[@"传阅人列表",@"最近传阅人列表"];
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
    
    
    
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger segIndex) {
        
        index = segIndex;
        
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
    
    self.notfindView1 = [[NotfindView alloc] initWithFrame:  CGRectMake(0,0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)] ;
    
    self.notfindView2 = [[NotfindView alloc] initWithFrame:  CGRectMake(self.scrollView.frame.size.width,0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)] ;
    
}

#pragma mark - UIScrollViewDelegate
//动画滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger tempPage = scrollView.contentOffset.x / pageWidth;
    
    index =tempPage;
    
    [self.segmentedControl setSelectedSegmentIndex:tempPage animated:YES];
}



//导航栏上的按钮
-(void)customNavigationItem{
    
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -10;
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ self.rightBtn setTitle:@"确认" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(myButton:)
            forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    self.rightBtn.frame = CGRectMake(0, 0, 50,20);
    UIBarButtonItem *rightBarBtn= [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItems = @[negativeSeperator,rightBarBtn];
    
    
}

//点击确定，代理传值
-(void)myButton:(UIButton *)button{
    if (index ==0){
        
        NSMutableArray *tempArr=[[NSMutableArray alloc] init];
        NSMutableArray *tempArr1=[[NSMutableArray alloc] init];
        [self.contactsTableView.selectedArr enumerateObjectsUsingBlock:^(Userinfos *usefInfo, NSUInteger idx, BOOL *stop) {
            
            [tempArr addObject:usefInfo.userName];
            [tempArr1 addObject:usefInfo.userId];
        }];
        
        NSString *str=[tempArr componentsJoinedByString:@","];
        NSString *str1 = [tempArr1 componentsJoinedByString:@","];
        
        [self.AcknowlegeDelegate changesTitle:str andUserId:str1];
        
        if (self.AcknowlegeDelegate &&[self.AcknowlegeDelegate respondsToSelector:@selector(acknowlegePassData:)]) {
            [self.AcknowlegeDelegate acknowlegePassData:self.contactsTableView.selectedArr];
        }
        
        [self.navigationController popViewControllerAnimated:YES];

        
    }
    if (index ==1) {
        
       [self.AcknowlegeDelegate changesTitle:self.circulatedTableView.cosignStr andUserId:self.circulatedTableView.userIdStr];

        [self.navigationController popViewControllerAnimated:YES];
    }
 
}

//会签人列表
-(void)addacknowledgerTableView{
    self.contactsTableView= [[ContactsTableView alloc] initWithFrame:  CGRectMake(0,0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)] ;
    
    self.selectedPanel = [[ContactsSelectedPanel alloc ] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 58)];
    self.selectedPanel.delegate = self;
    
    if (self.contactsArr.count) {
        self.contactsTableView.selectedArr = [self.contactsArr mutableCopy];
        [self.scrollView addSubview:self.selectedPanel];
        
        self.contactsTableView.frame = CGRectMake(0,58, self.scrollView.frame.size.width, self.scrollView.frame.size.height-58);
        self.selectedPanel.selectedItems = self.contactsTableView.selectedArr;
    }
    
    [self.scrollView addSubview: self.contactsTableView];
    
    self.contactsTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.contactsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadLastData方法）
    self.contactsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDate)];
    
    __weak typeof(self)weakself = self;
    self.contactsTableView.addSelectedUser=^(NSInteger num){
        if (num==0) {
            [weakself.scrollView addSubview:weakself.selectedPanel];
            weakself.contactsTableView.frame = CGRectMake(0,58, weakself.scrollView.frame.size.width, self.scrollView.frame.size.height-58);
            weakself.selectedPanel.selectedItems = weakself.contactsTableView.selectedArr;
        }else{
            [weakself.selectedPanel didAddSelectedIndex:weakself.contactsTableView.selectedArr.count-1];
        }
        
    };
    
    self.contactsTableView.deleteSelectedUser=^(NSInteger location){
        [weakself.selectedPanel didDeleteSelectedIndex:location];
        if (weakself.contactsTableView.selectedArr.count==0) {
            [weakself.selectedPanel removeFromSuperview];
            weakself.contactsTableView.frame = CGRectMake(0,0, weakself.scrollView.frame.size.width, weakself.scrollView.frame.size.height);
        }
    };
    


}

#pragma mark ContactsSelectedPanelDelegate
- (void)willDeleteRowWithItem:(Userinfos *)user withMultiSelectedPanel:(ContactsSelectedPanel *)multiSelectedPanel{
    //在此做对数组元素的删除工作
    int index1=-1;
    for (int i =0 ;i<self.contactsTableView.selectedArr.count;i++) {
        Userinfos *obj =self.contactsTableView.selectedArr[i];
        if ([obj.userId isEqualToString:user.userId]) {
            index1 =i;
            break;
        }
    }
    if (index1==-1) {
        return;
    }
    
    [self.contactsTableView.selectedArr removeObjectAtIndex:index1];
    if (self.contactsTableView.selectedIndexes.count) {
        NSIndexPath *indexPath = self.contactsTableView.selectedIndexes[index1];
        UITableViewCell *cell = [self.contactsTableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType =UITableViewCellAccessoryNone;
        [self.contactsTableView.selectedIndexes removeObject:indexPath];
    }
    
    
    if (self.contactsTableView.selectedArr.count==0) {
        [self.selectedPanel removeFromSuperview];
        self.contactsTableView.frame = CGRectMake(0,0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self.contactsTableView reloadData];
        
    }else{
        [self.contactsTableView reloadData];
    }
}


//最近联系人列表
-(void)addcirculatedTableView{
    self.circulatedTableView = [[RcirculatedTableView alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    
    [self.scrollView addSubview:self.circulatedTableView];
    
    
    self.circulatedTableView.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
//    self.circulatedTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self loadNewData];
//    }];
//    
//    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadLastData方法）
//    self.circulatedTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDate)];

}

//刷新
- (void)loadNewData{
    
    if (index==0) {
        [self.notfindView1 removeFromSuperview];
        page1=1;
        [self requestData];
    }else if(index==1){
        [self.notfindView2 removeFromSuperview];
        
        [self requestData1];
    }
}

//加载
- (void)loadMoreDate{
    if (index==0) {
        if (page1<total1) {
            
            page1++;
            [self requestData];
            
        }else{
            page1 =total1;
            
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.contactsTableView.mj_footer endRefreshingWithNoMoreData];
            
        }
    }else if(index==1){

            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.circulatedTableView.mj_footer endRefreshingWithNoMoreData];
        
    }
}


-(void)requestData{
    
    Account *account = [Account shareAccount];
    [account loadAccountFromSanbox];
    NSString *pageStr = [NSString stringWithFormat:@"%li",page1];
    
    NSDictionary *parameters=@{@"userId":account.userName,
                               @"password":account.tempPwd,
                               @"platform":@"2",
                               @"roleId":@"3",
                               @"page":pageStr,
                               @"rows":@"10",
                               };
    
    [NetRequestClass NetRequestPOSTWithRequestURL:CountersignedInterface WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
        NSDictionary *dict = returnValue[@"items"];
        total1 = [dict[@"total"] integerValue];
        NSArray *temp  = [ApprovalPeopleModel mj_objectArrayWithKeyValuesArray:dict[@"rows"]];
        
        if ([self.contactsTableView.mj_header isRefreshing]) {
            [self.contactsTableView.dataArry removeAllObjects];
            
        }
        
        [self.contactsTableView.dataArry addObjectsFromArray:temp];
        
        [self.contactsTableView reloadData];
        [self.contactsTableView.mj_header endRefreshing];
        [self.contactsTableView.mj_footer endRefreshing];
        //判断有无数据的时候的视图
        if (self.contactsTableView.dataArry.count == 0) {
            
            [self.scrollView addSubview: self.notfindView1];
            
        }else{
            [self.notfindView1 removeFromSuperview];
        }
        
    } WithErrorCodeBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
}


-(void)requestData1{
    
    Account *account = [Account shareAccount];
    [account loadAccountFromSanbox];
    
    NSDictionary*parameters=@{@"userId":account.userName,
                              @"password":account.tempPwd,
                              @"platform":@"2",
                              @"size":@"6"
                              };
    
    [NetRequestClass NetRequestPOSTWithRequestURL:AcknowledgerInterface WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
        NSDictionary *dict = returnValue[@"items"];
        
        NSArray *temp  = [NewApplicationModel mj_objectArrayWithKeyValuesArray:dict];
        if ([self.circulatedTableView.mj_header isRefreshing]) {
            
            [self.circulatedTableView.approverArr removeAllObjects];
            
        }

        [self.circulatedTableView.approverArr addObjectsFromArray:temp];
        
        [self.circulatedTableView reloadData];
//        [self.circulatedTableView.mj_header endRefreshing];
//        [self.circulatedTableView.mj_footer endRefreshing];
        
        //判断有无数据的时候的视图
        if (self.circulatedTableView.approverArr.count == 0) {
            
            [self.scrollView addSubview: self.notfindView2];
            
        }else{
            
            [self.notfindView2 removeFromSuperview];
            
        }
        
    } WithErrorCodeBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
}



@end
