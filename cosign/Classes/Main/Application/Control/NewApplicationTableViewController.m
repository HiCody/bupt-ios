//
//  NewApplicationTableViewController.m
//  cosign
//
//  Created by mac on 15/11/11.
//  Copyright © 2015年 YuanTu. All rights reserved.
//
#import "NewApplicationTableViewController.h"
#import "ContactsViewController.h"
#import "MattersListViewController.h"
#import "NewApplicationBottomView.h"
#import "AcknowledgerViewController.h"
#import "CustomAlbumsCell.h"
#import "CustomPhotoViewController.h"
#import "GJCFAssetsPickerViewController.h"
#import "GJCFMyCustomStyle.h"
#import "MattersTableViewController.h"
#import "MultiSelectedPanel.h"
#import "PhotoInfo.h"
#import "GJCFAsset.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <Photos/Photos.h>
#import <SDImageCache.h>
#import <MWCommon.h>
#import <MWPhotoBrowser.h>
#import "UserInfo.h"
#import "ConfirmSignModel.h"
#import "UIImage+fixOrientation.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0
#define TOOLBAR_BUTTON_HEIGHT 36
#define TOOLBAR_BUTTON_WIDTH  42

@interface NewApplicationTableViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,ContactsDelegate,MattersDelegate,AcknowlegeDelegate,GJCFAssetsPickerViewControllerDelegate,UINavigationBarDelegate,UIImagePickerControllerDelegate,MultiSelectedPanelDelegate,MWPhotoBrowserDelegate,UINavigationControllerDelegate>{
    CGFloat _previousTextViewContentHeight;
    NSDictionary *_info;
    dispatch_queue_t _serialQueue;
    NSInteger lastCount;
    
}
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic,strong)NSMutableArray *currentSelectedAssetsArray;
@property(nonatomic,strong)UIButton * rightBtn;
@property(nonatomic,strong)UITextField *nameText;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UILabel *numLabel;
@property (nonatomic,strong)UIButton *attachmentBtn;
@property (nonatomic,strong)UILabel *thirdLabel;

@property (strong, nonatomic) UIButton *attachBtn;

@property (nonatomic,strong)UIView *bottomView;

@property (strong, nonatomic) UIView *toolbarView;
@property(nonatomic,strong)UITableView *tableView;
@property (strong,nonatomic ) UIView *toolBar;
@property(strong,nonatomic)UIButton *photoButton;
@property(strong,nonatomic)UIButton *takePicButton;
@property(strong,nonatomic)MultiSelectedPanel *panel;
@property(nonatomic,strong)ALAssetsLibrary* assetslibrary;
@property(nonatomic,strong)NSMutableArray *fileNameArr;
@property(nonatomic,strong)MBProgressHUD *hud;
/**
 *  底部扩展页面
 */
@property (nonatomic) BOOL isShowButtomView;
@property (strong, nonatomic) UIView *activityButtomView;//当前活跃的底部扩展页面
@property (nonatomic,strong)UIImagePickerController *imagePicker;

@property (nonatomic,strong)ConfirmSignModel *confirmSign;

@property (nonatomic,strong)NSArray *contactsArr;//审批人数组
@property (nonatomic,strong)NSArray *acknowlegeArr;//传阅人数组
@end

@implementation NewApplicationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新申请";
    lastCount=1;
    self.assetslibrary = [[ALAssetsLibrary alloc] init];
    self.confirmSign  = [[ConfirmSignModel alloc] init];
    self.confirmSign.userId  =[Account shareAccount].userName;
    self.confirmSign.password  =[Account shareAccount].tempPwd;
    [self setUpNavBar];
    [self customNavigationItem];
    [self configTableView];
    [self setupConfigure];
    [self setUpPickerView];
    
    //键盘的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (NSMutableArray *)fileNameArr{
    if (!_fileNameArr) {
        _fileNameArr = [[NSMutableArray alloc] init];
    }
    return _fileNameArr;
}

- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

- (NSMutableArray *)currentSelectedAssetsArray{
    if (!_currentSelectedAssetsArray) {
        _currentSelectedAssetsArray = [[NSMutableArray alloc] init];
    }
    return _currentSelectedAssetsArray;
}

- (dispatch_queue_t)serialQueue
{
    if (!_serialQueue) {
        _serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);//创建串行队列
    }
    return _serialQueue;
}

