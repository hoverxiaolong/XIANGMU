//
//  CreatCompilationCell.h
//  UStory
//
//  Created by qingyun on 16/8/24.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatCompilationCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong)UITextView *txtView;

@end
