//
//  SaveTableViewCell.h
//  美物心语
//
//  Created by qingyun on 16/9/14.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYPublicSongDetailModel;

@interface SaveTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,strong) UIImageView *imageViewTu;
@property (nonatomic,strong) MYPublicSongDetailModel *model;

@end
