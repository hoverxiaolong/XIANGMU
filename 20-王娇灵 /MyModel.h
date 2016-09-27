//
//  MyModel.h
//  美物心语
//
//  Created by qingyun on 16/9/12.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloudIM/AVIMTextMessage.h>

@interface MyModel : NSObject

@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *createdAt;
@property (nonatomic,strong) NSDictionary *metaData;
@property (nonatomic,strong) NSString *owner;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
