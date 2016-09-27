//
//  SYAllCell.m
//  美物心语
//
//  Created by qingyun on 16/8/30.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "SYAllCell.h"
#import "SYModel.h"
#import "NSString+Extension.h"
#import "SYFrame.h"
#import "JXLDayAndNightMode.h"

#define SYBottomSubViewsColor [UIColor lightGrayColor]
#define SYBottomTitleColor [UIColor blueColor]

@interface SYAllCell ()

/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *iconView;
/**
 *  标题
 */
@property (nonatomic, weak) UILabel *nameLabel;
/**
 *  正文
 */
@property (nonatomic, weak) UILabel *contentLabel;
/**
 *  会员
 */
@property (nonatomic, weak) UIImageView *vipView;

/**
 *  底部的工具条
 */
@property (nonatomic, weak) UIView *bottomView;
/**
 *  cell的分割线
 */
@property (nonatomic, weak) UIView *devier;
@property (nonatomic,strong)CADisplayLink *link;
@property (nonatomic,strong) UIButton *relayBtn;

@end

@implementation SYAllCell

#pragma mark - 对cell的重用进行封装
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    // 定义一个可循环引用的标识
    static NSString *ID = @"exam";
    
    // 从缓存池中找这个标识
    SYAllCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 如果没有找到，就重新实例化一个cell
    if(nil == cell){
        cell = [[SYAllCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

#pragma mark - 重写cell的initWithStye:reuseIdentifier
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    // 判断
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        // 重新实例化cell中的每个控件
        [self setUpSubViews];
    }
    
    return self;
}

#pragma mark - 实例化cell中的每个控件
- (void)setUpSubViews{
    // 头像
    UIImageView *iconImage = [[UIImageView alloc] init];
    // 给图片添加一个手势
    iconImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *handClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageClick)];
    [iconImage addGestureRecognizer:handClick];
    // 设置边框的颜色
    iconImage.layer.borderColor = [UIColor greenColor].CGColor;
    // 设置边框的宽度
    iconImage.layer.borderWidth = 2;
    [self.contentView addSubview:iconImage];
    self.iconView = iconImage;
    
    // 标题
    UILabel *nameLabel = [[UILabel alloc] init];
    // 设置标题文字的尺寸
    nameLabel.font = SYNameFont;
    nameLabel.numberOfLines = 0;
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    // 会员
    UIImageView *vipImage = [[UIImageView alloc] init];
    // 设置图片
    vipImage.image = [UIImage imageNamed:@"vip"];
    
    [self.contentView addSubview:vipImage];
    self.vipView = vipImage;
    
    // 正文
    UILabel *content = [[UILabel alloc] init];
    //content.textColor = SYRandomColor;
    // 设置是否换行
    content.numberOfLines = 0;
    // 设置正文文字的尺寸
    content.font = SYContentFont;
    [self.contentView addSubview:content];
    self.contentLabel = content;
    
    // 配图
    UIButton *picture = [[UIButton alloc] init];
    // 设置颜色
    picture.backgroundColor = SYRandomColor;
    picture.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [picture addTarget:self action:@selector(pictureClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:picture];
    self.pictureView = picture;
    
    // 底部的View
    UIView *bottomView = [[UIView alloc] init];
    self.bottomView = bottomView;
    [self.contentView addSubview:bottomView];
    
    // 转发按钮
    UIButton *relayBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 6, 50, 20)];
    self.relayBtn = relayBtn;
    relayBtn.layer.cornerRadius = 10;
    relayBtn.layer.masksToBounds = YES;
    relayBtn.titleLabel.font = SYNameFont;
    [relayBtn setTitle:@"转发" forState:UIControlStateNormal];
    
    //[relayBtn setTitleColor:SYBottomTitleColor forState:UIControlStateNormal];
    [relayBtn addTarget:self action:@selector(relayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:relayBtn];
    
    
    // 点赞按钮
    UIButton *supportBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 10 - relayBtn.frame.size.width, relayBtn.frame.origin.y, relayBtn.frame.size.width, relayBtn.frame.size.height)];
    self.supportBtn = supportBtn;
    supportBtn.layer.cornerRadius = 10;
    supportBtn.layer.masksToBounds = YES;
   
    [supportBtn setImage:[UIImage imageNamed:@"icon_ios_heart"]  forState:UIControlStateNormal];
    [supportBtn setImage:[UIImage imageNamed:@"icon_ios_heart_filled"]forState:UIControlStateSelected];
    
    [supportBtn addTarget:self action:@selector(supportBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:supportBtn];
    
   
    // cell的分割线
    UIView *devier = [[UIView alloc] init];
    self.devier = devier;
    devier.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:devier];
    
    
    //夜间模式
    [self jxl_setDayMode:^(UIView *view) {
        
        SYAllCell *cell = (SYAllCell *)view;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.nameLabel.textColor = [UIColor blackColor];
        cell.nameLabel.backgroundColor = [UIColor whiteColor];
        cell.contentLabel.backgroundColor = [UIColor whiteColor];
        cell.contentLabel.textColor = SYRandomColor;
        [cell.relayBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
    } nightMode:^(UIView *view) {
        
        SYAllCell *cell = (SYAllCell *)view;
        cell.contentView.backgroundColor = [UIColor blackColor];
        cell.nameLabel.textColor = [UIColor whiteColor];
        cell.nameLabel.backgroundColor = [UIColor whiteColor];
        cell.contentLabel.backgroundColor = [UIColor blackColor];
        cell.contentLabel.textColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor blackColor];
        [cell.relayBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }];
    
}