-(void)setUpPickerView{
    [GJCFAssetsPickerStyle removeCustomStyleByKey:@"GJCFMyCustomStyle"];
    
    GJCFMyCustomStyle *customStyle = [[GJCFMyCustomStyle alloc]init];
    [GJCFAssetsPickerStyle appendCustomStyle:customStyle forKey:@"GJCFMyCustomStyle"];
    
}

- (void)configTableView{
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, W(180), 44)];
    self.thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, W(200), 44)];
    self.numLabel= [[UILabel alloc]initWithFrame:CGRectMake(100, 0, W(200), 44)];
    self.nameText = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, W(200), 44)];
    self.nameText.delegate = self;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    //底部的textView
    self.textView = [[XHMessageTextView alloc] initWithFrame:CGRectMake(10, 0, WinWidth, 300)];
    self.textView.delegate=self;
    self.textView.font = [UIFont systemFontOfSize:16.0];
    self.textView.placeHolder = @"请输入主题内容";
    self.tableView.tableFooterView = self.textView;
    [self.view addSubview:self.tableView];
    
    //自定义分割线
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
    view3.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:223/255.0 alpha:1.0];
    [self.textView addSubview:view3];
    
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

//导航栏上的按钮
-(void)customNavigationItem{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -10;
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ self.rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:(@selector(trueExpression:))
            forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    self.rightBtn.frame = CGRectMake(0, 0, 50,20);
    UIBarButtonItem *rightBarBtn= [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItems = @[negativeSeperator,rightBarBtn];
    
    
}


#pragma mark 提交审批
-(void)trueExpression:(UIButton *)button{
    
    if (self.label.text.length==0) {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择审批人" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else if (self.numLabel.text.length==0) {
        
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择会签类型" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else if(self.nameText.text.length==0){
        
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写主题内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else{
        [self.view endEditing:YES];
        [self willShowBottomHeight:0];
        
        self.hud =  [MBProgressHUD showMessage:@"正在上传中..."];
        
        if (self.currentSelectedAssetsArray.count) {
            
            [self uploadFile];
        }else{
            [self confirmSignUpload];
        }
        
        
    }
    
}


#pragma mark 上传附件
- (void)uploadFile{
    NSDictionary *parameters = @{@"userId":self.confirmSign.userId,
                                 @"password":self.confirmSign.password,
                                 @"platform":@"2",
                                 
                                 };
    
    for (int i=0; i<self.currentSelectedAssetsArray.count; i++) {
        dispatch_async([self serialQueue], ^{
            dispatch_suspend([self serialQueue]);
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager.requestSerializer setValue:@"true" forHTTPHeaderField:@"IsMobile"];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            [manager POST:UploadFileInterface parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                PhotoInfo *photoInfo =  self.currentSelectedAssetsArray[i];
                
                NSData *data = UIImageJPEGRepresentation([photoInfo.defaultImage fixOrientation],0.1) ;
                CGFloat length = [data length]/1000;
                NSString  *jpgPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                
                jpgPath = [jpgPath stringByAppendingPathComponent:photoInfo.imgName];
                [data writeToFile:jpgPath atomically:YES];
                photoInfo.path  = jpgPath;
                // 将本地的文件上传至服务器
                NSURL *fileURL = [NSURL fileURLWithPath:photoInfo.path];
                
                [formData appendPartWithFileURL:fileURL name:@"upload" fileName:photoInfo.imgName mimeType:@"image/jpeg" error:nil];
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                NSLog(@"%@",dic);
                dispatch_resume([self serialQueue]);
                [self.fileNameArr addObject:dic[@"fileName"]];
                if (i ==self.currentSelectedAssetsArray.count-1) {
                    self.confirmSign.fileUrls =[self.fileNameArr componentsJoinedByString:@"|"];
                    [self confirmSignUpload];
                }
                
                NSLog(@"完成 %@", result);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self.fileNameArr removeAllObjects];
                self.hud.hidden=YES;
                [MBProgressHUD showError:@"上传失败" toView:self.view];
                NSLog(@"错误 %@", error.localizedDescription);
            }];
            
            
            
        });
    }
    
    
}

- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

