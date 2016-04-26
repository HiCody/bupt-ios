//
//  WebInterface.h
//  cosign
//
//  Created by mac on 15/10/28.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#ifndef WebInterface_h
#define WebInterface_h
//192.168.1.108:8081   192.168.1.13:30009   192.168.1.30:8080
//121.40.217.107:8080真实接口
#define ADD(A,B) [NSString stringWithFormat:@"%@%@",A,B]

#define kPort @"http://121.40.217.107:8080"

//登陆接口
#define LoginInterface  ADD(kPort,@"/ReqJson/Admin/NewUserInfo.aspx")

//首页角标的接口
#define HomeBadgeInteface ADD(kPort,@"/ReqJson/ReqCount.aspx")

//提交的申请页面里申请中的接口
#define ApplicaionInteface ADD(kPort,@"/ReqJson/ReqSign/CheckingSignView.aspx")

//提交的申请页面里已通过的接口
#define PassedInterface ADD(kPort,@"/ReqJson/ReqSign/PassedSignView.aspx")

//提交的申请页面里未通过的接口
#define NoPassedInterface ADD(kPort,@"/ReqJson/ReqSign/NoPassedSignView.aspx")

//提交申请详细页面的接口
#define DetailInterface ADD(kPort,@"/ReqJson/ReqSign/SignDetail.aspx")

//审批历史详情借口
#define CheckHistoryDetailInterface ADD(kPort,@"/ReqJson/ReqCheck/CheckHistoryDetail.aspx")

//审批详情
#define NeedCheckSignDetailInterface ADD(kPort,@"/ReqJson/ReqCheck/NeedCheckSignDetail.aspx")


//待传阅详情
#define NeedReadDetaiInterface ADD(kPort,@"/ReqJson/ReqRead/NeedReadDetail.aspx")

//待传阅历史详情借口
#define ReadHistoryDetailInteface ADD(kPort,@"/ReqJson/ReqRead/ReadHistoryDetail.aspx")


//待审批事项接口
#define SpendingInterface ADD(kPort,@"/ReqJson/ReqCheck/NeedCheckView.aspx")


//审批历史接口
#define SpendHistoryInterface ADD(kPort,@"/ReqJson/ReqCheck/CheckHistoryView.aspx")

//待传阅事项的接口
#define ToBeCirculatedInterface  ADD(kPort,@"/ReqJson/ReqRead/NeedReadView.aspx")

//待传阅历史的接口
#define CirculatedHistoryInterface  ADD(kPort,@"/ReqJson/ReqRead/ReadHistoryView.aspx")


//审批的接口
#define ApproveInterface ADD(kPort,@"/ReqJson/ReqCheck/CheckSign.aspx")

//下载附件接口
#define AttachedFileInterface ADD(kPort,@"/ReqJson/DownloadFile.aspx")

//最近会签人列表接口
#define RecentContactsInterface ADD(kPort,@"/ReqJson/ReqSign/RecentCheckers.aspx")

//审批人.传阅人列表     /ReqJson/Admin/QueryUserList.aspx
#define CountersignedInterface ADD(kPort,@"/ReqJson/Admin/queryDeptUser.aspx")

//最近传阅列表接口
#define AcknowledgerInterface  ADD(kPort,@"/ReqJson/ReqSign/RecentReaders.aspx")

//事项类型列表  @"http://192.168.1.30:8080/ReqJson/Admin/QueryHqTypeListWithOutPage.aspx"   /ReqJson/Admin/QueryHqTypeListForPhone.aspx
#define MattersInterface  ADD(kPort,@"/ReqJson/Admin/QueryHqTypeListWithOutPage.aspx")


//提交审批
#define ConfirmSignInterface ADD(kPort,@"/ReqJson/ReqSign/ConfirmSign.aspx")

//上传文件
#define UploadFileInterface ADD(kPort,@"/ReqSign/uploadFile.aspx")

//流程图预览窗口
#define kToFlowImage ADD(kPort,@"/ReqJson/Admin/toFlowImage.aspx")

//提交给上级
#define kCheckSignUp ADD(kPort,@"/ReqJson/ReqCheck/CheckSignUp.aspx")

//新增会签事项所有审批意见
#define kGetCheckersInterface ADD(kPort,@"/ReqJson/ReqSign/GetCheckers.aspx")

#endif /* WebInterface_h */
