//
//  HCRankListCell.m
//  美物心语
//
//  Created by qingyun on 16/9/10.
//  Copyright © 2016年 bjsxt. All rights reserved.
//


#import "HCRankListCell.h"
#import "HCRankSongModel.h"
#import "UIImageView+WebCache.h"
#import "MYCreatTool.h"
#import "NSObject+MJKeyValue.h"
#import "MYPublicHeadView.h"
#import "JXLDayAndNightMode.h"

/*-----screenSize-----*/
#define HCScreen [[UIScreen mainScreen] bounds]

#define HCScreenWidth HCScreen.size.width

#define HCScreenHeight HCScreen.size.height

/*-----Spacing-----*/
#define HCHorizontalSpacing 20

#define HCCommonSpacing 10

#define HCVerticalSpacing 5

#define HCBigFont [UIFont systemFontOfSize:15.0]

@interface HCRankListCell ()
@property (nonatomic ,weak) UIImageView *cellImageView;
@property (nonatomic,strong) UILabel *label;
@end
@implementation HCRankListCell
- (void)setRankListImage:(NSString *)rankListImage
{
    _rankListImage = rankListImage;
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:_rankListImage]];
}

- (instancetype)initWithArray:(NSArray *)array
{
    if (self = [super init]) {
        NSInteger imageHeight = HCScreenWidth / 3;
        CGFloat labelHeight = (imageHeight - 3 * HCVerticalSpacing) / 4;
        CGFloat labelWidth = HCScreenWidth - imageHeight - 3 * HCVerticalSpacing;
        self.cellImageView = [MYCreatTool imageViewWithView:self.contentView];
        self.cellImageView.frame = CGRectMake(HCVerticalSpacing, HCVerticalSpacing, imageHeight, imageHeight);
        NSInteger i = 0;
        for (NSDictionary *dict in array) {
            HCRankSongModel *song = [HCRankSongModel mj_objectWithKeyValues:dict];
            UILabel *label = [MYCreatTool labelWithView:self.contentView];
            self.label = label;
            label.frame = CGRectMake(imageHeight + 2 * HCVerticalSpacing, HCVerticalSpacing + (HCVerticalSpacing + labelHeight) * i, labelWidth, labelHeight);
            label.text = [NSString stringWithFormat:@"%ld. %@ - %@",(long)i + 1,song.title,song.author];
            label.font = HCBigFont;
            i++;
            
            [self jxl_setDayMode:^(UIView *view) {
                
                HCRankListCell *cell = (HCRankListCell *)view;
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.label.textColor = [UIColor blackColor];
            } nightMode:^(UIView *view) {
                HCRankListCell *cell = (HCRankListCell *)view;
                cell.label.textColor = [UIColor whiteColor];
                cell.contentView.backgroundColor = [UIColor blackColor];
                
            }];
        }
    }
    return self;
}

+ (instancetype)rankCellWithTableView:(UITableView *)tableView songInfoArray:(NSArray *)info
{
    static NSString *ID = @"rankCell";
    HCRankListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HCRankListCell alloc] initWithArray:info];
    }
    return cell;
}
@end
