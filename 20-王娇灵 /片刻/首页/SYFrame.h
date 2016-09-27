//
//  SYFrame.h
//  美物心语
//
//  Created by qingyun on 16/8/30.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SYModel;
@interface SYFrame : NSObject

/**
 *  头像的frame
 */
@property (nonatomic) CGRect iconF;
/**
 *  标题的frame
 */
@property (nonatomic) CGRect nameF;
/**
 *  会员的frame
 */
@property (nonatomic) CGRect vipF;
/**
 *  正文的frame
 */
@property (nonatomic) CGRect contentF;
/**
 *  配图的frame
 */
@property (nonatomic) CGRect pictureF;
/**
 *  cell的高度
 */
@property (nonatomic) CGFloat cellHeight;
/**
 *  底部工具条的frame
 */
@property (nonatomic) CGRect bottomF;

@property (nonatomic) CGRect devierF;

@property (nonatomic, strong) SYModel *sy;



@end
