//
//  CompilationChangeVC.h
//  UStory
//
//  Created by 黄永恒 on 16/8/22.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompilationChangeVC : UIViewController

@property(nonatomic,copy)void(^blkCompilationName)(NSString *compilationName,NSString *imageName,NSInteger equalId);

@end
