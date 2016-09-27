//
//  SYHeadView.m
//  美物心语
//
//  Created by qingyun on 16/9/1.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "SYHeadView.h"
#import "SYModel.h"
#import "JXLDayAndNightMode.h"

#define SYImageCount 5

@interface SYHeadView ()<UIScrollViewDelegate>
{
    BOOL _isTimeUp;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (nonatomic,strong) UILabel *label;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) NSArray *arrData;



@end

@implementation SYHeadView

#pragma mark - 懒加载

- (NSArray *)arrData {
    
    if (_arrData == nil) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"imageLabel" ofType:@"plist"];
        
        _arrData = [NSArray arrayWithContentsOfFile:path];
    }
    return _arrData;
}
//创建headView
+ (instancetype)loadHeadView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"SYHeadView" owner:nil options:nil] lastObject];
}

#pragma mark - 图片轮播器
- (void)awakeFromNib {
    CGFloat imageWidth = self.scrollView.frame.size.width;
    CGFloat imageHeight = self.scrollView.frame.size.height;
    CGFloat imageY = 0;
    
    //将图片添加到UIimageView中
    for (NSInteger index = 0; index < SYImageCount; index++) {
        
        UIImageView *image = [[UIImageView alloc] init];
        CGFloat imageX = index * imageWidth;
        image.frame = CGRectMake(imageX, imageY, imageWidth, imageHeight);
        NSDictionary *dictData = self.arrData[index];//取出数组中的每个字典的内容
        NSString *imageName = [NSString stringWithFormat:@"%d.jpg",index + 1];
        image.image = [UIImage imageNamed:imageName];
        
        //设置图片上的文字
        UILabel *label = [[UILabel alloc] init];
        self.label = label;
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor yellowColor];
        
        label.textColor = [UIColor redColor];
        label.text = dictData[@"str"];
        label.alpha = 0.7;
        label.frame = CGRectMake(0, 0, imageWidth, imageHeight);
        self.contentLabel = label;
        [image addSubview:label];
        [self.scrollView addSubview:image];
        
    }
    self.contentLabel.textColor = SYRandomColor;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(SYImageCount * imageWidth, 0);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.pageControl.numberOfPages = SYImageCount;
    
    //夜间模式
    [self jxl_setDayMode:^(UIView *view) {
        
        SYHeadView *headView = (SYHeadView *)view;
        headView.backgroundColor = [UIColor whiteColor];
        
        headView.backgroundColor = [UIColor whiteColor];
        headView.bottomLabel.textColor = [UIColor redColor];
        headView.bottomLabel.backgroundColor = [UIColor whiteColor];
        
        headView.pageControl.tintColor = [UIColor blackColor];
        
        headView.backgroundColor = [UIColor whiteColor];
        
        
    } nightMode:^(UIView *view) {
        
        SYHeadView *headView = (SYHeadView *)view;
        headView.backgroundColor = [UIColor blackColor];
        
        headView.pageControl.tintColor = [UIColor whiteColor];
        headView.bottomLabel.textColor = [UIColor whiteColor];
        headView.bottomLabel.backgroundColor = [UIColor blackColor];
    
        headView.backgroundColor = [UIColor blackColor];

        
    }];
    
    [self addTimer];
}

- (void)addTimer {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    
    //获取到主线程中的消息
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextImage {
    
    NSInteger page = 0;
    if (self.pageControl.currentPage == SYImageCount - 1) {
        
        page = 0;
    }else{
        page = self.pageControl.currentPage + 1;
    }
    
    CGFloat offSetX = page * self.scrollView.frame.size.width;
    CGFloat offSetY = 0;
    CGPoint offSet = CGPointMake(offSetX, offSetY);
    
    [self.scrollView setContentOffset:offSet animated:YES];
    
}

#pragma mark - 计算滚动到第几页
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat scrollWidth = scrollView.frame.size.width;
    
    int page = (scrollView.contentOffset.x + scrollWidth * 0.5) / scrollWidth;
    self.pageControl.currentPage = page;
}

#pragma mark - 开始拖时调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self removeTimer];
}

#pragma mark - 结束拖时调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self addTimer];
}

@end
