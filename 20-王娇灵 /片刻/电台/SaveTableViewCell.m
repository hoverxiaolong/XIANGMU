//
//  SaveTableViewCell.m
//  美物心语
//
//  Created by qingyun on 16/9/14.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "SaveTableViewCell.h"
#import "MYPublicSongDetailModel.h"
#import "UIImageView+AFNetworking.h"
#import "JXLDayAndNightMode.h"

@implementation SaveTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView {
    
    self.titleLable = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLable];
    //self.titleLable.backgroundColor = [UIColor lightGrayColor];
    //self.titleLable.textColor = [UIColor blackColor];
    self.titleLable.textAlignment = YES;
    
    self.imageViewTu = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imageViewTu];
    
    //夜间模式
    [self jxl_setDayMode:^(UIView *view) {
        SaveTableViewCell *cell = (SaveTableViewCell *)view;
        
        cell.titleLable.textColor = [UIColor blackColor];
        cell.titleLable.backgroundColor = [UIColor redColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
    } nightMode:^(UIView *view) {
        
        SaveTableViewCell *cell = (SaveTableViewCell *)view;
        
        cell.titleLable.textColor = [UIColor whiteColor];
        cell.textLabel.backgroundColor = [UIColor blackColor];
        cell.contentView.backgroundColor = [UIColor blackColor];
    }];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.imageViewTu.frame = CGRectMake(5, 5, self.contentView.frame.size.width / 4, 90);
    self.titleLable.frame = CGRectMake(10 + self.contentView.frame.size.width / 4, 20, self.contentView.frame.size.width / 5 * 3, 60);
}

- (void)setModel:(MYPublicSongDetailModel *)model {
    
    _model = model;
    _titleLable.text = model.title;
    [_imageViewTu setImageWithURL:[NSURL URLWithString:model.pic_small]];
}

@end
