//
//  ControVC.m
//  UStory
//
//  Created by qingyun on 16/8/26.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "ControVC.h"

typedef enum : NSUInteger {
    kPositionLeft,
    kPositionRight,
} Position;

@interface ControVC ()<UIGestureRecognizerDelegate>

//前面控制器所在位置
@property(nonatomic)Position position;

//右边的宽度
@property(nonatomic)CGFloat rightWidth;

//点击手势
@property(nonatomic,strong)UITapGestureRecognizer *tap;

//滑动手势
@property(nonatomic,strong)UIPanGestureRecognizer *pan;

@end

@implementation ControVC

- (instancetype)initWithmainVC:(MainViewController *)mainVC slipVC:(SideslipViewController *)slipVC{
    if (self = [super init]) {
        _mainVC = mainVC;
        _slipVC = slipVC;
        
        //添加子控制器关系
        [self addChildViewController:_slipVC];
        [self addChildViewController:_mainVC];
//        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)loadView{
    self.view = [[UIView alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    //前面控制器默认位置
    self.position = kPositionLeft;
    
    //控制器滑到右边，剩余宽度
    self.rightWidth = 100;
    
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    
    //添加子控制器view
    [self addChildView];
}

#pragma mark - ▷ 添加子view ◁
- (void)addChildView{
    [self.view addSubview:self.slipVC.view];
    [self.view addSubview:self.mainVC.view];
    
    [self.mainVC.view addGestureRecognizer:self.pan];
    [self.mainVC.bgView addGestureRecognizer:self.tap];
}

#pragma mark - ▷ 当view大小调整完成后，调整子控制器的view大小 ◁
- (void)viewDidLayoutSubviews{
    [self layoutChildView];
}

#pragma mark - ▷ 调整子控制器view ◁
- (void)layoutChildView{
    CGFloat left = self.view.frame.size.width - 100;
    
    //调整控制器
    if (self.position == kPositionLeft) {
        self.slipVC.view.frame = CGRectOffset(self.view.bounds, -left/2, 0);
        self.mainVC.view.frame = self.view.bounds;
        self.mainVC.bgView.alpha = 0;
    }else{
        self.slipVC.view.frame = self.view.bounds;
        self.mainVC.view.frame = CGRectOffset(self.view.bounds, left, 0);//偏移
        self.mainVC.bgView.alpha = 0.5;
    }
}

#pragma mark - ▷ 点击手势事件 ◁
- (void)tapAction:(UITapGestureRecognizer *)tap{
    if (self.position == kPositionRight) {
        self.position  = kPositionLeft;
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutChildView];
        }];
    }
    if (self.position == kPositionLeft) {
        self.mainVC.bgView.alpha = 0;
    }
}

#pragma mark - ▷ 滑动手势事件 ◁
- (void)panAction:(UIPanGestureRecognizer *)pan{
    if (pan.state == UIGestureRecognizerStateChanged) {
        //滑动偏移量
        CGPoint point = [pan translationInView:self.view];
        //NSLog(@"%@",NSStringFromCGPoint(point));
        if (self.position  == kPositionLeft) {
            CGFloat left = self.view.frame.size.width - 100;
            CGRect rearLeft = CGRectOffset(self.view.bounds, -left/2, 0);
            _slipVC.view.frame = CGRectOffset(rearLeft, (point.x)/2, 0);
            _mainVC.view.frame = CGRectOffset(self.view.bounds, point.x, 0);
            //判断x偏移方向，不让往左滑动
            if (point.x<0) {
                _mainVC.view.frame = self.view.bounds;
            }
        }else{
            CGFloat left = self.view.frame.size.width - 100;
            //右边起始位置
            CGRect frame = CGRectOffset(self.view.bounds, left, 0);
            _mainVC.view.frame = CGRectOffset(frame, point.x, 0);
            _slipVC.view.frame = CGRectOffset(self.view.bounds, (point.x)/2, 0);
        }
    }
    
    else if(pan.state == UIGestureRecognizerStateEnded){
        CGFloat left = self.view.frame.size.width - 60;
        CGFloat center = left/2;
        if (_mainVC.view.frame.origin.x>center) {
            self.position = kPositionRight;
            self.mainVC.bgView.alpha = 0.5;
        }else{
            self.position = kPositionLeft;
        }
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutChildView];
        }];
    }else{
    }
}

#pragma mark - ▷ 侧滑栏个人中心 ◁
- (void)didTapSideslipHomeBtn{
    if (self.position == kPositionLeft) {
        self.mainVC.bgView.alpha = 0.5;
        self.position = kPositionRight;
    }else{
        self.position = kPositionLeft;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutChildView];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
