//
//  MYPublicCellIconModel.m
//  美物心语
//
//  Created by qingyun on 16/9/3.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "MYPublicCellIconModel.h"
#import <NSObject+MJKeyValue.h>

@implementation MYPublicCellIconModel
+ (NSArray *)CellMenuItemArray
{
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CellMenuItem" ofType:@"plist"]];
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[MYPublicCellIconModel mj_objectWithKeyValues:dict]];
    }
    return arrayM;
}
@end
