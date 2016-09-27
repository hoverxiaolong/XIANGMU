//
//  SetViewController.m
//  happyness
//
//  Created by 嘛嘛科技 on 16/4/13.
//  Copyright © 2016年 嘛嘛科技. All rights reserved.
//

#import "ShezhiViewController.h"
#import "UIView+Toast.h"
#import "LXAlertView.h"
#import "UIBarButtonItem+Helper.h"
#import "CehuaViewController.h"
#import "LoadViewController.h"
#import "QYAccout.h"
#import "EmailLoginView.h"
#import "AppDelegate.h"
#import <LeanChatLib/CDChatManager.h>
#import <AVOSCloud/AVUser.h>
#import "JXLDayAndNightMode.h"

#define UISCREENHEIGHT [UIApplication sharedApplication].keyWindow.frame.size.height
#define UISCREENWIDTH  [UIApplication sharedApplication].keyWindow.frame.size.width
@interface ShezhiViewController ()<UIAlertViewDelegate>
@property (nonatomic,strong) UISwitch *switchbtn;
@property (nonatomic,strong) UILabel *lab;

@end

@implementation ShezhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置导航按钮和关联方法(唤醒侧滑菜单)
    UIBarButtonItem *menuItem = [UIBarButtonItem itemWithNormalIcon:@"menu" highlightedIcon:nil target:self action:@selector(openSideMenuMethod)];
    
    UIBarButtonItem *titleItem = [UIBarButtonItem itemWithTitle:@"设置" target:nil action:nil];
    
    self.navigationItem.leftBarButtonItems = @[menuItem,titleItem];
    [self createButtons];
    
    [self sheZhiYejing];
    
}

- (void)sheZhiYejing {
    
    //创建日夜景按钮
    UISwitch *switchbtn=[[UISwitch alloc] init];
    
    switchbtn.frame = CGRectMake(50, 400, 200, 44);
    
    [switchbtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.switchbtn = switchbtn;
    [self.view addSubview:switchbtn];
    

    
        [self.view jxl_setDayMode:^(UIView *view) {
        
        self.view.backgroundColor = [UIColor colorWithRed:226/255.0 green:235/255.0 blue:243/255.0 alpha:0.7];
        
    } nightMode:^(UIView *view) {
        
        self.view.backgroundColor = [UIColor blackColor];
        
    }];
    
    if (JXLDayAndNightModeDay == [[JXLDayAndNightManager shareManager] contentMode]) {
        self.switchbtn.on = NO;
    } else {
        self.switchbtn.on = YES;
    }
    

    // 夜间模式
    [self.view jxl_setDayMode:^(UIView *view) {
        
        self.view.backgroundColor = [UIColor colorWithRed:226/255.0 green:235/255.0 blue:243/255.0 alpha:0.7];
    } nightMode:^(UIView *view) {
        
        self.view.backgroundColor = [UIColor blackColor];
    }];
    
   
}

- (void)action:(UISwitch *)switchView {
    if (switchView.on) {
        [[JXLDayAndNightManager shareManager] nightMode];
        
    } else {
        [[JXLDayAndNightManager shareManager] dayMode];
        
    }
}

- (void)createButtons {
    
    NSArray *arr=@[@"清理缓存",@"联系我们",@"投稿合作"];
    
    for (int i=0; i<3; i++) {
        
        UIView *line=[[UIView alloc]init];
        line.frame=CGRectMake(0, 50*i+64, UISCREENWIDTH, 1);
        line.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [self.view addSubview:line];
        
        
        UILabel *lab=[[UILabel alloc]init];
        self.lab = lab;
        lab.textColor = [UIColor redColor];
        lab.frame=CGRectMake(10, 50*i+75, 150, 30);
        lab.text=arr[i];
        
        lab.font=[UIFont systemFontOfSize:15];
        [self.view addSubview:lab];
        
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(0, 64+i*50, UISCREENWIDTH, 50);
        [btn addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i;
        [self.view addSubview:btn];
        
        
    }
    
    UIView *line=[[UIView alloc]init];
    line.frame=CGRectMake(0, 214, UISCREENWIDTH, 1);
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:line];
    
    //创建退出登录按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    self.button = button;
    button.frame = CGRectMake(50, 300, 275, 44);
    [button setBackgroundColor:[UIColor redColor]];
    button.titleLabel.textColor = [UIColor whiteColor];
    
    if ([QYAccout shareAccount].username) {
        
        [button setTitle:@"退出登录" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(noLogin) forControlEvents:UIControlEventTouchUpInside];
        
    }else if([QYAccout shareAccount].username == nil) {
        
        [button setTitle:@"登录" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(toLogin) forControlEvents:UIControlEventTouchUpInside];
    }
    
}


- (void)toLogin {
    
    LoadViewController *load = [[LoadViewController alloc] init];
    [self presentViewController:load animated:YES completion:nil];
}

- (void)noLogin {
    
    LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"确定要退出登录吗?" cancelBtnTitle:@"取消" otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
        
         [self logOut];
        
    }];
    
    
    [alert showLXAlertView];
    
    
}
- (void)logOut {

    [[QYAccout shareAccount] logOut];
    
       LoadViewController *load = [[LoadViewController alloc] init];
    [self presentViewController:load animated:YES completion:nil];
}



//唤醒侧滑菜单
- (void)openSideMenuMethod
{
    [CehuaViewController openSideMenuFromWindow:self.view.window];
    
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
   
}

-(void)changeClick:(UIButton *)btn{
    
    if (btn.tag==0) {
        
        //清除缓存
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"是否清理缓存？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        alertView.tag = 1011;
        [alertView show];

        
        
    }
    if (btn.tag==1) {
        
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"作者QQ：970843360欢迎讨论交流" cancelBtnTitle:@"取消" otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            //NSLog(@"点击index====%ld",clickIndex);
        }];
        [alert showLXAlertView];
        
        
    }
    if(btn.tag==2){
    
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"您有好的素材欢迎投稿" cancelBtnTitle:@"取消" otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            //NSLog(@"点击index====%ld",clickIndex);
        }];
        [alert showLXAlertView];
    
    
    }
    
}
// 显示缓存大小
-( float )filePath
{
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    return [ self folderSizeAtPath :cachPath];
    
}
//1:首先我们计算一下 单个文件的大小

- ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    
    return 0 ;
    
}
//2:遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）

- ( float ) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    
    NSString * fileName;
    
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
        
    }
    
    return folderSize/( 1024.0 * 1024.0 );
    
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && alertView.tag == 1011) {
        [self clearFile];
        
    }
}

// 清理缓存

- (void)clearFile
{
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    
    //NSLog ( @"cachpath = %@" , cachPath);
    
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
            
        }
        
    }
    
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone : YES ];
    
}
-(void)clearCachSuccess
{
    //NSLog ( @" 清理成功 " );
    
    [self.view makeToast:@"清理成功" duration:1.0 position:@"center"];
   
}

@end
