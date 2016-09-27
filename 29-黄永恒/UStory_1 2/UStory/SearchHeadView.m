//
//  SearchHeadView.m
//  UStory
//
//  Created by 黄永恒 on 16/8/17.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "SearchHeadView.h"
@interface SearchHeadView ()
{
    __weak UITextField *_txfSearch;
}
@end
@implementation SearchHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self loadDefaultSetting];
    }
    return self;
}

-(void)loadDefaultSetting{
     /** 返回按钮 */
    UIButton *btnBack = [[UIButton alloc]init];
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self addSubview:btnBack];
    [btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.width.mas_equalTo(25);
    }];
    [btnBack addTarget:self action:@selector(tapBtnBackAction) forControlEvents:UIControlEventTouchUpInside];
    
     /** 搜索按钮 */
    UIButton *btnSearch = [[UIButton alloc]init];
    [btnSearch setTitle:@"搜索" forState:UIControlStateNormal];
    btnSearch.titleLabel.font = [UIFont systemFontOfSize:17];
    [btnSearch setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self addSubview:btnSearch];
    [btnSearch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.bottom.trailing.equalTo(self).offset(-10);
        make.width.mas_equalTo(40);
    }];
    [btnSearch addTarget:self action:@selector(tapBtnSearchActio) forControlEvents:UIControlEventTouchUpInside];
    
     /** 搜索框 */
    UITextField *txfSearch = [[UITextField alloc]init];
    txfSearch.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:245/255.0 alpha:1];
    txfSearch.placeholder = @"搜索标题、故事包含的关键字";
    txfSearch.clearButtonMode = UITextBorderStyleLine;
    [self addSubview:txfSearch];
    [txfSearch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(btnBack.mas_trailing).offset(20);
        make.trailing.equalTo(btnSearch.mas_leading).offset(-20);
        make.top.equalTo(self).offset(7.5);
        make.bottom.equalTo(self).offset(-7.5);
    }];
    txfSearch.layer.cornerRadius = 5;
    txfSearch.layer.masksToBounds = YES;
    _txfSearch = txfSearch;
    
     /** 搜索框左视图 */
    UIImageView *img = [[UIImageView alloc]init];
    img.frame = CGRectMake(0, 5, 15, 15);
    img.image = [UIImage imageNamed:@"search"];
    txfSearch.leftView = img;
    txfSearch.leftViewMode = UITextFieldViewModeAlways;
}
#pragma mark - ▶ 点击返回按钮 ◀
- (void)tapBtnBackAction{
    if ([self.searchViewDelegate respondsToSelector:@selector(didTapBackBtn)]) {
        [self.searchViewDelegate didTapBackBtn];
    }
}
#pragma mark - ▶ 点击搜索按钮 ◀
- (void)tapBtnSearchActio{
    if ([self.searchViewDelegate respondsToSelector:@selector(didTapSearchBtnWithText:)]) {
        [self.searchViewDelegate didTapSearchBtnWithText:_txfSearch.text];
    }
}

@end
