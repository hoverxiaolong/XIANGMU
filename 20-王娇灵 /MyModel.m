//
//  MyModel.m
//  美物心语
//
//  Created by qingyun on 16/9/12.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "MyModel.h"

@implementation MyModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        
        self.url = dict[@"url"];
        self.metaData = dict[@"metaData"];
        self.createdAt = dict[@"createdAt"];
        self.owner = dict[@"metaData"][@"owner"];
    }
    return self;
}

@end
