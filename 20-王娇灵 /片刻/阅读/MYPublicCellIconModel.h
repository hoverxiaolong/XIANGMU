//
//  MYPublicCellIconModel.h
//  美物心语
//
//  Created by qingyun on 16/9/3.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYPublicCellIconModel : NSObject
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
+ (NSArray *)CellMenuItemArray;
@end
