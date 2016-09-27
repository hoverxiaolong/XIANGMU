//
//  ShequViewController.m
//  心情语录
//
//  Created by qingyun on 16/8/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//


#import "RecordVC.h"
#import "CehuaViewController.h"
#import "UIBarButtonItem+Helper.h"
#import "RecodeBar.h"
#import "MyXuanCell.h"
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "Masonry.h"
#import <AVOSCloud/AVOSCloud.h>
#import "QYAudioPlayer.h"
#import <AVObject.h>
#import "LoadViewController.h"
#import "QYAccout.h"
#import "DiaoduControllerDispatch.h"
#import <UMengSocialCOM/UMSocial.h>
#import <AFNetworking.h>
#import "MyModel.h"
#import "JXLDayAndNightMode.h"

@interface RecordVC ()<UITableViewDelegate,UITableViewDataSource,RecodeBarDelegate,UMSocialUIDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) RecodeBar *recodeBar;
@property (nonatomic,weak) NSLayoutConstraint *bottomConstraint;
@property (nonatomic,strong) NSMutableArray *messages;

@property (nonatomic,strong) AVIMConversation *conversation;//会话
@property (nonatomic,strong) NSString *username;

@property (nonatomic,strong) MyXuanCell *cell;

@end

@implementation RecordVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;

    //设置导航按钮和关联方法(唤醒侧滑菜单)
    UIBarButtonItem *menuItem = [UIBarButtonItem itemWithNormalIcon:@"menu" highlightedIcon:nil target:self action:@selector(openSideMenuMethod)];
    
    UIBarButtonItem *titleItem = [UIBarButtonItem itemWithTitle:@"生活感悟" target:nil action:nil];
    
    self.navigationItem.leftBarButtonItems = @[menuItem,titleItem];
    
    
    //添加键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.messages = [NSMutableArray array];
   
    [self layoutSubView];
    
    //提示框
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"可写可分享，录音现录现听" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    
    [alert show];
    
    if (![QYAccout shareAccount].isLogin) {
        return;
    }
    //查询平台上的数据并保存到UI界面上
    AVQuery *query = [AVQuery queryWithClassName:@"Message"];
    [query whereKey:@"myname" equalTo:self.username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error) {
            //NSLog(@"%@",error);
            return;
        }
        
        //注意：
        for (AVObject *obj in objects) {
            NSString *strObj = [obj objectForKey:@"textview"];
            
            AVIMTextMessage *message = [[AVIMTextMessage alloc] init];
            message.text = strObj;
            
            [self.messages addObject:message];
        }
        
        [self.tableView reloadData];
    }];
    

}


- (void)config {
    [self.view jxl_setDayMode:^(UIView *view) {
        self.view.superview.backgroundColor = [UIColor whiteColor];
        self.tableView.backgroundColor = [UIColor whiteColor];
    } nightMode:^(UIView *view) {
        self.view.superview.backgroundColor = [UIColor blackColor];
        self.tableView.backgroundColor = [UIColor blackColor];
    }];
   
    [self.navigationController.navigationBar jxl_setDayMode:^(UIView *view) {
        UINavigationBar *bar = (UINavigationBar *)view;
        bar.barStyle = UIBarStyleDefault;
        bar.barTintColor = [UIColor redColor];
    } nightMode:^(UIView *view) {
        UINavigationBar *bar = (UINavigationBar *)view;
        bar.barStyle = UIBarStyleDefault;
        bar.barTintColor = [UIColor cyanColor];
    }];
    
}


//唤醒侧滑菜单
- (void)openSideMenuMethod
{
    [CehuaViewController openSideMenuFromWindow:self.view.window];
    
}


- (void)layoutSubView {
    //使用autolayout布局内容
    [self.recodeBar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(kChartBarHeight);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.equalTo(self.recodeBar.mas_top).with.offset(0);
    }];
    
}

//初始化tableView
- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
        [self.tableView addGestureRecognizer:tap];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        //注册cell
        [self.tableView registerNib:[UINib nibWithNibName:@"RecodeContentCell" bundle:nil] forCellReuseIdentifier:@"text"];
        
        [self.tableView registerNib:[UINib nibWithNibName:@"RecodeAudioCell" bundle:nil] forCellReuseIdentifier:@"audio"];
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

