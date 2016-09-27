//
//  MYPublicTableViewCell.m
//  美物心语
//
//  Created by qingyun on 16/9/2.
//  Copyright © 2016年 bjsxt. All rights reserved.
//


#import "MYPublicTableViewCell.h"
#import "MYPublicCellIconModel.h"
#import "MYPublicSongDetailModel.h"
#import "MYPublicCellMenuItemButton.h"
#import <NAKPlaybackIndicatorView.h>
#import "UIImageView+SDWedImage.h"
#import "UIImageView+WebCache.h"
#import "MYCreatTool.h"
#import "MYMusicIndicator.h"
#import "View+MASAdditions.h"
#import "JXLDayAndNightMode.h"

/*-----nslog-----*/

#ifdef DEBUG

#define HCLog(...) NSLog(__VA_ARGS__)

#else

#define HCLog(...)

#endif


#define HColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define HCTintColor [MYMusicIndicator shareIndicator].tintColor
#define HCNumColor HColor(148,145,144)
#define HCTextColor HColor(45,46,47)
#define HCMiddleFont [UIFont systemFontOfSize:13.0]
#define HCArtistColor HColor(110,111,112)
#define HCRandomColor HColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define HCScreen [[UIScreen mainScreen] bounds]
#define HCScreenWidth HCScreen.size.width

/*-----Spacing-----*/
#define HCHorizontalSpacing 20

#define HCCommonSpacing 10

#define HCVerticalSpacing 5

@interface MYPublicTableViewCell ()
@property (nonatomic ,weak) UIView *mainView;
@property (nonatomic ,weak) UILabel *numLabel;
@property (nonatomic ,weak) UILabel *titleLabel;
@property (nonatomic ,weak) UILabel *authorLabel;
@property (nonatomic ,weak) UILabel *album_titleLabel;
@property (nonatomic ,weak) UIImageView *pic_SmallView;
@property (nonatomic ,weak) NAKPlaybackIndicatorView *indicatorView;
@property (nonatomic ,weak) UIView *lineView;
@property (nonatomic ,weak) UIView *menuView;
@property (nonatomic) BOOL isLoadedMenu;
@property (nonatomic ,strong) NSArray *cellMenuItemArray;

@end
@implementation MYPublicTableViewCell
static NSInteger ItemPadding = 10;
static NSInteger ItemNum = 2;

#pragma mark - setter
- (NAKPlaybackIndicatorViewState)indicatorViewState
{
    return self.indicatorView.state;
}
- (void)setIndicatorViewState:(NAKPlaybackIndicatorViewState)indicatorViewState
{
    self.indicatorView.state = indicatorViewState;
    self.numLabel.hidden = (indicatorViewState != NAKPlaybackIndicatorViewStateStopped);
}
- (NSArray *)cellMenuItemArray
{
    if (!_cellMenuItemArray) {
        _cellMenuItemArray = [MYPublicCellIconModel CellMenuItemArray];
    }
    return _cellMenuItemArray;
}
- (void)setDetailModel:(MYPublicSongDetailModel *)detailModel
{
    _detailModel = detailModel;
    self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)_detailModel.num];
    if (self.bePic) {
        NSString *image = [NSString stringWithFormat:@"cm2_daily_banner%d",arc4random() % 7];
        [self.pic_SmallView sd_setImageWithURL:[NSURL URLWithString:_detailModel.pic_small] placeholderImage:[UIImage imageNamed:image]];
    }
    self.titleLabel.text = _detailModel.title;
    self.authorLabel.text = [NSString stringWithFormat:@"%@    %@",_detailModel.author,_detailModel.album_title];
}
#pragma mark - setUpCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //不设置会全部显示为下拉菜单
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellEditingStyleNone;
        [self setUpMainView];
        [self setUpButtonAndLine];
        [self setUpIndicator];
        self.menuView = [MYCreatTool viewWithView:self.mainView];
        self.menuView.backgroundColor = [UIColor clearColor];
        self.tintColor = HCTintColor;
    }
    return self;
}
- (void)setUpMainView
{
    self.mainView = [MYCreatTool viewWithView:self];
    self.numLabel = [MYCreatTool labelWithView:self.mainView];
    //self.numLabel.textColor = HCNumColor;
    
    self.pic_SmallView = [MYCreatTool imageViewWithView:self.mainView];
    self.titleLabel = [MYCreatTool labelWithView:self.contentView];
    //self.titleLabel.textColor = HCArtistColor;
    self.authorLabel = [MYCreatTool labelWithView:self.mainView];
    self.authorLabel.font = HCMiddleFont;
    //self.authorLabel.textColor = HCTextColor;
    
    [self jxl_setDayMode:^(UIView *view) {
        
        MYPublicTableViewCell *cell = (MYPublicTableViewCell *)view;
        
        cell.numLabel.textColor = HCNumColor;
        cell.titleLabel.textColor = HCArtistColor;
        cell.authorLabel.textColor = HCTextColor;
        
    } nightMode:^(UIView *view) {
        MYPublicTableViewCell *cell = (MYPublicTableViewCell *)view;
        cell.contentView.backgroundColor = [UIColor blackColor];
        cell.numLabel.textColor = [UIColor whiteColor];
        cell.titleLabel.textColor = [UIColor whiteColor];
        cell.authorLabel.textColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor blackColor];

        
    }];
}

