//
//  DiaryContentController.h
//  UStory
//
//  Created by 黄永恒 on 16/8/19.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiaryModel.h"

@interface DiaryContentController : UIViewController

@property(nonatomic,strong)DiaryModel *model;
@property(nonatomic,copy)void(^blkReload)();

@end
