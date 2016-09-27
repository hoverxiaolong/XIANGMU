//
//  CompilationEditVC.h
//  UStory
//
//  Created by qingyun on 16/9/12.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompilationModel.h"

@interface CompilationEditVC : UIViewController

@property(nonatomic,strong)CompilationModel *model;

@property(nonatomic,copy)void(^blkEditCompilation)(NSString *strComTitle,NSString *strComImage,NSString *srtComDes);

@property(nonatomic,strong)UITextField *txfCom;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIImageView *image;
@end
