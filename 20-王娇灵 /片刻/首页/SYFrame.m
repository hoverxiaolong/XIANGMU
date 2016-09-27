//
//  SYFrame.m
//  美物心语
//
//  Created by qingyun on 16/8/30.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "SYFrame.h"
#import "SYModel.h"
#import "NSString+Extension.h"

@implementation SYFrame

-(void)setSy:(SYModel *)sy{
    _sy = sy;
    
    // 每个控件之间的间距
    CGFloat padding = 10;
    
    // 头像的frame
    CGFloat iconX = padding;
    CGFloat iconY = padding;
    CGFloat iconW = 50;
    CGFloat iconH = 50;
    _iconF = CGRectMake(iconX, iconY, iconW, iconH);
    
    // 标题的frame
    // 先计算出文字的真实尺寸
    CGSize nameSize = [sy.name sizeWithFont:SYNameFont maxSize:CGSizeMake(200, MAXFLOAT)];
    
    CGFloat nameX = CGRectGetMaxX(_iconF) + padding;
    CGFloat nameY = iconY + (iconH - nameSize.height) * 0.5;
    _nameF = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    
    
    // 会员的frame
    CGFloat vipX = CGRectGetMaxX(_nameF) + padding;
    CGFloat vipW = 14;
    CGFloat vipH = vipW;
    CGFloat vipY = iconY + (iconH - vipH)*0.5;
    _vipF = CGRectMake(vipX, vipY, vipW, vipH);
    
    
    // 正文的frame
    CGFloat contentX = padding;
    CGFloat contentY = CGRectGetMaxY(_iconF) + padding;
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 2 * padding;
    CGSize contentSize = [sy.content sizeWithFont:SYContentFont maxSize:CGSizeMake(contentW, MAXFLOAT)];
    _contentF = CGRectMake(contentX, contentY, contentSize.width, contentSize.height);
    
    // 配图的frame
    //    if(examM.picture){// 如果有配图就计算其frame，并计算出每行的高度
    CGFloat pictureW = 200;
    CGFloat pictureH = 150;
    CGFloat pictureX = ([UIScreen mainScreen].bounds.size.width - pictureW) * 0.5;
    CGFloat pictureY = CGRectGetMaxY(_contentF) + padding;
    _pictureF= CGRectMake(pictureX, pictureY, pictureW, pictureH);
    
    //        _cellHeight = CGRectGetMaxY(_pictureF) + padding;
    //    }else{
    //        // 如果没有配图，直接计算每行的高度即可
    //        _cellHeight = CGRectGetMaxY(_contentF) + padding;
    //    }
    
    // 底部工具条的frame
    CGFloat bottomX = 0;
    CGFloat bottomW = [UIScreen mainScreen].bounds.size.width;
    CGFloat bottomH = 30;
    CGFloat bottomY;
    
    
    if(sy.picture){
        
        bottomY = CGRectGetMaxY(_pictureF) + padding;
        _bottomF = CGRectMake(bottomX, bottomY, bottomW, bottomH);
        
    }else{
        
        bottomY = CGRectGetMaxY(_contentF) + padding;
        _bottomF = CGRectMake(bottomX, bottomY, bottomW, bottomH);
    }
    
        // 每一行的高度
    _cellHeight = CGRectGetMaxY(_bottomF) + 5;
    
    // cell的分割线
    _devierF = CGRectMake(0, _cellHeight - 1, [UIScreen mainScreen].bounds.size.width, 1);
    
}
@end
