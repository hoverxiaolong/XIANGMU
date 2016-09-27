//
//  MYLrcTool.h
//  美物心语
//
//  Created by qingyun on 16/9/7.
//  Copyright © 2016年 bjsxt. All rights reserved.
//


#import <Foundation/Foundation.h>
@class MYLrcView;
@interface MYLrcTool : NSObject
+ (void)lrcToolDownloadWithUrl:(NSString *)url setUpLrcView:(MYLrcView *)lrcView;
@end