//点击下拉按钮
- (void)setUpButtonAndLine
{
    self.menuButton = [MYCreatTool buttonWithView:self.mainView];
    [self.menuButton setImage:[[UIImage imageNamed:@"唱片"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]forState:UIControlStateNormal];
    [self.menuButton addTarget:self action:@selector(clickMenuButton:) forControlEvents:UIControlEventTouchUpInside];
    //tableviewcell上的线
    self.lineView = [MYCreatTool viewWithView:self.mainView];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
}
- (void)setUpIndicator
{
    NAKPlaybackIndicatorView *indicator = [[NAKPlaybackIndicatorView alloc] init];
    [self.mainView addSubview:indicator];
    self.indicatorView = indicator;
    self.indicatorView.tintColor = HCRandomColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIndicatorView)];
    [self.indicatorView addGestureRecognizer:tap];
}
#pragma mark - layoutCell
- (void)layoutSubviews
{
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.width.mas_equalTo(HCScreenWidth);
        make.height.mas_equalTo(100);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView.mas_left).offset(HCHorizontalSpacing);;
        make.top.equalTo(self.mainView.mas_top).offset(HCVerticalSpacing);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView.mas_left).offset(5);
        make.top.equalTo(self.mainView.mas_top).offset(3);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    [self.pic_SmallView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.numLabel.mas_right).offset(-1 * HCVerticalSpacing);
         make.top.equalTo(self.mainView.mas_top).offset(HCVerticalSpacing);
         make.size.mas_equalTo(CGSizeMake(35, 35));
     }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo((self.bePic ? self.pic_SmallView : self.numLabel).mas_right).offset(HCCommonSpacing);
        make.top.equalTo(self.mainView.mas_top).offset(HCVerticalSpacing);
        make.right.equalTo(self.menuButton.mas_left);
        make.bottom.equalTo(self.authorLabel.mas_top);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.titleLabel.mas_right);
        make.bottom.equalTo(self.lineView.mas_bottom).offset(-1 * HCVerticalSpacing);
    }];
    [self.menuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right);
        make.centerY.equalTo(self.numLabel.mas_centerY);
        make.right.equalTo(self.mainView.mas_right).offset(-1 * HCHorizontalSpacing);
         make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView.mas_left).offset(HCVerticalSpacing);
        make.right.equalTo(self.mainView.mas_right);
        make.top.equalTo(self.mainView.mas_top).offset(49);
        make.height.mas_equalTo(1);
    }];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainView.mas_top).offset(50);
        make.left.and.right.equalTo(self.mainView);
        make.height.mas_equalTo(50);
    }];
}
#pragma mark - reuseCell
+ (instancetype)publicTableViewCellcellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"publicCell";
    MYPublicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MYPublicTableViewCell alloc] initWithFrame:CGRectMake(0, 0, HCScreenWidth, 50)];
    }
    return cell;
}

#pragma mark - creatCellMenu
- (void)setUpCellMenu
{
    if (!self.isLoadedMenu) {
        CGFloat ItemWidth = (HCScreenWidth - ItemPadding * (ItemNum + 1)) / ItemNum;
        __weak __typeof(self) weakSelf = self;
        for (NSInteger i = 0; i < ItemNum; i++) {
            MYPublicCellIconModel *iconModel = self.cellMenuItemArray[i];
            CGRect rect = CGRectMake(ItemPadding + (ItemPadding + ItemWidth) * i, 0, ItemWidth, 44);
            MYPublicCellMenuItemButton *button = [[MYPublicCellMenuItemButton    alloc] initWithFrame:rect model:iconModel];
            button.tag = i;
            [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
            [weakSelf.menuView addSubview:button];
        }
    }
    self.isLoadedMenu = YES;
}
#pragma mark - delegate
- (void)clickItem:(UIButton *)button
{
    //点击下拉菜单对应的button后
    if ([self.delegate respondsToSelector:@selector(clickCellMenuItemAtIndex: Cell:)]) {
        [self.delegate clickCellMenuItemAtIndex:button.tag Cell:self];
    }
}
- (void)clickMenuButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(clickButton:openMenuOfCell:)]) {
       // HCLog(@"展开menu");
        self.isOpenMenu = !self.isOpenMenu;
        [self.delegate clickButton:button openMenuOfCell:self];
    }
}
- (void)clickIndicatorView
{
    if ([self.delegate respondsToSelector:@selector(clickIndicatorView)]) {
        [self.delegate clickIndicatorView];
    }
}
@end
