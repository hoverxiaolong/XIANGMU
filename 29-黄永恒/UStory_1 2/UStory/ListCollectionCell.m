//
//  ListCollectionCell.m
//  UStory
//
//  Created by 黄永恒 on 16/8/17.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "ListCollectionCell.h"
#import "DiaryDb.h"
@interface ListCollectionCell()
{
    __weak UIImageView *_imageView;
    __weak UILabel *_labTitle;
    __weak UILabel *_labRecord;
}
@property(nonatomic,strong)NSMutableArray *arrData;
@end

@implementation ListCollectionCell

+ (instancetype)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *StrId = @"collectionCell";
    ListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:StrId forIndexPath:indexPath];
    return cell;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self loadDefaultSetting];
    }
    return self;
}

-(void)loadDefaultSetting{
    
    CGFloat itemWidth = (ScreenWidth - 60)/2;
    /** 图片 */
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self);
        make.height.mas_equalTo(itemWidth/0.8);
    }];
    self.clipsToBounds = YES;
    _imageView = imageView;
    
    /** 标题 */
    UILabel *labTitle = [[UILabel alloc]init];
    labTitle.numberOfLines = 0;
    labTitle.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:labTitle];
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(imageView.mas_bottom);
//        make.height.mas_equalTo(30);
    }];
    _labTitle = labTitle;
    
    /** 故事计数 */
    UILabel *labRecord = [[UILabel alloc]init];
    labRecord.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:labRecord];
    [labRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(labTitle.mas_bottom);
        make.bottom.equalTo(self);
    }];
    _labRecord = labRecord;
    imageView.userInteractionEnabled = NO;
}

- (void)setCompilationModel:(CompilationModel *)compilationModel{
    _compilationModel = compilationModel;
    _imageView.image = [UIImage imageNamed:compilationModel.coverImage];
    _labTitle.text = compilationModel.ctitle;
    self.arrData = [[DiaryDb shareInstance]queryWith:compilationModel.cId];
    _labRecord.text = [NSString stringWithFormat:@"记录%ld",(unsigned long)_arrData.count];
}


@end
