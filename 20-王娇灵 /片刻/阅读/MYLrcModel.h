//
//  MYLrcModel.h
//  美物心语
//
//  Created by qingyun on 16/9/8.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYLrcModel : NSObject
@property (nonatomic) NSTimeInterval time;
@property (nonatomic, copy) NSString *text;
- (instancetype)initWithLrcString:(NSString *)lrcString;
+ (instancetype)lrcModelWithLrcString:(NSString *)lrcString;
@end
