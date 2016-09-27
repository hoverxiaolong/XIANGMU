//
//  MYLrcLabel.m
//  Little
//
//  Created by huangcong on 16/4/24.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "MYLrcLabel.h"

@implementation MYLrcLabel
- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGRect drawRect = CGRectMake(0, 0, self.bounds.size.width * self.progress, self.bounds.size.height);
    [[UIColor redColor] set];
    UIRectFillUsingBlendMode(drawRect, kCGBlendModeSourceIn);
}
@end
