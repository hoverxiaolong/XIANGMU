//
//  FaceModel.h
//  Yueba
//
//  Created by qingyun on 16/9/5.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaceModel : NSObject

@property (nonatomic, strong)NSString *text;
@property (nonatomic, strong)NSString *imgName;
@property (nonatomic)BOOL isBack;
@property (nonatomic)BOOL isBlack;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
