//
//  FaceModel.m
//  Yueba
//
//  Created by qingyun on 16/9/5.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "FaceModel.h"

@implementation FaceModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.text = dict[@"faceName"];
        self.imgName = dict[@"imgName"];
    }
    return self;
}

@end
