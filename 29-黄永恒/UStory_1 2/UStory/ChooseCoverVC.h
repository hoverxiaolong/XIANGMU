//
//  ChooseCoverVC.h
//  UStory
//
//  Created by qingyun on 16/8/24.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseCoverVC : UIViewController

@property(nonatomic,copy)void(^blkCoverImage)(NSString *coverImage);

@end
