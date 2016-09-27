//
//  MYLrcCell.h
//  美物心语
//
//  Created by qingyun on 16/9/9.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYLrcLabel;
@interface MYLrcCell : UITableViewCell
@property (nonatomic, weak, readonly) MYLrcLabel *lrcLabel;
+ (instancetype)lrcCellWithTableView:(UITableView *)tableView;
@end
