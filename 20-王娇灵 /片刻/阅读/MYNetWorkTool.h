//
//  MYNetWorkTool.h
//  美物心语
//
//  Created by qingyun on 16/9/10.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface MYNetWorkTool : NSObject

+ (void)netWorkToolGetWithUrl:(NSString *)url parameters:(NSDictionary *)parameters response:(void(^)(id response))success;
+ (void)netWorkToolDownloadWithUrl:(NSString *)string targetPath:(NSSearchPathDirectory)path DomainMask:(NSSearchPathDomainMask)mask endPath:(void(^)(NSURL *endPath))endPath;
@end
