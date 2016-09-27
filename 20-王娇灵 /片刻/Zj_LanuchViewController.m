//
//  Zj_LanuchViewController.m
//  心情语录
//
//  Created by qingyun on 16/8/25.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "Zj_LanuchViewController.h"
#import "Masonry.h"
#import "HttpTool.h"
#import "HttpRequestMacro.h"
#import "DiaoduControllerDispatch.h"

#define LAUNCHING_IMAGEVIEW_NAME @"launchingName"

@interface Zj_LanuchViewController ()
//背景
@property (strong, nonatomic) UIImageView *launchingBackgroundImageView;
//logo
@property (strong, nonatomic) UIImageView *logoImageView;
//定时器
@property (strong, nonatomic) NSTimer *launchTimer;

@end

@implementation Zj_LanuchViewController

#pragma mark - 
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //加载背景(默认系统的图片)
    [self.view addSubview:self.launchingBackgroundImageView];
    [self.view addSubview:self.logoImageView];
    
    
    //添加约束(自动布局 Masonry)
    //为了避免使用block的时候出现循环引用,使用__weak
    __weak typeof(self) vc = self;
   // __weak Zj_LanuchViewController *vc1 = self; (同上一样)
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //约束相对宽高固定
        CGFloat width = vc.view.bounds.size.width * 0.7;
        CGFloat height = width * 0.3;
        make.size.mas_equalTo(CGSizeMake(width,height));
        
        
        //约束相对坐标固定
        
        CGFloat viewHeight = vc.view.bounds.size.height;
        CGFloat viewWidth = vc.view.bounds.size.width;
        make.centerX.mas_equalTo(vc.view.mas_centerX).offset(viewWidth/5);
        make.centerY.mas_equalTo(vc.view.mas_centerY).offset(-viewHeight/4);
        
        
        
    }];
    
    //先加载本地保存的[上次请求来的图片]
    [self loadlaunchingImageView];
    
    
    /*
     向服务器发起请求，获取最新的launching启动图，并保存到本地
     方便下次运行时候再次使用
    
    */
    
    [self getNewImageView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    //让背景动起来
    [UIView animateWithDuration:4.0 animations:^{
        CGRect rect = _launchingBackgroundImageView.frame;
        rect.origin = CGPointMake(-100, -100);
        rect.size = CGSizeMake(rect.size.width + 200, rect.size.height + 200);
        _launchingBackgroundImageView.frame = rect;
    } completion:^(BOOL finished) {
        [DiaoduControllerDispatch createViewControllerWithIndex:0];
    
    }];
    
}

#pragma mark - 加载方法
- (void)loadlaunchingImageView
{
    NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:LAUNCHING_IMAGEVIEW_NAME];
    //判空操作
    if (imageData) {
        self.launchingBackgroundImageView.image = [UIImage imageWithData:imageData];
    }
}
- (void)getNewImageView
{
    [HttpTool postWithPath:HTTP_LAUNCH_SCREEN params:@{
                                    @"client":@2
                                    }success:^(id JSON) {
                                        
                                        //NSLog(@"%@",JSON);
                                        //网络请求成功后的block回调
                                        NSString *imageUrl = [[JSON objectForKey:@"data"] objectForKey:@"picurl"];
                                        NSData *dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                                        [[NSUserDefaults standardUserDefaults] setObject:dataImage forKey:LAUNCHING_IMAGEVIEW_NAME];
                                        
                                        
                                    } failure:^(NSError *error) {
                                        //网络请求失败后的block回调
                                        //NSLog(@"%@",error);
                                    }];
    
    
}

#pragma mark - 懒加载
- (UIImageView*)launchingBackgroundImageView
{
    if (!_launchingBackgroundImageView) {
        
        self.launchingBackgroundImageView = [[UIImageView alloc] init];
        [_launchingBackgroundImageView setFrame:self.view.bounds];
        _launchingBackgroundImageView.backgroundColor = [UIColor darkGrayColor];
        _launchingBackgroundImageView.image = [UIImage imageNamed:@"defaultCover"];
    }
    
    return _launchingBackgroundImageView;
}

//我的logo标志

- (UIImageView*)logoImageView
{
    if (!_logoImageView) {
        self.logoImageView = [[UIImageView alloc]init];
        _logoImageView.backgroundColor = [UIColor clearColor];
        _logoImageView.image = [UIImage imageNamed:@"美物心语"];
    }
    return _logoImageView;
}



@end
