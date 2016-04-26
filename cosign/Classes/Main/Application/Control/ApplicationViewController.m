//
//  ApplicationViewController.m
//  cosign
//
//  Created by steve on 15/10/12.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import "ApplicationViewController.h"
#import <HMSegmentedControl.h>
#import "ApplicationsTableView.h"
#import "InquireViewController.h"
#import"NetRequestClass.h"
#import "HDetailsViewController.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "ApplicationModel.h"
#import "NotfindView.h"
#import "LoginViewController.h"
#import "NewApplicationTableViewController.h"

#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/375.0
#define H(y) WinHeight*y/667.0
CGFloat const gestureMinimumTranslation = 6 ;
@interface ApplicationViewController ()<UIScrollViewDelegate,ApplicationsDelegate,UITableViewDelegate,InquireVCdelegate,UIGestureRecognizerDelegate>
{
    NSInteger index,lastIndex;//判断当前显示第几个tableView
    
    NSInteger page, page2,page3;//各个tableview的加载数

    NSInteger total,total2,total3;//各个tableview对应的总的页数

    NSString *title1,*title2,*title3;//各个tableview对应的网络请求所传的字段
    
    NSString *hqType1,*hqType2,*hqType3;//各个tableview对应的网络请求所传的字段
    
    CameraMoveDirection direction;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic ,strong) HMSegmentedControl *segmentedControl;
@property (nonatomic ,strong)ApplicationsTableView *ApplicationstableView;
@property (nonatomic ,strong)ApplicationsTableView *passedTableView;
@property (nonatomic ,strong)ApplicationsTableView *NopassedTableView;
@property (nonatomic ,strong)NotfindView *notfindView;
@property (nonatomic ,strong)NotfindView *nopassView;
@property (nonatomic ,strong)NotfindView *passView;
@property (nonatomic ,strong)NSMutableArray *datalist;
@property (nonatomic,strong)NSMutableArray *secondlist;
@property (nonatomic,strong)NSMutableArray *fourlist;
@property(nonatomic,strong)UIButton *btn;
@property (nonatomic,assign) CGRect openFrame;
@property (nonatomic,assign) CGRect closeFrame;
@property(nonatomic,assign)CGFloat lastScrollOffset;
@property(nonatomic,strong)UIPanGestureRecognizer *panGestureRecognizer;
@end

@implementation ApplicationViewController

//申请中的数组延迟实例化
- (NSMutableArray *)datalist{
    if (!_datalist) {
        _datalist = [[NSMutableArray alloc] init];
    }
    return _datalist;
}
//已通过的数组延迟实例化
- (NSMutableArray *)secondlist{
    if (!_secondlist) {
        _secondlist = [[NSMutableArray alloc] init];
    }
    return _secondlist;
}
//未通过的数组延迟实例化
-(NSMutableArray *)fourlist{
    if (!_fourlist) {
        _fourlist = [[NSMutableArray alloc]init];
        
    }
    return _fourlist;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"我提交的申请";
    page  = 1;
    page2 = 1;
    page3 = 1;
    
    title1=@"";
    title2=@"";
    title3=@"";
    
    hqType1=@"0";
    hqType2=@"0";
    hqType3=@"0";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:ApplicationRefresh object:nil];
    

    [self coustomNavigtion];
    [self setUpSegment];
    [self addApplicationstableView];
    [self  addpassedTableView];
    [self addNopassedTableView];
   // NSLog(@"%@",self.ApplicationstableView.gestureRecognizers);
    self.closeFrame = CGRectMake(self.btn.frame.origin.x, WinHeight, self.btn.frame.size.width , self.btn.frame.size.height);
    self.openFrame = self.btn.frame;
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    self.panGestureRecognizer.maximumNumberOfTouches = 1;
    self.panGestureRecognizer.minimumNumberOfTouches = 1;
    self.panGestureRecognizer.delegate=self;
    [self.ApplicationstableView addGestureRecognizer:self.panGestureRecognizer];
    
    [self.ApplicationstableView beginRefresh];
    [self requestData1];
    [self requestData2];
}