- (void)confirmSignUpload{
    
    self.confirmSign.id = @"0";
    self.confirmSign.title = self.nameText.text;
    self.confirmSign.contents =self.textView.text;
    if (self.label.text.length==0) {
        self.confirmSign.checkers=@"";
    }
    if (self.thirdLabel.text.length==0) {
        self.confirmSign.readers=@"";
    }
    if (self.currentSelectedAssetsArray.count==0) {
        
        self.confirmSign.fileUrls=@"";
        
    }
    NSDictionary *parameters =@{@"userId":self.confirmSign.userId,
                                @"password":self.confirmSign.password,
                                @"platform":@"2",
                                @"id":self.confirmSign.id,
                                @"title":self.confirmSign.title,
                                @"contents":self.confirmSign.contents,
                                @"hqType":self.confirmSign.hqType,
                                @"fileUrls":self.confirmSign.fileUrls,
                                @"checkers":self.confirmSign.checkers,
                                @"readers":self.confirmSign.readers,
                                };
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:ConfirmSignInterface parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } error:nil];
    [request setValue:@"true" forHTTPHeaderField:@"IsMobile"];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            self.hud.hidden=YES;
            [self.fileNameArr removeAllObjects];
            [MBProgressHUD showError:@"上传失败" toView:self.view];
            NSLog(@"Error: %@", error);
        } else {
            
            NSLog(@"%@ %@", response, responseObject);
            [[NSNotificationCenter defaultCenter] postNotificationName:ApplicationRefresh object:@YES];
            
            [self.navigationController  popViewControllerAnimated:YES];
            self.hud.hidden=YES;
            [MBProgressHUD showSuccess:@"上传成功"];
            
        }
    }];
    
    [uploadTask resume];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.attachBtn.selected=NO;
    
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
    
    return 5;
}

//返回每行cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //1,定义一个共同的标识
    static NSString *ID = @"cell";
    //2,从缓存中取出可循环利用的cell
    UITableViewCell *cell; //=  [tableView dequeueReusableCellWithIdentifier:ID];
    //3,如果缓存中没有可利用的cell，新建一个。
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.textLabel.text =  @"提  交  人 :";
        cell.textLabel.textColor =  [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        UserInfo *usreInfo = [UserInfo shareUserInfo];
        UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, W(200), 44)];
        firstLabel.text =usreInfo.userName;
        NSLog(@"%@",usreInfo.userName);
        firstLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:firstLabel];
    }
    if (indexPath.row == 1) {
        cell.textLabel.text =  @"事项类型 :";
        cell.textLabel.textColor =  [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        
        // self.numLabel.text =;
        self.numLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview: self.numLabel];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        
    }
    if (indexPath.row ==2) {
        
        cell.textLabel.text =  @"审  批  人 :";
        cell.textLabel.textColor =  [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        self.label.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:self.label];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        
    }
    if (indexPath.row ==3) {
        
        cell.textLabel.text =  @"传  阅  人 :";
        cell.textLabel.textColor =  [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        
        // self.thirdLabel.text =@"";
        self.thirdLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:self.thirdLabel];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        
    }
    if (indexPath.row ==4) {
        cell.textLabel.text =  @"主       题 :";
        cell.textLabel.textColor =  [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        
        self.nameText.delegate = self;
        self.nameText.backgroundColor = [UIColor whiteColor];
        self.nameText.placeholder = @"请输入主题";
        [cell.contentView addSubview:self.nameText];
        
        
    }
    
    
    return cell;
}


//返回cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

//选中某行做某事
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==1) {
        MattersTableViewController *MattersVC = [[MattersTableViewController alloc]init];
        
        MattersVC.MattersDelegate =self;
        if (self.numLabel.text.length) {
            MattersVC.matterTypeStr   =self.numLabel.text;
        }

        [self.navigationController pushViewController:MattersVC animated:YES];

           }
    if (indexPath.row ==2) {
        
        ContactsViewController *ContactsVC = [[ContactsViewController alloc]init];
        ContactsVC.contactsArr = self.contactsArr;
        ContactsVC.ContactsDelegate=self;
        [self.navigationController pushViewController:ContactsVC animated:YES];
        
    }
    
    if (indexPath.row ==3) {
        
        AcknowledgerViewController *AcknowledgerVC =[[AcknowledgerViewController alloc]init];
        AcknowledgerVC.contactsArr  =self.acknowlegeArr;
        AcknowledgerVC.AcknowlegeDelegate =self;
        [self.navigationController pushViewController:AcknowledgerVC animated:YES];
        

    }
    
}

