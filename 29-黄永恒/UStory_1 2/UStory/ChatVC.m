//
//  ChatVC.m
//  
//
//  Created by qingyun on 16/9/16.
//

#import "ChatVC.h"
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "SlipTitleView.h"
#import "ChatCell.h"
#import "AppDelegate.h"

@interface ChatVC ()<UITableViewDelegate,UITableViewDataSource,AVIMClientDelegate,UITextViewDelegate>
@property(strong,nonatomic)UITableView *tableView;
@property(nonatomic,strong)AVIMConversation *conversation;//会话
@property(nonatomic,strong)NSMutableArray *messages;
@property(nonatomic,weak)UIView *chatView;
@property(nonatomic,weak)UITextView *textView;
@end

@implementation ChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    __weak typeof(self) selfWeak = self;
    
    SlipTitleView *titleView = [[SlipTitleView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 40) title:self.strFriendName];
    [self.view addSubview:titleView];
    [titleView setBlkDidTapBackBtn:^{
        [selfWeak.navigationController popViewControllerAnimated:YES];
    }];
    
    /** 聊天框区域 */
    UIView *chatView = [[UIView alloc]init];
    [self.view addSubview:chatView];
    self.chatView = chatView;
    [chatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    /** 输入框 */
    UITextView *textView = [[UITextView alloc]init];
    textView.backgroundColor = [UIColor lightGrayColor];
    textView.textColor = [UIColor blackColor];
    [chatView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(chatView).offset(5);
        make.bottom.equalTo(chatView).offset(-5);
        make.trailing.equalTo(chatView).offset(-60);
    }];
    textView.layer.cornerRadius = 5;
    textView.layer.masksToBounds = YES;
    self.textView = textView;
    textView.delegate = self;
    
    /** 发送按钮 */
    UIButton *btnSend = [[UIButton alloc]init];
    [btnSend setTitle:@"发送" forState:UIControlStateNormal];
    [btnSend setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [self.view addSubview:btnSend];
    [btnSend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(textView.mas_trailing).offset(10);
        make.top.bottom.equalTo(textView);
        make.trailing.equalTo(chatView).offset(-5);
    }];
    [btnSend addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    
    //添加键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.messages = [NSMutableArray array];
    [self creatConversation];
}

#pragma mark - ▷ 初始化tableView ◁
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.view);
            make.top.equalTo(self.view).offset(60);
            make.bottom.equalTo(self.chatView.mas_top);
        }];
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.allowsSelection = NO;
        //隐藏分割线
        self.tableView.separatorStyle = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        //注册cell
        [self.tableView registerNib:[UINib nibWithNibName:@"LeftChartCell" bundle:nil] forCellReuseIdentifier:@"leftText"];
        [self.tableView registerNib:[UINib nibWithNibName:@"RightChartCell" bundle:nil] forCellReuseIdentifier:@"rightText"];
    }
    return _tableView;
}

#pragma mark - ▷ 创建会话，接收消息 ◁
- (void)creatConversation{
    self.client = [[AVIMClient alloc]initWithClientId:self.strMyName];
    NSString *conName = [NSString stringWithFormat:@"%@ and %@", self.strMyName, self.strFriendName];
    //创建会话
    self.client.delegate = self;
    if (self.client.status == AVIMClientStatusOpened) {
        [self.client createConversationWithName:conName
                                     clientIds:@[self.strFriendPhone]//会话名字
                                      callback:^(AVIMConversation *conversation, NSError *error) {
                                          if (!error) {
                                              self.conversation = conversation;
                                          }else{
                                              NSLog(@"%@", error);
                                          }
                                      }];
    }else{
        [self.client openWithCallback:^(BOOL succeeded, NSError *error) {
            NSLog(@"clint open 对话开启");
            [self.client createConversationWithName:conName
                                         clientIds:@[self.strFriendPhone]
                                          callback:^(AVIMConversation *conversation, NSError *error) {
                                              NSLog(@"conversion success");
                                              self.conversation = conversation;
                                          }];
        }];
    }
    
}

#pragma mark - clint delegate/接收消息回调函数
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message{
    NSLog(@"message:%@", message.text);
        //添加到数据源中
        [self.messages addObject:message];
        [self.tableView reloadData];
}

