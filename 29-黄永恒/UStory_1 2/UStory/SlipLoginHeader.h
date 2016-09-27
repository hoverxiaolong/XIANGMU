//
//  SlipLoginHeader.h
//  UStory
//
//  Created by qingyun on 16/9/8.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlipLoginDelegate<NSObject>

- (void)LoginHeaderView;

@end

@interface SlipLoginHeader : UIView

@property(nonatomic,weak)id<SlipLoginDelegate>delegate;
@property(nonatomic,copy)NSString *strUserName;

@end
