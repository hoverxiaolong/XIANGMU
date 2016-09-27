//
//  MYLrcTool.h
//  美物心语
//
//  Created by qingyun on 16/9/7.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "MYLrcTool.h"
#import "MYLrcView.h"
#import "MYLrcModel.h"
#import "MYNetWorkTool.h"

@implementation MYLrcTool
+ (void)lrcToolDownloadWithUrl:(NSString *)url setUpLrcView:(MYLrcView *)lrcView
{
    [MYNetWorkTool netWorkToolDownloadWithUrl:url targetPath:NSDocumentDirectory DomainMask:NSUserDomainMask endPath:^(NSURL *endPath) {
        NSMutableArray *lrcArrayM = [NSMutableArray array];
        NSString *path = (NSString *)endPath;
        NSString *lrc = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSArray *Array = [lrc componentsSeparatedByString:@"\n"];
        for (NSString *lrc in Array) {
            if ([lrc hasPrefix:@"[ti:"] || [lrc hasPrefix:@"[ar:"] || [lrc hasPrefix:@"[al:"] || ![lrc hasPrefix:@"["]) {
                continue;
            }
            MYLrcModel *lrcModel = [MYLrcModel lrcModelWithLrcString:lrc];
            [lrcArrayM addObject:lrcModel];
        }
        lrcView.lrcArray = lrcArrayM;
    }];
}
@end
