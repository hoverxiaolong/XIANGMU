//
//  ListCollectionCell.h
//  UStory
//
//  Created by 黄永恒 on 16/8/17.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompilationModel.h"

@interface ListCollectionCell : UICollectionViewCell

NS_ASSUME_NONNULL_BEGIN
+ (instancetype)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath;

@property(nonatomic,strong)CompilationModel *compilationModel;
NS_ASSUME_NONNULL_END

@end
