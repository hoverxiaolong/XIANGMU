//
//  MYPublicCollectionCellCollectionViewCell.m
//  美物心语
//
//  Created by qingyun on 16/9/3.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "MYPublicCollectionCellCollectionViewCell.h"
#import "MYPublicMusicTabelModel.h"
#import "UIImageView+WebCache.h"
#import "View+MASAdditions.h"
#import "MYCreatTool.h"
#import "JXLDayAndNightMode.h"
#define HCBigFont [UIFont systemFontOfSize:15.0]


@interface MYPublicCollectionCellCollectionViewCell ()
@property (nonatomic ,weak) UIImageView *picView;
@property (nonatomic ,weak) UILabel *titleLabel;
@property (nonatomic ,weak) UILabel *listenumLabel;

@end

@implementation MYPublicCollectionCellCollectionViewCell

- (void)setSongMenu:(MYPublicMusicTabelModel *)menu
{
    [self.picView sd_setImageWithURL:[NSURL URLWithString:menu.pic_300]];
    self.titleLabel.text = menu.title;
    self.listenumLabel.text = [NSString stringWithFormat:@"   🐸%@",menu.listenum];
}
- (void)setNewSongAlbum:(MYPublicMusicTabelModel *)newSong
{
    [self.picView sd_setImageWithURL:[NSURL URLWithString:newSong.pic_big]];
    self.titleLabel.text = [NSString stringWithFormat:@"%@  %@",newSong.author,newSong.title];
    
    [self jxl_setDayMode:^(UIView *view) {
        
        MYPublicCollectionCellCollectionViewCell *cell = (MYPublicCollectionCellCollectionViewCell *)view;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.titleLabel.textColor = [UIColor blackColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
    } nightMode:^(UIView *view) {
        
        MYPublicCollectionCellCollectionViewCell *cell = (MYPublicCollectionCellCollectionViewCell *)view;
        cell.contentView.backgroundColor = [UIColor blackColor];
        cell.titleLabel.textColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor blackColor];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.picView = [MYCreatTool imageViewWithView:self.contentView];
        
        self.titleLabel = [MYCreatTool labelWithView:self.contentView];
        self.titleLabel.font = HCBigFont;
        self.titleLabel.numberOfLines = 0;
        
        self.listenumLabel = [MYCreatTool labelWithView:self.contentView];
        self.listenumLabel.font = HCBigFont;
        self.listenumLabel.textColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(self.mas_width);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picView.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(40);
    }];
    
    [self.listenumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(15);
    }];
}


@end
