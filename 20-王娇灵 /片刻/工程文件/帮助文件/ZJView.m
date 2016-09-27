//
//  ZJView.m
//  美物心语
//
//  Created by qingyun on 16/9/7.
//  Copyright © 2016年 bjsxt. All rights reserved.
//


#import "ZJView.h"

@interface ZJView()
//动态图
@property (strong, nonatomic) UIImageView *loadingImageView;
//提示文字
@property (strong, nonatomic) UILabel *toastLabel;

@end
@implementation ZJView

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        [self addSubview:self.loadingImageView];
        [self addSubview:self.toastLabel];
    }
    return self;
}
#pragma mark - 接口方法
//要把loading界面加载到哪个界面
+ (void)showZJViewFromSuperView:(UIView*)superView;
{
    
    [self showZJVIEWFromSuperView:superView offSetY:0];
    
    
}

//要把loading界面从哪个界面移除
+ (void)removeZJViewFromSuperView:(UIView*)superView
{
    //在父视图的[所有子视图数组]当中查找
    for(UIView *itemView in superView.subviews)
    //如果子视图是ZjView类型
        if ([itemView isKindOfClass:[ZJView class]]) {
            //从父视图中移除
            [itemView removeFromSuperview];
        }
    
    
}

//要把loading界面加载到哪个界面上(具体位置多少)
+ (void)showZJVIEWFromSuperView:(UIView*)superView offSetY:(CGFloat)offsetY
{
    
    ZJView *loading = [[ZJView alloc]init];
    loading.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-40, [UIScreen mainScreen].bounds.size.height/3+offsetY, 80, 60);
    
    //判断superView上是否已经存在一个ZJView
    //如果已经存在，那么闲删除这个ZJView，再加载新的ZJView
    [self removeZJViewFromSuperView:superView];
    
    //再加载新的View
    [superView addSubview:loading];
    //让动态图动起来
    [loading.loadingImageView startAnimating];
}


#pragma mark - 懒加载
- (UIImageView*)loadingImageView
{
    if (!_loadingImageView) {
        _loadingImageView = [[UIImageView alloc] init];
        [_loadingImageView setFrame:CGRectMake(0, 0, 80, 80)];
        _loadingImageView.backgroundColor = [UIColor clearColor];
        
        _loadingImageView.animationImages = [self getImageArray];
        _loadingImageView.animationDuration = 2.0;
        _loadingImageView.animationRepeatCount = 0;
    }
    
    
    return _loadingImageView;
}
- (NSArray*)getImageArray
{
    
    //获取图片名称
    NSMutableArray *imageNameArr = [NSMutableArray array];
    for (int i = 1; i < 16; i++) {
         NSString *imageName;
        if (i < 10) {
            imageName = [NSString stringWithFormat:@"loading_animate_0%d",i];
        }
        else
        {
            imageName = [NSString stringWithFormat:@"loading_animate_%d",i];
        }
        [imageNameArr addObject:imageName];
        
    }
    
    
    //获取图片数组
    NSMutableArray *imageArr = [NSMutableArray array];
    for (int i = 0; i<15; i++) {
        NSString *imageName = [imageNameArr objectAtIndex:i];
        UIImage *image = [UIImage imageNamed:imageName];
        [imageArr addObject:image];
    }
    
    
    return  imageArr;
    
}

- (UILabel*)toastLabel
{
    if (!_toastLabel) {
        _toastLabel = [[UILabel alloc] init];
        _toastLabel.frame = CGRectMake(0, 90, 80, 30);
        _toastLabel.text = @"正在加载...";
        _toastLabel.font = [UIFont systemFontOfSize:13];
        _toastLabel.textAlignment = NSTextAlignmentCenter;
        _toastLabel.textColor= [ UIColor darkTextColor];
    }
    return _toastLabel;
    
}


@end
