//
//  DiaryViewCell.m
//  UStory
//
//  Created by 黄永恒 on 16/8/19.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "DiaryViewCell.h"
@interface DiaryViewCell ()
{
    __weak  UILabel *_labTite;
    __weak UILabel *_labTime;
    __weak UILabel *_labText;
    __weak UILabel *_labCompilation;
}
@property(nonatomic,strong)NSMutableArray *arrData;
@end

@implementation DiaryViewCell

+ (instancetype)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *StrId = @"diaryCell";
    DiaryViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:StrId forIndexPath:indexPath];
    return cell;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self loadDefaultSetting];
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

-(void)loadDefaultSetting{
    
    /** 标题 */
    UILabel *labTite = [[UILabel alloc]init];
    labTite.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:labTite];
    [labTite mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.leading.equalTo(self.contentView).offset(5);
        make.trailing.equalTo(self.contentView).offset(-5);
    }];
    _labTite = labTite;
    
    /** 文本内容 */
    UILabel *labText = [[UILabel alloc]init];
    labText.numberOfLines = 0;
    labText.textColor = [UIColor lightGrayColor];
    labText.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:labText];
    [labText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(labTite);
        make.top.equalTo(labTite.mas_bottom).offset(10);
        make.height.mas_equalTo(60);
    }];
    _labText = labText;
    
    /** 时间 */
    UILabel *labTime = [[UILabel alloc]init];
    labTime.textAlignment = NSTextAlignmentRight;
    labTime.textColor = [UIColor lightGrayColor];
    labTime.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:labTime];
    [labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(labTite);
        make.bottom.equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(100);
    }];
    _labTime = labTime;
    
    /** 专辑 */
    UILabel *labCompilation = [[UILabel alloc]init];
    labCompilation.textAlignment = NSTextAlignmentCenter;
    labCompilation.textColor = [UIColor colorWithRed:37/255.0 green:148/255.0 blue:67/255.0 alpha:1];
    labCompilation.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:labCompilation];
    [labCompilation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(labText);
        make.bottom.top.equalTo(labTime);
        make.width.greaterThanOrEqualTo(@(70));
    }];
    labCompilation.layer.cornerRadius = 7.5;
    labCompilation.layer.borderColor = [UIColor colorWithRed:37/255.0 green:148/255.0 blue:67/255.0 alpha:1].CGColor;
    labCompilation.layer.borderWidth = 0.5;
    labCompilation.layer.masksToBounds = YES;
    _labCompilation = labCompilation;
}

- (void)setModel:(DiaryModel *)model{
    _model = model;

    _labTite.text = model.dtitle;
    if (model.dequalId == 0) {
        _labCompilation.alpha = 0;
    }else{
        self.arrData = [[CompilationDb shareInstance]queryWith:model.dequalId];
        CompilationModel *comModel = self.arrData[0];
        _labCompilation.alpha = 1;
        _labCompilation.text = [NSString stringWithFormat:@" %@ ",comModel.ctitle];
    }
    _labTime.text = model.dtime;
    _labText.text = model.dcontent;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

@end