#pragma mark - ▷ 发送消息 ◁
- (void)sendMessage{
    if (self.textView.text.length == 0) {
        return;
    }
    //打开对话
    self.client = [[AVIMClient alloc]initWithClientId:self.strMyName];
    //要发送的消息
    AVIMTextMessage *message = [AVIMTextMessage messageWithText:self.textView.text attributes:nil];
    //对话的名称
    NSString *conName = [NSString stringWithFormat:@"%@ and %@", self.strMyName, self.strFriendPhone];
    if(self.client.status == AVIMClientStatusOpened){
        [self.client createConversationWithName:conName
                                     clientIds:@[self.strFriendPhone]//好友手机（用户名）
                                      callback:^(AVIMConversation *conversation, NSError *error) {
                                          [conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
                                              if (succeeded) {
                                                  NSLog(@"发送成功");
                                              }else{
                                                  NSLog(@"发送失败");
                                              }
                                          }];
                                      }];
    }else{
    [self.client openWithCallback:^(BOOL succeeded, NSError *error) {
        [self.client createConversationWithName:conName
                                     clientIds:@[self.strFriendPhone]
                                      callback:^(AVIMConversation *conversation, NSError *error) {
                                          NSLog(@"conversion success");
                                          [conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
                                              if (succeeded) {
                                                  NSLog(@"发送成功");
                                              }else{
                                                  NSLog(@"发送失败");
                                              }
                                          }];
                                      }];
    }];
    }
    self.textView.text = nil;
    [self.messages addObject:message];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count -1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.tableView reloadData];
}

#pragma mark - ▷ 单元内单元格数量 ◁
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messages.count;
}

#pragma mark - ▷ 单元格内容 ◁
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AVIMTextMessage *message = self.messages[indexPath.row];
    ChatCell *cell;
    if ([message.clientId isEqualToString:self.strFriendPhone]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"leftText" forIndexPath:indexPath];
        //好友图标
        cell.icon.image = [UIImage imageNamed:@"us"];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"rightText" forIndexPath:indexPath];
        NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"usersHeaderImage"];
        if (data == nil) {
            cell.icon.image = [UIImage imageNamed:@"us"];
        }else{
        cell.icon.image = [UIImage imageWithData:data];
        }
    }
    [cell BindMessages:message];
    return cell;
}

#pragma mark - ▷ 单元格高度 ◁
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AVIMTextMessage *message = self.messages[indexPath.row];
    ChatCell *cell;    //消息是接收的还是发送的
    if ([message.clientId isEqualToString:self.strFriendPhone]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"leftText" ];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"rightText" ];
    }
    cell.contentLabel.text = message.text;
    //计算cell显示需要多高
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    //分割线的高度
    return size.height + 1;
}

#pragma mark - ▷ 键盘即将出现 ◁
-(void)keyboardWillShow:(NSNotification *)noti{
    //根据通知的info,找到键盘显示的最终位置,显示过程中的动画时长
    NSValue *boardsEnd = noti.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect endFrame = boardsEnd.CGRectValue;
    CGFloat animation = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:animation animations:^{
        [self.chatView mas_updateConstraints:^(MASConstraintMaker *make) {
            //约束的方向,引起正负值的问题
            make.bottom.mas_equalTo(-endFrame.size.height);
        }];
        [self.view layoutIfNeeded];
    }];

}

#pragma mark - ▷ 键盘即将消失 ◁
-(void)keyboardWillHide:(NSNotification *)noti{
    //根据动画事件,调整底部的约束
    CGFloat animation = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animation animations:^{
        [self.chatView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
        [self.view layoutIfNeeded];
    }];
    
}

#pragma mark - textview delegate
-(void)textViewDidChange:(UITextView *)textView{
    //根据文字的改变调整高度
    CGSize size = self.textView.contentSize;
    //限制一个最大高度和最小高度
    CGFloat maxHeight = 150;
    CGFloat minHeight = 40;
    
    CGFloat height = size.height;
    height = height > maxHeight ? maxHeight : height;
    height = height < minHeight ? minHeight : height;
    
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
