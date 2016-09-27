//
//  HCRankListCell.h
//  美物心语
//
//  Created by qingyun on 16/9/10.
//  Copyright © 2016年 bjsxt. All rights reserved.
//


#import <UIKit/UIKit.h>
@interface HCRankListCell : UITableViewCell
@property (nonatomic ,copy) NSString *rankListImage;
+ (instancetype)rankCellWithTableView:(UITableView *)tableView songInfoArray:(NSArray *)info;
@end
