//
//  CreatCompilationCell.m
//  UStory
//
//  Created by qingyun on 16/8/24.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "CreatCompilationCell.h"
@interface CreatCompilationCell ()<UITextViewDelegate>
{
    __weak UILabel *_lable;
}
@end

@implementation CreatCompilationCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *strID = @"CreatCompilationCell";
    CreatCompilationCell *cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if (!cell) {
        cell = [[CreatCompilationCell alloc]initWithStyle:0 reuseIdentifier:strID];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self loadDefaultSetting];
    }
    return self;
}

-(void)loadDefaultSetting{
    
    UILabel *lable = [[UILabel alloc]init];
    lable.text = @"专辑描述";
    lable.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:lable];
    _lable = lable;
    
    self.txtView = [[UITextView alloc]init];
    self.txtView.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.txtView];
    self.txtView.delegate = self;
    //self.txtView.scrollEnabled = NO;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self.contentView).offset(10);
        make.width.mas_equalTo(65);
    }];
    
    [self.txtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_lable.mas_trailing).offset(15);
        make.top.equalTo(self.contentView).offset(8);
        make.bottom.equalTo(self.contentView).offset(-8);
        make.trailing.equalTo(self.contentView).offset(-10);
    }];
}

- (void)textViewDidChange:(UITextView *)textView{
    CGRect bounds = textView.bounds;
    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [textView sizeThatFits:maxSize];
    bounds.size = newSize;
    textView.bounds = bounds;
    UITableView *tableView = [self tableView];
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (UITableView *)tableView{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
