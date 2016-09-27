//
//  UIView+distribute.h
//  美物心语
//
//  Created by qingyun on 16/9/10.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (distribute)
- (void)distributeViewsHorizontallyWith:(NSArray *)views margin:(CGFloat)margin;
- (void)distributeViewsVerticallyWith:(NSArray *)views margin:(CGFloat)margin;
- (void)distributeViewsHorizontallyWith:(NSArray *)views;
- (void)distributeViewsVerticallyWith:(NSArray *)views;
@end