//审批人代理传值
- (void)changeTitle:(NSString *)title andUserId:(NSString *)userId{
    
    self.label.text = title ;
    
    self.confirmSign.checkers = userId;
    
}

- (void)contactsPassData:(NSArray *)arr{
    
    self.contactsArr  =arr;
}

- (void)acknowlegePassData:(NSArray *)arr{
    
    self.acknowlegeArr = arr;
}

//抄送人代理传值
- (void)changesTitle:(NSString *)title andUserId:(NSString *)userId{
    
    self.thirdLabel.text = title ;
    self.confirmSign.readers = userId;
}


//事项类型代理传值
- (void)changeTitle:(NSString *)title WithValue:(NSInteger)integer {
    
    self.numLabel.text = title ;
    self.confirmSign.hqType = [NSString stringWithFormat:@"%li",integer];
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}

#pragma mark - UIKeyboardNotification

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    void(^animations)() = ^{
        [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
        
    };
    
    void(^completion)(BOOL) = ^(BOOL finished){
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
}

- (void)setupConfigure{
    self.activityButtomView = nil;
    self.isShowButtomView = NO;
    self.toolBar  = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40)];
    self.toolBar.backgroundColor = [UIColor clearColor];
    self.toolbarView = [[UIView alloc] init];
    self.toolbarView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    self.toolbarView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.toolBar];
    [self.toolBar addSubview:self.toolbarView];
    [self setupSubviews];
}

- (void)setupSubviews
{
    //更多
    self.attachBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-70, 5, 55, 30)];
    self.attachBtn.backgroundColor=[UIColor clearColor];
    self.attachBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.attachBtn setImage:[UIImage imageNamed:@"btn_attach_normal"] forState:UIControlStateNormal];
    
    [self.attachBtn setImage:[UIImage imageNamed:@"btn_attach_selected"] forState:UIControlStateSelected];
    [self.attachBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.attachBtn.tag = 2;
    
    [self.toolbarView addSubview:self.attachBtn];
    
    if (!self.bottomView) {
        [self configBottomView];
    }
    
}