- (void)panGestureAction:(UIPanGestureRecognizer *)recognizer{
    if( ([recognizer state] == UIGestureRecognizerStateBegan) ||
       ([recognizer state] == UIGestureRecognizerStateChanged) )
    {
        
        CGPoint movement = [recognizer translationInView:self.view];
        direction = [self determineCameraDirectionIfNeeded:movement];
        NSLog(@"%li",direction);
        if (direction==kCameraMoveDirectionUp||direction==kCameraMoveDirectionDown) {
            CGRect old_rect = self.btn.frame;
            old_rect.origin.y = old_rect.origin.y + movement.y;
            
            if(old_rect.origin.y < self.openFrame.origin.y)
            {
                self.btn.frame = self.openFrame;
                
                old_rect.origin.y=self.openFrame.origin.y;
                
            }
            else if(old_rect.origin.y > self.closeFrame.origin.y)
            {
                self.btn.frame = self.closeFrame;
                old_rect.origin.y=self.closeFrame.origin.y;
                
            }
            else
            {
                self.btn.frame = old_rect;
            }
            
            
            [recognizer setTranslation:CGPointZero inView:self.view];

        }
        
        
        
        
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
    {
         if (direction==kCameraMoveDirectionUp||direction==kCameraMoveDirectionDown) {
             CGFloat halfPoint = (self.closeFrame.origin.y + self.openFrame.origin.y)/ 2;
             if(self.btn.frame.origin.y > halfPoint)
             {
                 
                 [UIView beginAnimations:nil context:NULL];
                 [UIView setAnimationDuration:0.2];
                 self.btn.frame = self.openFrame;
                 [UIView commitAnimations];
                 
             }
             else
             {
                 
                 [UIView beginAnimations:nil context:NULL];
                 [UIView setAnimationDuration:0.2];
                 self.btn.frame = self.closeFrame;
                 [UIView commitAnimations];
                 
             }

             
         }
        
        
    }
    

}

- ( CameraMoveDirection )determineCameraDirectionIfNeeded:( CGPoint )translation

{
    
//    if (direction != kCameraMoveDirectionNone)
//        
//        return direction;
    
    // determine if horizontal swipe only if you meet some minimum velocity
    
    if (fabs(translation.x) > gestureMinimumTranslation)
        
    {
        
        BOOL gestureHorizontal = NO;
        
        if (translation.y == 0.0 )
            
            gestureHorizontal = YES;
        
        else
            
            gestureHorizontal = (fabs(translation.x / translation.y) > 5.0 );
        
        if (gestureHorizontal)
            
        {
            
            if (translation.x > 0.0 )
                
                return kCameraMoveDirectionRight;
            
            else
                
                return kCameraMoveDirectionLeft;
            
        }
        
    }
    
    // determine if vertical swipe only if you meet some minimum velocity
    
    else if (fabs(translation.y) > gestureMinimumTranslation)
        
    {
        
        BOOL gestureVertical = NO;
        
        if (translation.x == 0.0 )
            
            gestureVertical = YES;
        
        else
            
            gestureVertical = (fabs(translation.y / translation.x) > 5.0 );
        
        if (gestureVertical)
            
        {
            
            if (translation.y > 0.0 )
                
                return kCameraMoveDirectionDown;
            
            else
                
                return kCameraMoveDirectionUp;
            
        }
        
    }
    
    return direction;
    
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    // 输出点击的view的类名
//    
//    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return NO;
//    }
//    return  YES;
//}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {


        return YES;
        ;
    }
    return YES;
}
//通知刷新
- (void)refreshData:(NSNotification *)notification{
    BOOL isRefresh  = [notification.object boolValue];
    if (isRefresh) {
        if (index==0) {
            [self.ApplicationstableView.mj_header beginRefreshing];
            [self.passedTableView.dataList removeAllObjects];
            page2=1;
            [self requestData1];
            
            [self.NopassedTableView.dataList removeAllObjects];
            page3=1;
            [self requestData2];
            
        }else if(index==1){
            [self.passedTableView.mj_header beginRefreshing];
            [self.ApplicationstableView.dataList removeAllObjects];
            page=1;
            [self requestData];
            
            [self.NopassedTableView.dataList removeAllObjects];
            page3=1;
            [self requestData2];
        }else{
            [self.NopassedTableView.mj_header beginRefreshing];
            [self.ApplicationstableView.dataList removeAllObjects];
            page=1;
            [self requestData];
            [self.passedTableView.dataList removeAllObjects];
            page2=1;
            [self requestData1];
        }

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

- (void)setUpSegment{
    //    界面布局，segmentedControl带动画的滑动
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.navigationController.navigationBar.frame) , W(375), 40)];
    self.segmentedControl.sectionTitles = @[@"申请中",@"已通过",@"未通过"];
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
         lastIndex=index;
        index = segIndex;
        CGRect btnFrame ;
        if (index==1&&lastIndex==0) {
            
            btnFrame=weakSelf.btn.frame;
            weakSelf.btn.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:0.3 animations:^{
                
                
                weakSelf.btn.transform = CGAffineTransformMakeScale(0.1, 0.1);
                weakSelf.btn.transform  = CGAffineTransformRotate(weakSelf.btn.transform ,M_PI_2);
                
            } completion:^(BOOL finished) {
                weakSelf.btn.transform =CGAffineTransformMakeScale(0, 0);
                //self.btn.transform = CGAffineTransformIdentity;
            }];
            
        }else if(index==0){
            weakSelf.btn.transform = CGAffineTransformIdentity;
            weakSelf.btn.transform =CGAffineTransformMakeScale(0.1, 0.1);
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.btn.transform  = CGAffineTransformScale(weakSelf.btn.transform, 10, 10);
                weakSelf.btn.transform  = CGAffineTransformRotate(weakSelf.btn.transform ,M_PI_2);
                
            } completion:^(BOOL finished) {
                weakSelf.btn.transform =CGAffineTransformMakeScale(1, 1);
            }];
        }

        [weakSelf.scrollView scrollRectToVisible:CGRectMake(WinWidth * index, 0, WinWidth, 200) animated:YES];
    }];
    
    //一面的动画的大小范围
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.navigationController.navigationBar.frame)+40,self.view.frame.size.width, self.view.frame.size.height-40-CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces=NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    //动画视图的大小范围
    self.scrollView.contentSize = CGSizeMake(WinWidth*3, 200);
    self.scrollView.delegate = self;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, WinWidth, 200) animated:NO];
    [self.view addSubview:self.scrollView];
    
     self.notfindView = [[NotfindView alloc] initWithFrame:  CGRectMake(0,0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)] ;
    
    self.passView = [[NotfindView alloc] initWithFrame:  CGRectMake(self.scrollView.frame.size.width,0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)] ;
    
    self.nopassView = [[NotfindView alloc] initWithFrame:  CGRectMake(self.scrollView.frame.size.width*2,0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)] ;
}