#pragma mark - 转发按钮
- (void)relayBtnClick {
    if (self.zhuanfa) {
        self.zhuanfa();
    }
    //NSLog(@"转发");
}


#pragma mark - 赞按钮
- (void)supportBtnClick {
    if (self.dianzan) {
        self.dianzan();
    }

}

#pragma mark - 用frame模型的做法
-(void)setExamFrame:(SYFrame *)examFrame
{
    _examFrame = examFrame;
    
    // 设置数据
    [self settingSubViewsWithData:examFrame];
    
    // 设置frame
    [self settingSubViewsWithFrame:examFrame];
}

#pragma mark - 给每个对象赋值
-(void)settingSubViewsWithData:(SYFrame *)examFrame{
    
    SYModel *examModel = self.examFrame.sy;
    // 头像
    self.iconView.image = [UIImage imageNamed:examModel.icon];
    
    // 会员
    if(examModel.isVip){
        // 如果是VIP，就让它显示，并设置标题的颜色为红色
        self.vipView.hidden = NO;
        //  标题颜色
        self.nameLabel.textColor = [UIColor redColor];
    }else{ // 如果不是VIP,就让它隐藏，并设置标题的颜色为黑色
        self.vipView.hidden = YES;
        // 标题的颜色
        self.nameLabel.textColor = [UIColor blackColor];
        
    }
    
    // 标题
    self.nameLabel.text = examModel.name;
    
    // 正文
    self.contentLabel.text = examModel.content;
    
    // 配图
    if(examModel.picture){// 如果有配图就让其显示
        self.pictureView.hidden = NO;
        
        [self.pictureView setImage:[UIImage imageNamed:examModel.picture] forState:UIControlStateNormal];
        
    }else{// 如果没有配图就隐藏
        self.pictureView.hidden = YES;
    }
    
    
}

#pragma mark - 计算每个控件的frame
-(void)settingSubViewsWithFrame:(SYFrame *)examFrame{
    //头像的frame
    self.iconView.frame = examFrame.iconF;
    // 标题的frame
    self.nameLabel.frame = examFrame.nameF;
    // 会员的frame
    self.vipView.frame = examFrame.vipF;
    // 正文的frame
    self.contentLabel.frame = examFrame.contentF;
    // 配图的frame
    if (self.examFrame.sy.picture){
        self.pictureView.frame = examFrame.pictureF;
    }
    // 底部工具条的frame
    self.bottomView.frame = examFrame.bottomF;
    
    
    
    // cell的分割线
    self.devier.frame = examFrame.devierF;
    
}

#pragma mark - 监听头像的点击
-(void)iconImageClick{
    if ([self.delegate respondsToSelector:@selector(examCellWithIconImageAddHandclick:)]){
        [self.delegate examCellWithIconImageAddHandclick:self];
    }
    
   
    
}

#pragma mark - 监听配图的点击事件
-(void)pictureClick{
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pictureClick" object:self userInfo:@{@"picture":_examFrame.sy.picture}];
}

#pragma mark - 重新布局头像的尺寸(为头像设置圆角)
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.iconView.layer.cornerRadius = self.iconView.frame.size.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    
}



@end