- (void)configBottomView{
    self.bottomView = [[UIView alloc] init];
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 36+7+7)];
    UIImageView *bgImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbar_bg"]];
    bgImgView.frame=CGRectMake(0, 0, self.view.frame.size.width, 36+7+7);
    [toolBar addSubview:bgImgView];
    
    self.bottomView.backgroundColor = [UIColor clearColor];
    CGFloat insets = 30;
    
    self.photoButton =[[UIButton alloc] init];
    self.photoButton.frame=CGRectMake(insets, 7, TOOLBAR_BUTTON_WIDTH, TOOLBAR_BUTTON_HEIGHT);
    [self.photoButton setImage:[UIImage imageNamed:@"icon_attach_toolbar_album"] forState:UIControlStateNormal];
    [self.photoButton setImage:[UIImage imageNamed:@"icon_attach_toolbar_album_highlighted"] forState:UIControlStateHighlighted];
    [self.photoButton addTarget:self action:@selector(photoAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.takePicButton =[[UIButton alloc] init];
    [self.takePicButton setFrame:CGRectMake(CGRectGetMaxX(self.photoButton.frame)+40, 7, TOOLBAR_BUTTON_WIDTH , TOOLBAR_BUTTON_HEIGHT)];
    [self.takePicButton setImage:[UIImage imageNamed:@"icon_attach_toolbar_camera"] forState:UIControlStateNormal];
    [self.takePicButton setImage:[UIImage imageNamed:@"icon_attach_toolbar_camera_highlighted"] forState:UIControlStateHighlighted];
    [self.takePicButton addTarget:self action:@selector(takePicAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [toolBar addSubview:self.photoButton];
    [toolBar addSubview:self.takePicButton];
    
    UIImageView *bottomView1=[[UIImageView alloc] initWithFrame:CGRectMake(0, toolBar.frame.size.height-1,self.view.frame.size.width, 150)];
    bottomView1.image=[UIImage imageNamed:@"toolbar_bg"];
    
    self.panel = [[MultiSelectedPanel alloc] initWithFrame:CGRectMake(0,toolBar.frame.size.height,self.view.frame.size.width, 150)];
    self.panel.backgroundColor = [UIColor clearColor];
    
    self.panel.delegate=self;
    self.panel.selectedItems = self.currentSelectedAssetsArray;
    
    
    [self.bottomView addSubview:bottomView1];
    [self.bottomView addSubview:toolBar];
    [self.bottomView addSubview:self.panel];
    self.bottomView.frame = CGRectMake(0, 0, self.view.frame.size.width, bottomView1.frame.size.height+toolBar.frame.size.height);
    
}

#pragma mark - action

- (void)buttonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    if (button.selected) {
        [self.view endEditing:YES];
        
        [self willShowBottomView:self.bottomView];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        button.selected = NO;
        [self.textView becomeFirstResponder];
    }
    
}

#pragma mark - change frame

- (void)willShowBottomHeight:(CGFloat)bottomHeight
{
    CGRect fromFrame = self.toolBar.frame;
    CGFloat toHeight = self.toolbarView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    
    //如果需要将所有扩展页面都隐藏，而此时已经隐藏了所有扩展页面，则不进行任何操作
    if(bottomHeight == 0 && self.toolBar.frame.size.height == self.toolbarView.frame.size.height)
    {
        return;
    }
    
    if (bottomHeight == 0) {
        self.isShowButtomView = NO;
    }
    else{
        self.isShowButtomView = YES;
    }
    
    self.toolBar.frame = toFrame;
    
    [self didChangeFrameToHeight:toHeight/2];
    
}

- (void)willShowBottomView:(UIView *)bottomView
{
    if (![self.activityButtomView isEqual:bottomView]) {
        CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
        [self willShowBottomHeight:bottomHeight];
        
        if (bottomView) {
            CGRect rect = bottomView.frame;
            rect.origin.y = CGRectGetMaxY(self.toolbarView.frame);
            bottomView.frame = rect;
            [self.toolBar addSubview:bottomView];
        }
        
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = bottomView;
    }
}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        //一定要把self.activityButtomView置为空
        [self willShowBottomHeight:toFrame.size.height];
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = nil;
    }
    else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        [self willShowBottomHeight:0];
    }
    else{
        [self willShowBottomHeight:toFrame.size.height];
    }
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.tableView.frame;
        rect.origin.y = 0;
        rect.size.height = self.view.frame.size.height - toHeight;
        self.tableView.frame = rect;
    }];
    [self scrollViewToBottom:NO];
}

- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self willShowBottomHeight:0];
    [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    self.attachBtn.selected=NO;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    
    //    CGSize size = [textView.text sizeWithFont:[textView font]];
    //    int length = size.height;
    //    int colomNumber = textView.contentSize.height/length;
    //
    //    if (lastCount!=colomNumber) {
    //          NSLog(@"111");
    //
    //        [textView.text string]
    //    }
    //
    //    lastCount  = colomNumber;
    //
    
    //[self willShowInputTextViewToHeight:[self getTextViewContentH:textView]];
}

- (void)willShowInputTextViewToHeight:(CGFloat)toHeight
{
    if (toHeight == _previousTextViewContentHeight)
    {
        return;
    }
    else{
        CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
        
        CGRect rect = self.view.frame;
        rect.size.height -= changeHeight;
        rect.origin.y += changeHeight;
        self.textView.frame = rect;
        
        rect = self.toolbarView.frame;
        rect.size.height -= changeHeight;
        self.textView.frame = rect;
        
        _previousTextViewContentHeight = toHeight;
        
        
        [self didChangeFrameToHeight:self.textView.frame.size.height];
        
    }
}

- (CGFloat)getTextViewContentH:(UITextView *)textView
{
    
    return ceilf([textView sizeThatFits:textView.frame.size].height);
    
}


