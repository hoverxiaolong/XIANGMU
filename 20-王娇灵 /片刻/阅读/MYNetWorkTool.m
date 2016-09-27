//
//  MYNetWorkTool.m
//  美物心语
//
//  Created by qingyun on 16/9/10.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "MYNetWorkTool.h"
#import <MBProgressHUD.h>
#import "MYPromptTool.h"
#import <AFNetworking.h>


/*-----nslog-----*/

#ifdef DEBUG

#define HCLog(...) NSLog(__VA_ARGS__)

#else

#define HCLog(...)

#endif

@interface MYNetWorkTool ()

@end


@implementation MYNetWorkTool
+ (void)netWorkToolGetWithUrl:(NSString *)url parameters:(NSDictionary *)parameters response:(void (^)(id))success
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status <= 0) {
            [MYPromptTool promptModeText:@"没有网络了" afterDelay:2];
        }else{
            MBProgressHUD *netPrompt = [MYPromptTool promptModeIndeterminatetext:@"正在加载中"];
            //加载数据
            AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
            
            manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"application/javascript",nil];
//            if (![url isKindOfClass:[NSString class]]) {
//                NSLog(@"url:%@",url);
//            }
//            
            [manger GET:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                
                if (responseObject) {
                    [netPrompt removeFromSuperview];
                    if (success) {
                        success(responseObject);
                    }
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [netPrompt removeFromSuperview];
                HCLog(@"%@",error);
            }];
            
        
        }
    }];
}

+ (void)netWorkToolDownloadWithUrl:(NSString *)string targetPath:(NSSearchPathDirectory)path DomainMask:(NSSearchPathDomainMask)mask endPath:(void(^)(NSURL *endPath))endPath
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentUrl = [[NSFileManager defaultManager] URLForDirectory:path inDomain:mask appropriateForURL:nil create:NO error:nil];
        return [documentUrl URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        HCLog(@"%@",error);
        if (!error && endPath) {
            endPath(filePath);
        }
        //NSLog(@"%@",response);
        
    }];
    [downloadTask resume];
}
@end