//申请中
-(void)addApplicationstableView{
    
    self.ApplicationstableView = [[ApplicationsTableView alloc] initWithFrame:  CGRectMake(0,0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)] ;
    self.ApplicationstableView.tableFooterView = [[UIView alloc]init];
    self.ApplicationstableView.applicationDelegate =self;
    [self.scrollView addSubview: self.ApplicationstableView];


    self.btn = [[UIButton alloc] init];
    [self.btn setImage:[UIImage imageNamed:@"new_application.png"] forState:UIControlStateNormal];
    self.btn.frame = CGRectMake(W(300), WinHeight-H(100),W(60), H(60));
    
    self.btn.layer.cornerRadius = 10;
    self.btn.layer.shadowOffset = CGSizeMake(4.0f, 4.0f);
    self.btn.layer.shadowOpacity = 0.5;
    self.btn.layer.shadowColor =  [UIColor blackColor].CGColor;
    [self.btn addTarget:self action:@selector(target:) forControlEvents:UIControlEventTouchUpInside];

    [ self.view addSubview:self.btn];

    
}


-(void)target:(UIButton *)button{
    
 
        NewApplicationTableViewController * NewApplicationVC =[[NewApplicationTableViewController alloc]init];
        
        [self.navigationController pushViewController:NewApplicationVC animated:YES];
   
}

//已通过
-(void)addpassedTableView{
    self.passedTableView = [[ApplicationsTableView alloc] initWithFrame:  CGRectMake(self.scrollView.frame.size.width,0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)] ;
    self.passedTableView.applicationDelegate =self;
    [self.scrollView addSubview: self.passedTableView];
 
    self.passedTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    }

//未通过
-(void)addNopassedTableView{

    self.NopassedTableView = [[ApplicationsTableView alloc] initWithFrame:  CGRectMake(self.scrollView.frame.size.width*2,0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)] ;
    self.NopassedTableView.applicationDelegate =self;
    
    [self.scrollView addSubview: self.NopassedTableView];

     self.NopassedTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
}

