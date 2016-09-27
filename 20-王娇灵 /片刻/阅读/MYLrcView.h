//
//  MYLrcView.h
//  美物心语
//
//  Created by qingyun on 16/9/8.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYLrcView : UIScrollView
@property (nonatomic) NSTimeInterval currentTime;
@property (nonatomic ,strong) NSArray *lrcArray;
@end
