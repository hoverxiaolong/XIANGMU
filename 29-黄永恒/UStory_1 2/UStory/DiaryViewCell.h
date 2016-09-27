//
//  DiaryViewCell.h
//  UStory
//
//  Created by 黄永恒 on 16/8/19.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiaryModel.h"

@interface DiaryViewCell : UICollectionViewCell
NS_ASSUME_NONNULL_BEGIN

+ (instancetype)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath;

@property(nonatomic,strong)DiaryModel *model;

NS_ASSUME_NONNULL_END
@end
