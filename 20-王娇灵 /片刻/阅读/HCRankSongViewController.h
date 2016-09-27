//
//  HCRankSongViewController.h
//  美物心语
//
//  Created by qingyun on 16/9/5.
//  Copyright © 2016年 bjsxt. All rights reserved.
//


#import <UIKit/UIKit.h>
@class HCRankListModel;
@interface HCRankSongViewController : UIViewController
@property (nonatomic ,copy) HCRankListModel *rankType;
@property (nonatomic, retain) NSDictionary *responseObject;
@end
