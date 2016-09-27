//
//  FeedbackViewController.m
//  UStory
//
//  Created by qingyun on 16/8/27.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "FeedbackViewController.h"
#import "SlipTitleView.h"
#import <LeanCloudFeedback/LeanCloudFeedback.h>

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    LCUserFeedbackAgent *agent = [LCUserFeedbackAgent sharedInstance];
    /* title 传 nil 表示将第一条消息作为反馈的标题。 contact 也可以传入 nil，由用户来填写联系方式。*/
    [agent showConversations:self title:nil contact:nil];
    //[self loadDefaultSetting];
}

- (void)loadDefaultSetting{
    __weak typeof(self) selfWeak = self;
    
    SlipTitleView *titleView = [[SlipTitleView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 40) title:@"用户反馈"];
    titleView.backgroundColor = randomColor;
    [self.view addSubview:titleView];
    [titleView setBlkDidTapBackBtn:^{
        [selfWeak.navigationController popViewControllerAnimated:YES];
    }];
    
    UIButton *submitBtn = [[UIButton alloc]init];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [submitBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [titleView addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.equalTo(titleView).offset(-10);
        make.top.equalTo(titleView).offset(10);
    }];
    [submitBtn addTarget:self action:@selector(didTapSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UITextView *textView = [[UITextView alloc]init];
    textView.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(10);
        make.top.equalTo(titleView.mas_bottom).offset(10);
        make.trailing.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(200);
    }];
    textView.layer.borderWidth = 0.5;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"您的意见或建议可以写在这里哟😊";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.font = [UIFont systemFontOfSize:14];
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    [textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    [textView addSubview:placeHolderLabel];

    UITextField *txfName = [[UITextField alloc]init];
    txfName.font = [UIFont systemFontOfSize:14];
    txfName.placeholder = @"称呼";
    [self.view addSubview:txfName];
    [txfName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(textView);
        make.top.equalTo(textView.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    txfName.layer.borderWidth = 0.5;
    txfName.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UITextField *txfNumber = [[UITextField alloc]init];
    txfNumber.font = [UIFont systemFontOfSize:14];
    txfNumber.placeholder = @"手机/QQ/邮箱";
    [self.view addSubview:txfNumber];
    [txfNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(textView);
        make.top.equalTo(txfName.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    txfNumber.layer.borderWidth = 0.5;
    txfNumber.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:10];
    label.text = @"请留下您的称呼和联系方式，以便我们能更好的为您服务，谢谢。";
    label.textColor = [UIColor lightGrayColor];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(txfName);
        make.top.equalTo(txfNumber.mas_bottom).offset(10);
    }];
}

- (void)didTapSubmitBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