//导航栏上的搜索按钮
-(void)coustomNavigtion{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -15;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_magnifying_glass.png"] style:UIBarButtonItemStylePlain target:self action:@selector(searchFor:)];
    
    self.navigationItem.rightBarButtonItems =@[negativeSeperator, rightBarButtonItem];
    
    
}

#pragma mark - UIScrollViewDelegate
//动画滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger tempPage = scrollView.contentOffset.x / pageWidth;
    lastIndex=index;
    index =tempPage;
    CGRect btnFrame ;
    
    //申请中的按钮图片动画旋转缩放
    if (index==1&&lastIndex==0) {
        btnFrame=self.btn.frame;
        self.btn.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.3 animations:^{
            
            
            self.btn.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.btn.transform  = CGAffineTransformRotate(self.btn.transform ,M_PI_2);
            
        } completion:^(BOOL finished) {
            self.btn.transform =CGAffineTransformMakeScale(0, 0);
            //self.btn.transform = CGAffineTransformIdentity;
        }];
        
    }else if(index==0){
        self.btn.transform = CGAffineTransformIdentity;
        self.btn.transform =CGAffineTransformMakeScale(0.1, 0.1);
        [UIView animateWithDuration:0.3 animations:^{
            self.btn.transform  = CGAffineTransformScale(self.btn.transform, 10, 10);
            self.btn.transform  = CGAffineTransformRotate(self.btn.transform ,M_PI_2);
            
        } completion:^(BOOL finished) {
            self.btn.transform =CGAffineTransformMakeScale(1, 1);
        }];
    }

    
    
    [self.segmentedControl setSelectedSegmentIndex:tempPage animated:YES];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    
}



//点击搜索按钮的点击事件
-(void)searchFor:(UIButton *)button{
    InquireViewController *vc = [[InquireViewController alloc]init];
    vc.delegate = self;
    vc.index = index;
    [self.navigationController pushViewController:vc animated:YES];

};



#pragma mark  ApplicationsDelegate
//代理点击push下一个页面

- (void)JumpToSecondView:(NSIndexPath *)indexPath{
    
    HDetailsViewController *DetailsVC= [[HDetailsViewController  alloc] init];
    
    if (index ==0) {
         DetailsVC.aModel = self.ApplicationstableView.dataList[indexPath.row];
        NSLog(@"%@",DetailsVC.aModel.userName);
        
    }
    else if (index ==1){
    
        DetailsVC.aModel = self.passedTableView.dataList[indexPath.row];
    }
    else if (index ==2){
    
         DetailsVC.aModel = self.NopassedTableView.dataList[indexPath.row];
    }
     DetailsVC.appIndex =index;
    [self.navigationController pushViewController:DetailsVC animated:YES];
}

//刷新
- (void)loadNewData{

    if (index==0) {
        [self.notfindView removeFromSuperview];
        page=1;
        [self requestData];
    }else if(index==1){
        [self.passView removeFromSuperview];
        page2=1;
       
        [self requestData1];
    }else{
        
        [self.nopassView removeFromSuperview];
        page3=1;
        [self requestData2];
   
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
            [self.ApplicationstableView.mj_footer endRefreshingWithNoMoreData];
            
        }
    }else if(index==1){
        if (page2<total2) {
            
            page2++;
            [self requestData1];
            
        }else{
            page2 =total2;
            
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.passedTableView.mj_footer endRefreshingWithNoMoreData];
            
        }

        
    }else{
        
        if (page3<total3) {
            
            page3++;
            
            [self requestData2];
            
        }else{
            page3 =total3;
            
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.NopassedTableView.mj_footer endRefreshingWithNoMoreData];
            
        }
        
    }
    
}