- (RecodeBar *)recodeBar {
    
    if (!_recodeBar) {
        
        _recodeBar = [[[NSBundle mainBundle] loadNibNamed:@"RecodeBar" owner:nil options:nil] firstObject];
        _recodeBar.delegate = self;
      
        [self.view addSubview:_recodeBar];
    }
    return _recodeBar;
}


#pragma mark - tableView delegate dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AVIMTextMessage *message = self.messages[indexPath.row];
     MyXuanCell *cell;
    
   if ([message isKindOfClass:[AVIMTextMessage class]]) {
    
        cell = [tableView dequeueReusableCellWithIdentifier:@"text" forIndexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"audio" forIndexPath:indexPath];
    }
    
    __weak typeof(self) weakSelf = self;
    
    [cell setSharebtn:^{
    
        [UMSocialData defaultData].extConfig.title = @"分享的title";
        [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"57d3e905e0f55a0b7000125a"
                                          shareText:message.text
                                         shareImage:[UIImage imageNamed:@"tupian"]
                                    shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone]
                                           delegate:weakSelf];
    
    }];
    
    [cell setShareBtnRecode:^{
        
    
        [UMSocialData defaultData].extConfig.title = @"分享的title";
        [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"57d3e905e0f55a0b7000125a"
                                          shareText:message.text
                                         shareImage:[UIImage imageNamed:@"tupian"]
                                    shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone]
                                           delegate:weakSelf];
        
    
    }];
    
    
    [cell bandingMessage:message];
   
    return cell;
}


-(void)hideKeyboard:(UITapGestureRecognizer*)tap {
    
    [self.recodeBar.textView resignFirstResponder];
    
    //判断点击的区域
    CGPoint point = [tap locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    if (!indexPath) {
        return;
    }
    //找到对应的数据源
    AVIMTypedMessage *message = self.messages[indexPath.row];
    if (message.mediaType == kAVIMMessageMediaTypeAudio) {
        //先判断点击区域是在声音显示的区域
        //在cell上点击的位置
        MyXuanCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        CGPoint point = [tap locationInView:cell];
        if (CGRectContainsPoint(cell.bgImage.frame, point) == YES) {
            //点击在声音上,播放声音
            [message.file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                //使用播放器,播放Data;
                [[QYAudioPlayer sharePalyer] playerAudioWith:data];
                //开启cell动画
                [cell.animationImage startAnimating];
                
            }];
            
        }
        
    }

}

-(void)keyboardWillShow:(NSNotification *)noti {
    //根据要通知的info，找到键盘显示的最终位置，显示过程中的动画时长
    NSValue *boardsEnd = noti.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect endFrame = boardsEnd.CGRectValue;
    CGFloat animation = [noti.userInfo [UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:animation animations:^{
        
        [self.recodeBar mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(-endFrame.size.height);
        }];
        [self.view layoutIfNeeded];
    }];
    
}

-(void)keyboardWillHide:(NSNotification *)noti {
    
    //根据动画事件，调整底部的约束
    CGFloat animation = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animation animations:^{
        [self.recodeBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
        [self.view layoutIfNeeded];
    }];
    
}

- (void)senMessage:(id)message {
    
    [self.conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
        
        if (error) {
            //NSLog(@"%@",error);
        }else {
            //NSLog(@"发送成功");
        }
    }];
    
    [self.messages addObject:message];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

//返回cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AVIMTextMessage *message = self.messages[indexPath.row];
    MyXuanCell *cell;
    //消息是接收的还是发送的
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"text" ];
    
    cell.contentLabel.text = message.text;
    
    //计算cell显示需要多高
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    //分割线的高度
    return size.height + 1;
    
}

#pragma mark - Message Manager delegate

-(BOOL)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message{
    if (self.conversation  == conversation) {
        [self.messages addObject:message];
        [self.tableView reloadData];
        return YES;
    }
    return NO;
}



@end
