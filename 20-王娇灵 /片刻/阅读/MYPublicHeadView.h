//
//  MYPublicHeadView.h
//  美物心语
//
//  Created by qingyun on 16/9/2.
//  Copyright © 2016年 bjsxt. All rights reserved.
//


#import <UIKit/UIKit.h>
@class MYPublicSonglistModel;
@interface MYPublicHeadView : UIView
- (void)setMenuList:(MYPublicSonglistModel *)listModel;
- (void)setNewAlbum:(MYPublicSonglistModel *)albumModel;
- (instancetype)initWithFullHead:(BOOL)full;
@end
