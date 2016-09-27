//
//  MYPublicTableView.h
//  美物心语
//
//  Created by qingyun on 16/9/3.
//  Copyright © 2016年 bjsxt. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^ShoucangBtnClick)(NSInteger);

@interface MYPublicTableView : UITableView

@property (nonatomic,strong) ShoucangBtnClick shoucang;

- (void)setSongList:(NSMutableArray *)list songIds:(NSMutableArray *)ids;
@end
