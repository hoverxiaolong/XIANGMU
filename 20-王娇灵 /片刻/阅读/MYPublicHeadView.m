//
//  MYPublicHeadView.m
//  美物心语
//
//  Created by qingyun on 16/9/2.
//  Copyright © 2016年 bjsxt. All rights reserved.
//点击cell之后下一个页面的headView上的btn按钮

#import "MYPublicHeadView.h"
#import "MYPublicSonglistModel.h"
#import "UIImageView+WebCache.h"
#import "MYCreatTool.h"
#import "View+MASAdditions.h"
#import "MYMusicIndicator.h"
#import "MYPromptTool.h"

#define HCBigFont [UIFont systemFontOfSize:15.0]
#define HCTintColor [MYMusicIndicator shareIndicator].tintColor
#define HCMiddleFont [UIFont systemFontOfSize:13.0]
#define HCScreen [[UIScreen mainScreen] bounds]

#define HCScreenWidth HCScreen.size.width

#define HCScreenHeight HCScreen.size.height
#define HCHorizontalSpacing 20

#define HCCommonSpacing 10

#define HCVerticalSpacing 5

/*-----nslog-----*/

#ifdef DEBUG

#define HCLog(...) NSLog(__VA_ARGS__)

#else

#define HCLog(...)

#endif



@interface MYPublicHeadView ()
@property (nonatomic ,weak) UIImageView *picView;
@property (nonatomic ,weak) UILabel *titleLabel;
@property (nonatomic ,weak) UILabel *tagLabel;
@property (nonatomic ,weak) UILabel *listenumLabel;

@property (nonatomic ,weak) UIButton *collectButton;
@property (nonatomic ,weak) UIButton *shareButton;
@property (nonatomic ,weak) UIButton *likeButton;
@property (nonatomic ,weak) UIButton *MenuButton;

@property (nonatomic ,weak) UILabel *descLabel;

@property (nonatomic ,assign) BOOL isFullImage;
@end
@implementation MYPublicHeadView
- (void)setMenuList:(MYPublicSonglistModel *)listModel
{
    [self.picView sd_setImageWithURL:[NSURL URLWithString:listModel.pic_500]];
    self.titleLabel.text = listModel.title;
    self.tagLabel.text = listModel.tag;
    self.listenumLabel.text = [NSString stringWithFormat:@"%@个听众  %@个粉丝",listModel.listenum,listModel.collectnum];
    self.descLabel.text = listModel.desc;
}
- (void)setNewAlbum:(MYPublicSonglistModel *)albumModel
{
    [self.picView sd_setImageWithURL:[NSURL URLWithString:albumModel.pic_radio]];
    self.titleLabel.text = albumModel.title;
    self.tagLabel.text = albumModel.author;
    self.listenumLabel.text = [NSString stringWithFormat:@"%@发行",albumModel.publishtime];
    self.descLabel.text = albumModel.info;
}
#pragma mark - setUp
- (instancetype)initWithFullHead:(BOOL)full
{
    if (self = [super init]) {
        [self setUpHeadView];
        //[self setUpButtons];
        [self setUpDescLabel];
        self.isFullImage = full;
        self.tintColor = HCTintColor;
    }
    return self;
}

- (void)setUpHeadView
{
    self.picView        = [MYCreatTool imageViewWithView:self];
    
    self.titleLabel     = [MYCreatTool labelWithView:self];
    self.titleLabel.font = HCBigFont;
    self.titleLabel.numberOfLines = 0;
    
    self.tagLabel       = [MYCreatTool labelWithView:self];
 
    self.tagLabel.font = HCMiddleFont;
    
    self.listenumLabel  = [MYCreatTool labelWithView:self];

    self.listenumLabel.font = HCMiddleFont;
}
- (void)setUpDescLabel
{
    self.descLabel      = [MYCreatTool labelWithView:self];
    self.descLabel.font = HCMiddleFont;
    self.descLabel.numberOfLines = 0;
}
#pragma mark - layout
- (void)layoutSubviews
{
    [self layoutDescLabel];
    
    self.isFullImage ? [self layoutBigImageAndLabel] : [self layoutSmallImageAndLabel];
}
- (void)layoutBigImageAndLabel
{
    self.listenumLabel.textColor = [UIColor whiteColor];
    self.tagLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.size.mas_equalTo(CGSizeMake(HCScreenWidth, HCScreenWidth));
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top).offset(-0.5 * HCScreenWidth);
    }];
    [self.listenumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(HCHorizontalSpacing);
        make.bottom.equalTo(self.picView.mas_bottom).offset(-1 * HCCommonSpacing);
        make.height.mas_equalTo(HCScreenWidth * 0.5);
        make.height.mas_equalTo(20);
    }];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.listenumLabel);
        make.bottom.equalTo(self.listenumLabel.mas_top).offset(-0.5 * HCVerticalSpacing);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tagLabel.mas_top).offset(-0.5 * HCVerticalSpacing);
        make.left.equalTo(self.mas_left).offset(HCHorizontalSpacing);
        make.right.equalTo(self.mas_right).offset(-HCHorizontalSpacing);
        make.height.mas_equalTo(20);
    }];

}
- (void)layoutSmallImageAndLabel
{
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(HCHorizontalSpacing);
        make.left.equalTo(self.mas_left).offset(HCHorizontalSpacing);
        make.bottom.equalTo(self.descLabel.mas_top).offset(-1 * HCHorizontalSpacing);
        make.width.equalTo(self.picView.mas_height);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picView.mas_top);
        make.left.equalTo(self.picView.mas_right).offset(HCHorizontalSpacing);
        make.right.equalTo(self.mas_right).offset(-HCHorizontalSpacing);
        make.height.mas_equalTo(40);
    }];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(HCVerticalSpacing);
        make.left.and.right.equalTo(self.titleLabel);
    }];
    [self.listenumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagLabel.mas_bottom).offset(HCVerticalSpacing);
        make.left.and.right.equalTo(self.tagLabel);
    }];

}

- (void)layoutDescLabel
{
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(HCHorizontalSpacing);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right).offset(-1 * HCHorizontalSpacing);
        make.height.mas_offset(60);
    }];

}
#pragma mark - clickButtons

@end