-(void)requestData{
    
    Account *account = [Account shareAccount];
    [account loadAccountFromSanbox];
    NSString *pageStr = [NSString stringWithFormat:@"%li",page];
    NSDictionary *parameters=@{@"userId":account.userName,
                               @"password":account.tempPwd,
                               @"title":title1,
                               @"hqType":hqType1,
                               @"page":pageStr,
                               @"rows":@"6"
                               };
 
    [NetRequestClass NetRequestPOSTWithRequestURL:ApplicaionInteface WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
        NSDictionary *dict = returnValue[@"items"];
        
        NSString *totalStr = dict[@"total"];
        total = totalStr.integerValue;
        
        NSArray *arr= dict[@"rows"];
        NSArray *temp  = [ApplicationModel mj_objectArrayWithKeyValuesArray:arr];
        
        if ([self.ApplicationstableView.mj_header isRefreshing]) {
            [self.ApplicationstableView.dataList removeAllObjects];
            
        }
        
        [self.ApplicationstableView.dataList addObjectsFromArray:temp];
        [self.ApplicationstableView reloadData];
        [self.ApplicationstableView.mj_header endRefreshing];
        [self.ApplicationstableView.mj_footer endRefreshing];
        
        //判断有无数据的时候的视图
        if (self.ApplicationstableView.dataList.count == 0) {
            [self.scrollView  addSubview:self.notfindView];
            self.btn.frame=self.openFrame;
            [self.view addSubview:self.btn];
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
    
    NSDictionary *parameters=@{@"userId":account.userName,
                               @"password":account.tempPwd,
                               @"title":title2,
                               @"hqType":hqType2,
                               @"page":pageStr,
                               @"rows":@"6",
                              
                               };

    [NetRequestClass NetRequestPOSTWithRequestURL:PassedInterface WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
        NSDictionary *dict = returnValue[@"items"];
        NSArray *arr= dict[@"rows"];
        
        NSString *totalStr = dict[@"total"];
        total2 = totalStr.integerValue;
        
        NSArray *temp  = [ApplicationModel mj_objectArrayWithKeyValuesArray:arr];
        
        if ([self.passedTableView.mj_header isRefreshing]) {
            [self.passedTableView.dataList removeAllObjects];
            
        }
        [self.passedTableView.dataList addObjectsFromArray:temp];
        
         [self.passedTableView reloadData];
        [self.passedTableView.mj_header endRefreshing];
        [self.passedTableView.mj_footer endRefreshing];
       
        //判断有无数据的时候的视图
        if (self.passedTableView.dataList.count == 0) {
     
            [self.scrollView addSubview: self.passView];
        }else{
            [self.passView removeFromSuperview];
        }
    } WithErrorCodeBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
}


-(void)requestData2{
    
    Account *account = [Account shareAccount];
    [account loadAccountFromSanbox];
    NSString *pageStr = [NSString stringWithFormat:@"%li",page3];
    NSDictionary *parameters=@{@"userId":account.userName,
                               @"password":account.tempPwd,
                               @"title":title3,
                               @"hqType":hqType3,
                               @"page":pageStr,
                               @"rows":@"6",
                               
                               };
 
    [NetRequestClass NetRequestPOSTWithRequestURL:NoPassedInterface WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
        NSDictionary *dict = returnValue[@"items"];
        NSArray *arr= dict[@"rows"];
        
        NSString *totalStr = dict[@"total"];
        total3 = totalStr.integerValue;
        
        NSArray *temp  = [ApplicationModel mj_objectArrayWithKeyValuesArray:arr];
        
        if ([self.NopassedTableView.mj_header isRefreshing]) {
            [self.NopassedTableView.dataList removeAllObjects];
            
        }
        
        [self.NopassedTableView.dataList addObjectsFromArray:temp];
        [self.NopassedTableView reloadData];
        [self.NopassedTableView.mj_header endRefreshing];
        [self.NopassedTableView.mj_footer endRefreshing];
        
        //判断有无数据的时候的视图
        if (self.NopassedTableView.dataList.count == 0) {
            
            
            [self.scrollView addSubview: self.nopassView];
        }else{
            [self.nopassView removeFromSuperview];
        }
        
    } WithErrorCodeBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
}


#pragma  mark InquireVCdelegate
- (void)requestDataByRequirementWithIndex:(NSInteger)searchIndex WithHqType:(NSString *)hqType WithTitle:(NSString *)title{
    if (searchIndex==0) {
        hqType1=hqType;
        title1 = title;
      
        [self.ApplicationstableView.mj_header beginRefreshing];

        
    }else if(searchIndex==1){
        hqType2=hqType;
        title2 = title;
        [self.passedTableView.mj_header beginRefreshing];
   
    }else{
        hqType3=hqType;
        title3 = title;

        [self.NopassedTableView.mj_header beginRefreshing];


    }
}

@end
