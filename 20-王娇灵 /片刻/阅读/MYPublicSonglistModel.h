//
//  MYPublicSonglistModel.h
//  Little
//
//  Created by huangcong on 16/4/23.
//  Copyright © 2016年 HuangCong. All rights reserved.
//这个model是新碟上架点击collectionView后下一个tabelview上的数据

#import <UIKit/UIKit.h>

@interface MYPublicSonglistModel : NSObject
@property (nonatomic, copy) NSString *pic_500;
@property (nonatomic, copy) NSString *listenum;
@property (nonatomic, copy) NSString *collectnum;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, strong) NSArray *content;

@property (nonatomic ,copy) NSString *pic_radio;
@property (nonatomic ,copy) NSString *publishtime;
@property (nonatomic ,copy) NSString *info;
@property (nonatomic ,copy) NSString *author;
@end
