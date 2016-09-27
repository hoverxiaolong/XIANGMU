//
//  MainHeadView.m
//  UStory
//
//  Created by 黄永恒 on 16/8/17.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "MainHeadView.h"
@interface MainHeadView()
@property(nonatomic,copy)NSArray *arrTitles;
@property(nonatomic,weak)UIScrollView *scrollView;
@end

@implementation MainHeadView

- (NSArray *)arrTitles{
    if (!_arrTitles) {
        _arrTitles = @[@"时光轴",@"故事集"];
    }
    return _arrTitles;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self loadDefaultSetting];
    }
    return self;
}

-(void)loadDefaultSetting{
     /** 个人中心按钮 */
    UIButton *btnHome = [[UIButton alloc]init];
    [self addSubview:btnHome];
    [btnHome setImage:[UIImage imageNamed:@"option"] forState:UIControlStateNormal];
    [btnHome addTarget:self action:@selector(tapBtnHomeAction) forControlEvents:UIControlEventTouchUpInside];
    [btnHome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(10);
        make.top.equalTo(self).offset(12.5);
        make.bottom.equalTo(self).offset(-12.5);
        make.width.mas_equalTo(20);
    }];
    
    CGFloat btnWidth = ScreenWidth/4;
    CGFloat btnHeight = self.bounds.size.height;
    NSUInteger count = self.arrTitles.count;
    
     /** 选项按钮页面 */
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(btnWidth);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(btnWidth * 2);
    }];
    self.scrollView = scrollView;
    [scrollView setContentSize:CGSizeMake(count * btnWidth, btnHeight)];

    for (NSUInteger index = 0; index<count; index++) {
         /** 选项按钮 */
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:self.arrTitles[index] forState:UIControlStateNormal];
        button.tag = index;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateDisabled];
        [scrollView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(scrollView).offset(index * btnWidth);
            make.top.equalTo(scrollView).offset(5);
            make.bottom.equalTo(scrollView).offset(-5);
            make.width.mas_equalTo(btnWidth);
            
        }];
        [button addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
     /** 搜索按钮 */
    UIButton *btnSearch = [[UIButton alloc]init];
    [btnSearch setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [self addSubview:btnSearch];
    [btnSearch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(12.5);
        make.bottom.equalTo(self).offset(-12.5);
        make.width.mas_equalTo(20);
    }];
    [btnSearch addTarget:self action:@selector(tapBtnSearchAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - ▶ 点击个人中心事件 ◀
- (void)tapBtnHomeAction{
    if ([self.headViewDelegate respondsToSelector:@selector(didTapSideslipBtn)]) {
        [self.headViewDelegate didTapSideslipBtn];
    }
}

#pragma mark - ▶ 点击搜索按钮事件 ◀
- (void)tapBtnSearchAction{
    if ([self.headViewDelegate respondsToSelector:@selector(didTapSearchBtn)]) {
        [self.headViewDelegate didTapSearchBtn];
    }
}

#pragma mark - ▶ 点击页面选项按钮事件 ◀
- (void)chooseAction:(UIButton *)button{
    for (UIButton *btn in self.scrollView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.enabled = YES;
        }
    }
    button.enabled = NO;
    [self.scrollView scrollRectToVisible:button.bounds animated:YES];
    if (self.blkDidChooseBtnAtIndex) {
        self.blkDidChooseBtnAtIndex(button.tag);
    }
}

#pragma mark - ▶ 确定index ◀
- (void)chooseIndex:(NSInteger)indexChoosed{
    NSUInteger count = self.arrTitles.count;
    for (NSUInteger index = 0; index<count; index++) {
        UIButton *btn = self.scrollView.subviews[index];
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn.tag == indexChoosed) {
                [self chooseAction:btn];
                break;
            }
        }
    }
}



@end
