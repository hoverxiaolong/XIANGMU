//
//  LoadViewController.m
//  心情语录
//
//  Created by qingyun on 16/8/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//


#import "LoadViewController.h"
#import "Masonry.h"
#import "EmailLoginView.h"
#import "ThirdView.h"
#import "ZhuceViewController.h"
#import "ShouyeViewController.h"
#import "CehuaViewController.h"
#import "DiaoduControllerDispatch.h"
#import "Zj_LanuchViewController.h"
//#import "SliderHeadView.h"
#import "QYAccout.h"
#import "AppDelegate.h"

#import <AVOSCloud/AVOSCloud.h>

@interface LoadViewController ()

//中间logo标志
@property (strong, nonatomic) UIImageView *logoImageView;
//返回按钮
@property (strong, nonatomic) UIButton *backButton;
//注册按钮
@property (strong, nonatomic) UIButton *ZhuCeButton;

@property (strong, nonatomic) EmailLoginView *emailView;

@property (strong, nonatomic) ThirdView *thirdView;


@end

@implementation LoadViewController

#pragma  mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.ZhuCeButton];
    [self.view addSubview:self.backButton];
   
    [self.view addSubview:self.emailView];
    [self.view addSubview:self.thirdView];
   
    
    _emailView.userTextfiled.delegate = self;
    _emailView.passwordTextfiled.delegate = self;
    
    [self addAutoLayout];
    
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo withAppKey:@"1280791390" andAppSecret:@"ffd5b347dddfb2f70513efd44f5d38fb" andRedirectURI:@"http://wanpaiapp.com/oauth/callback/sina"];
    AVObject *testObject = [AVObject objectWithClassName:@"TestObject"];
    [testObject setObject:@"bar" forKey:@"foo"];
    [testObject save];
  

}

#pragma mark - 自动适配
- (void)addAutoLayout
{
    WS(weakSelf);
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX).offset([UIScreen mainScreen].bounds.size.width * 0.2);
        make.centerY.equalTo(weakSelf.view.mas_centerY).offset(-[UIScreen mainScreen].bounds.size.height * 0.25);
    }];
    
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(30);
        make.left.equalTo(weakSelf.view.mas_left).offset(30);

    }];
    
    [_ZhuCeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(25);
        make.right.equalTo(weakSelf.view.mas_right).offset(-30);

    }];
    
    [_emailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset([UIScreen mainScreen].bounds.size.height * 0.5);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.equalTo(150);
    }];
    
    [_thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset([UIScreen mainScreen].bounds.size.height * 0.75);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
}
#pragma mark - 协议方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect rect = self.view.frame;
        rect.origin.y = -100;
        self.view.frame = rect;
    }];
  
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_emailView.userTextfiled resignFirstResponder];
    [_emailView.passwordTextfiled resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.view.frame;
        rect.origin.y = 0;
        self.view.frame = rect;
        
        
    }];
    
    return YES;
}

#pragma mark - 懒加载
- (UIImageView*)logoImageView
{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageNamed:@"美物心语"];
    }
    return _logoImageView;
    
}
- (UIButton*)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backto) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backButton;
}

- (void)backto
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIButton*)ZhuCeButton
{
    if (!_ZhuCeButton) {
        _ZhuCeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ZhuCeButton setTitle:@"注册" forState:UIControlStateNormal];
        [_ZhuCeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _ZhuCeButton.titleLabel.font = [UIFont systemFontOfSize:16];
       
        [_ZhuCeButton addTarget:self action:@selector(gotoZhuce) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ZhuCeButton;
}
- (void)gotoZhuce
{
    ZhuceViewController *zhuceVC = [[ZhuceViewController alloc] init];
    [self presentViewController:zhuceVC animated:YES completion:nil];
    
}

- (EmailLoginView*)emailView
{
    if (!_emailView) {
        _emailView = [[EmailLoginView alloc] init];
        __weak typeof(self)weakSelf = self;

        _emailView.blockLogin = ^{
            
            //注册账号
            if (_emailView.userTextfiled.text.length == 0 || _emailView.passwordTextfiled.text.length == 0) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"用户名或密码不能为空" message:@"重新输入用户名或密码" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
                
                //NSLog(@"name or pwd nil");
                return;
            }
            
            
            [AVUser logInWithUsernameInBackground:weakSelf.emailView.userTextfiled.text password:weakSelf.emailView.passwordTextfiled.text block:^(AVUser *user, NSError *error) {
                if (!error) {
                    
                        
                    //NSLog(@"登录成功");
                    
                    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                    
                    
                    [def setObject:user.username forKey:@"username"];
                   
                    [def synchronize];
                    
                    NSDictionary * dict = @{@"username":user.username};
                    [[QYAccout shareAccount]saveLogin:dict];
                    if (![QYAccout shareAccount].isLogin) {
                        return ;
                        
                    }
                    
                    CehuaViewController *VC = [[CehuaViewController alloc] init];

                    [weakSelf presentViewController:VC animated:YES completion:^{
                        [weakSelf.view removeFromSuperview];
                        
                        [DiaoduControllerDispatch createViewControllerWithIndex:0];
                      
                        
                     //NSLog(@"跳转成功");
                    }];
                
                
                }else{
                    //NSLog(@"%@", error);
                }
            }];
        };
        
    }
    
    return _emailView;
}

//唤醒侧滑菜单
- (void)openSideMenuMethod
{
    [CehuaViewController openSideMenuFromWindow:self.view.window];
    
}


- (ThirdView*)thirdView
{
    if (!_thirdView) {
        _thirdView = [[ThirdView alloc] init];
        
        __weak typeof(self) weakSelf = self;

        _thirdView.sinaBlock = ^{
            
            //如果安装了微博，直接跳转到微博应用，否则跳转到网页登录
            [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
                if (error) {
                    //NSLog(@"failed to get authentication from weibo. error: %@", error.description);
                }else{
                    [AVUser loginWithAuthData:object platform:AVOSCloudSNSPlatformWeiBo block:^(AVUser *user, NSError *error) {
                        if ([weakSelf filterError:error]) {
                            
                            [weakSelf loginSucceedWithUser:user authData:object];
                        }
                    }];
                }
            } toPlatform:AVOSCloudSNSSinaWeibo];

        };
        
    }
    return _thirdView;
}

- (BOOL)filterError:(NSError *)error {
    
    if (error) {
        [self alert:[error localizedDescription]];
        return NO;
    }
    return YES;
}

- (void)alert:(NSString *)message {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)loginSucceedWithUser:(AVUser *)user authData:(NSDictionary *)authData {
    __weak typeof(self) weakSelf = self;

    CehuaViewController *VC = [[CehuaViewController alloc] init];
    
    [weakSelf presentViewController:VC animated:YES completion:^{
        [weakSelf.view removeFromSuperview];
        
        [DiaoduControllerDispatch createViewControllerWithIndex:0];
    

        //NSLog(@"跳转成功");
    }];
    
}

@end
