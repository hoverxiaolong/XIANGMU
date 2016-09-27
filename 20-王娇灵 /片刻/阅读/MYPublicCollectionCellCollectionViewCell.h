//
//  MYPublicCollectionCellCollectionViewCell.h
//  美物心语
//
//  Created by qingyun on 16/9/3.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYPublicMusicTabelModel;
@interface MYPublicCollectionCellCollectionViewCell : UICollectionViewCell

- (void)setSongMenu:(MYPublicMusicTabelModel *)menu;
- (void)setNewSongAlbum:(MYPublicMusicTabelModel *)newSong;

@end
