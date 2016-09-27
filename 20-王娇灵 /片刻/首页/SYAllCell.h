//
//  SYAllCell.h
//  美物心语
//
//  Created by qingyun on 16/8/30.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYAllCell;

//为头像添加的手势设置代理
@protocol  SYAllCellDelegate <NSObject>

// 点击头像时让tableview进入编辑状态
-(void)examCellWithIconImageAddHandclick:(SYAllCell *)celled;
// 点击配图是让其放大
-(void)examCellWithPictureChangeBig:(SYAllCell *)cells;



@end

@class SYFrame;

typedef void(^ZhuanfaBtn)();
typedef void(^DianzanBtn)();

@interface SYAllCell : UITableViewCell
/**
 *  快速创建一个cell
 */
+(instancetype)cellWithTableView:(UITableView *)tableView;

// 传入模型对象
//@property (nonatomic, strong) XGExamModel *examModel;

// 用frame模型的做法
@property (nonatomic, strong) SYFrame *examFrame;

@property (nonatomic, weak) id<SYAllCellDelegate> delegate;

/**
 *  配图
 */
@property (nonatomic, weak) UIButton *pictureView;
@property (nonatomic,strong) ZhuanfaBtn zhuanfa;
@property (nonatomic,strong) DianzanBtn dianzan;
@property (nonatomic,strong) UIButton *supportBtn;

@end
