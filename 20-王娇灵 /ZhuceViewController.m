//
//  ZhuceViewController.m
//  心情语录
//
//  Created by qingyun on 16/8/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//


#import "ZhuceViewController.h"
#import "Masonry.h"
#import "ZhuceView.h"
#import <AVOSCloud/AVOSCloud.h>
#import "ShouyeViewController.h"

@interface ZhuceViewController ()<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) UIButton *backButton;
//中间的选照片按钮
@property (strong, nonatomic) UIButton *photoButton;
//男
@property (strong, nonatomic) UIButton *manButton;
//女
@property (strong, nonatomic) UIButton *womanButton;

@property (strong, nonatomic) ZhuceView *zhuceView;


@end

@implementation ZhuceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor orangeColor]];
    
    
    [self.view addSubview:self.backButton];
    //[self.view addSubview:self.photoButton];
   // [self.view addSubview:self.manButton];
   // [self.view addSubview:self.womanButton];
    
    [self.view addSubview:self.zhuceView];
    //设置代理
      _zhuceView.passwordTextfiled.delegate = self;
      _zhuceView.EmailTextfiled.delegate = self;
     // _zhuceView.nichengTextfiled.delegate = self;
    
    
    
    
    [self addAutoLayout];

}

- (void)addAutoLayout
{
    WS(weakSelf);
    
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(40);
        make.left.equalTo(weakSelf.view.mas_left).offset(30);
    }];
    
//    [_photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(weakSelf.view.mas_centerX);
//        make.top.equalTo(weakSelf.view.mas_top).offset([UIScreen mainScreen].bounds.size.height * 0.2);
//        make.size.equalTo(CGSizeMake(50, 50));
//    }];
//    //照片男/女约束
//    [_manButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.view.mas_left).offset([UIScreen mainScreen].bounds.size.width * 0.3);
//        make.top.equalTo(weakSelf.view.mas_top).offset([UIScreen mainScreen].bounds.size.height * 0.4);
//    }];
//    
//    [_womanButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.view.mas_left).offset([UIScreen mainScreen].bounds.size.width * 0.55);
//        make.centerY.equalTo(weakSelf.manButton.mas_centerY);
//    }];
//    
    [_zhuceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.top.equalTo(weakSelf.view.mas_top).offset([UIScreen mainScreen].bounds.size.height * 0.5);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
    
}

#pragma mark - textfiled协议方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.view.frame;
        rect.origin.y = -140;
        self.view.frame = rect;
        
    }];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    //[_zhuceView.nichengTextfiled resignFirstResponder];
    [_zhuceView.EmailTextfiled resignFirstResponder];
    [_zhuceView.passwordTextfiled resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.view.frame;
        rect.origin.y = 0;
        self.view.frame = rect;
    }];
    
    return YES;
    
}


#pragma mark - 懒加载
- (UIButton*)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backtoLoad) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (void)backtoLoad
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (UIButton*)photoButton
//{
//    if (!_photoButton) {
//        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_photoButton setBackgroundImage:[UIImage imageNamed:@"上传头像"] forState:UIControlStateNormal];
//        _photoButton.layer.cornerRadius = 25;
//        _photoButton.layer.masksToBounds = YES;
//        
//        [_photoButton addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
//        
//    }
//    return _photoButton;
//}
////头像的点击方法
//- (void)openCamera
//{
//    UIAlertController *actionsheet = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//        {
//            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"说了不支持相机,你是不是傻?" message:nil preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"对不起，我错了!" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                
//            }];
//            [alertView addAction:cancle];
//            [self presentViewController:alertView animated:YES completion:nil];
//        }else
//        {
//        //创建图片拾取器
//        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//        //设置代理
//        imagePicker.delegate = self;
//        //设置图片拾取器类型(相机还是相册,默认是相册)
//        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        //是否允许图片编辑
//        imagePicker.allowsEditing = YES;
//        //唤醒相机
//        [self presentViewController:imagePicker animated:YES completion:nil];
//        }
//    }];
//    [actionsheet addAction:camera];
//    
//    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//        
//        imagePicker.delegate = self;
//        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        imagePicker.allowsEditing = YES;
//        [self presentViewController:imagePicker animated:YES completion:nil];
//        
//    }];
//    [actionsheet addAction:photo];
//    
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        //NSLog(@"触发了取消事件");
//    }];
//    [actionsheet addAction:cancel];
//    
//    [self presentViewController:actionsheet animated:YES completion:nil];
//    
//}
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
//{
//    //NSLog(@"%@",info);
//    //完成获取图片的操作
//    UIImage *chooseImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//    [self.photoButton setImage:chooseImage forState:UIControlStateNormal];
//    //将图片从系统相册中取出，并存到应用的沙盒当中
//    NSString *homePath = [NSHomeDirectory() stringByAppendingPathComponent:@"documents"];
//    
//   // NSLog(@"%@",homePath);
//    
//    NSString *realPath = [homePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.image",arc4random()%10000]];
//    //图片存入沙盒
//    [UIImageJPEGRepresentation(chooseImage, 1.0f) writeToFile:realPath atomically:YES];
//    
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//}
//
//
//- (UIButton*)manButton
//{
//    if (!_manButton) {
//        _manButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_manButton setBackgroundImage:[UIImage imageNamed:@"男"] forState:UIControlStateNormal];
//        [_manButton addTarget:self action:@selector(clickManbutton) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _manButton;
//}
//
//- (void)clickManbutton
//{
//    [_manButton setImage:[UIImage imageNamed:@"男_sel"] forState:UIControlStateNormal];
//    [_womanButton setImage:[UIImage imageNamed:@"女"] forState:UIControlStateNormal];
//    
//    
//    
//}
//
//- (UIButton*)womanButton
//{
//    if (!_womanButton) {
//        _womanButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_womanButton setBackgroundImage:[UIImage imageNamed:@"女"] forState:UIControlStateNormal];
//        [_womanButton addTarget:self action:@selector(clickWomanbutton) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _womanButton;
//}
//- (void)clickWomanbutton
//{
//    
//    [_manButton setImage:[UIImage imageNamed:@"男"] forState:UIControlStateNormal];
//    [_womanButton setImage:[UIImage imageNamed:@"女_sel"] forState:UIControlStateNormal];
//    
//    
//}
//
- (ZhuceView*)zhuceView
{
    if (!_zhuceView) {
        self.zhuceView = [[ZhuceView alloc] init];
        __weak typeof(self)weakSelf = self;
        _zhuceView.block = ^{
            
            //注册账号
            if (_zhuceView.EmailTextfiled.text.length == 0 || _zhuceView.passwordTextfiled.text.length == 0) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"用户名或密码为空" message:@"重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                //NSLog(@"name or pwd nil");
                return;
            }
            
            //创建用户
            AVUser *user = [[AVUser alloc] init];
            user.username = weakSelf.zhuceView.EmailTextfiled.text;
            user.password = weakSelf.zhuceView.passwordTextfiled.text;
           // [[AVUser currentUser] setObject:weakSelf.photoButton.imageView.image forKey:@"image"];
            
            //保存用异步模式
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    //NSLog(@"注册成功");
                    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                    [def setObject:user.username forKey:@"username"];
                    [def setObject:weakSelf.photoButton.imageView.image forKey:@"image"];
                    [def synchronize];
                    
                    
                }else{
                   // NSLog(@"%@",error);
                }
            }];
            
        };
        
        
        [_zhuceView setBackgroundColor:[UIColor cyanColor]];
    }
    return _zhuceView;
}


@end
