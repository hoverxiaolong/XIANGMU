//
//  FacesKeyboard.h
//  Yueba
//
//  Created by qingyun on 16/9/5.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FaceModel;
typedef void (^SelectedFace)(FaceModel *faceModel);

@interface FacesKeyboard : UIView

@property (nonatomic, copy)SelectedFace selectedFace;

@end
