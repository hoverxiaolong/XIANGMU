//
//  SYFootView.h
//  美物心语
//
//  Created by qingyun on 16/9/1.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYFootView;

@protocol SYFootViewDelegate <NSObject>

- (void)SYFootViewClickLoadBtn:(SYFootView *)footView;

@end

@interface SYFootView : UIView

@property (nonatomic,weak) id<SYFootViewDelegate>delegate;
+ (instancetype)loadFootView;

@end
