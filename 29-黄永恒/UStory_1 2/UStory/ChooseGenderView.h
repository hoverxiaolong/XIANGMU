//
//  ChooseGenderView.h
//  UStory
//
//  Created by qingyun on 16/9/8.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseGenderDelegate<NSObject>

- (void)ChooseGenderWithTag:(NSInteger)sex Gender:(NSString *)gender;

@end

@interface ChooseGenderView : UIView

@property(nonatomic,weak)id<ChooseGenderDelegate>delegate;

@end
