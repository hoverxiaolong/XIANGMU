//
//  MYLrcCell.m
//  美物心语
//
//  Created by qingyun on 16/9/9.
//  Copyright © 2016年 bjsxt. All rights reserved.
//


#import "MYLrcCell.h"
#import "MYLrcLabel.h"
#import "View+MASAdditions.h"

#define HColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define HCTextColor HColor(45,46,47)
#define HCMiddleFont [UIFont systemFontOfSize:13.0]


@implementation MYLrcCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        MYLrcLabel *lrcLabel = [[MYLrcLabel alloc] init];
        lrcLabel.textColor = HCTextColor;
        lrcLabel.font = HCMiddleFont;
        lrcLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:lrcLabel];
        _lrcLabel = lrcLabel;
        lrcLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [lrcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
    }
    return self;
}

+ (instancetype)lrcCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"LrcCell";
    MYLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MYLrcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
@end
