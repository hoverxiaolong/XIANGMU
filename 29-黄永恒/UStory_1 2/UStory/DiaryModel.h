//
//  DiaryModel.h
//  UStory
//
//  Created by qingyun on 16/9/10.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CompilationModel.h"

@interface DiaryModel : NSObject

@property(nonatomic,assign)NSInteger dId;

@property(nonatomic,copy)NSString *dtitle;

@property(nonatomic,copy)NSString *dcontent;

@property(nonatomic,copy)NSString *dtime;

@property(nonatomic,copy)NSString *dclass;

@property(nonatomic,assign)NSInteger dequalId;

@end