#pragma mark 照相
- (void)takePicAction:(UIButton *)btn{
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    if (self.currentSelectedAssetsArray.count>=5) {
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"提示" message:@"最多上传5张照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    _info = info;
    //判断是静态图像还是视频
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        
        UIImage* originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [self.assetslibrary writeImageToSavedPhotosAlbum:[originalImage CGImage] orientation:(ALAssetOrientation)[originalImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error) {
            
            [self.assetslibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                
                
                
                GJCFAsset *gjcfAsset = [[GJCFAsset alloc] initWithAsset:asset];
                PhotoInfo *photInfo = [[PhotoInfo alloc] init];
                photInfo.thumbnail = gjcfAsset.thumbnail;
                photInfo.defaultImage = gjcfAsset.fullResolutionImage;
                photInfo.imgSize= gjcfAsset.size;
                photInfo.imgName = gjcfAsset.fileName;
                photInfo.url = gjcfAsset.url;
                
                [self.currentSelectedAssetsArray addObject:photInfo];
                [self.panel didAddSelectedIndex:self.currentSelectedAssetsArray.count-1];
                
            } failureBlock:^(NSError *error) {
                
            }];
            
            
        }];
        
    }
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark 相册获取照片
- (void)photoAction:(UIButton *)button{
    
    if (self.currentSelectedAssetsArray.count>=5) {
        
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"提示" message:@"最多上传5张照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else{
        
        GJCFAssetsPickerViewController *assetsViewController = [[GJCFAssetsPickerViewController alloc]init];
        assetsViewController.pickerDelegate = self;
        assetsViewController.mutilSelectLimitCount = 5;
        
        /* 便捷自定义，需要预先注入风格 */
        [assetsViewController setCustomStyleByKey:@"GJCFMyCustomStyle"];
        
        [self presentViewController:assetsViewController animated:YES completion:nil];
        
    }
    
}

#pragma mark - assetsPicker delegate
- (void)pickerViewController:(GJCFAssetsPickerViewController *)pickerViewController didReachLimitSelectedCount:(NSInteger)limitCount
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"超过限制%li张数",limitCount] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)pickerViewControllerRequirePreviewButNoSelectedImage:(GJCFAssetsPickerViewController *)pickerViewController
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"请选择要预览的图片"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)pickerViewController:(GJCFAssetsPickerViewController *)pickerViewController didFaildWithErrorMsg:(NSString *)errorMsg withErrorType:(GJAssetsPickerErrorType)errorType
{
    if (errorType == GJAssetsPickerErrorTypePhotoLibarayChooseZeroCountPhoto) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:errorMsg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
- (void)pickerViewController:(GJCFAssetsPickerViewController *)pickerViewController didFinishChooseMedia:(NSArray *)resultArray
{
    NSInteger count = 5-self.currentSelectedAssetsArray.count;
    if (resultArray.count<=count) {
        
        
        [resultArray enumerateObjectsUsingBlock:^(GJCFAsset *asset, NSUInteger idx, BOOL *stop) {
            PhotoInfo *photoInfo = [[PhotoInfo alloc] init];
            photoInfo.thumbnail = asset.thumbnail;
            photoInfo.imgName = asset.fileName;
            photoInfo.imgSize = asset.size;
            photoInfo.url = asset.url;
            photoInfo.defaultImage=asset.fullResolutionImage;
            [self.currentSelectedAssetsArray addObject:photoInfo];
            
            
        }];
        [self.currentSelectedAssetsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
        }];
        self.panel.selectedItems = self.currentSelectedAssetsArray;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.panel.selectedItems.count-1 inSection:0];
        [self.panel.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        
    }else{
        NSString *str=[NSString stringWithFormat:@"最多再上传%li张",(long)count];
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)pickerViewControllerPhotoLibraryAccessDidNotAuthorized:(GJCFAssetsPickerViewController *)pickerViewController
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"请授权访问你的相册"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}



#pragma mark - selelcted panel delegate
- (void)willDeleteRowWithItem:(PhotoInfo *)item withMultiSelectedPanel:(MultiSelectedPanel*)multiSelectedPanel
{
    //在此做对数组元素的删除工作
    NSUInteger index = [self.currentSelectedAssetsArray indexOfObject:item];
    if (index==NSNotFound) {
        return;
    }
    
    [self.currentSelectedAssetsArray removeObjectAtIndex:index];
    
    
}

- (void)updateConfirmButton{
    
    
    
}

- (void)previewPhotoAtIndex:(NSInteger)index{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (int i = 0; i<self.currentSelectedAssetsArray.count; i++) {
        PhotoInfo *photoInfo = self.currentSelectedAssetsArray[i];
        MWPhoto *photo = [MWPhoto photoWithImage:photoInfo.defaultImage];
        [photos  addObject:photo];
    }
    self.photos  = [[NSMutableArray alloc]initWithArray:photos];
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    BOOL autoPlayOnAppear = NO;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = autoPlayOnAppear;
    [browser setCurrentPhotoIndex:index];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
    
}


#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}




@end
