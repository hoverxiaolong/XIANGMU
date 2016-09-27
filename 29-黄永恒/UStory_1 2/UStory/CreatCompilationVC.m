//
//  CreatCompilationVCViewController.m
//  UStory
//
//  Created by 黄永恒 on 16/8/22.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "CreatCompilationVC.h"
#import "ChooseCoverVC.h"
#import "SlipTitleView.h"
#import "TipView.h"

@interface CreatCompilationVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    __weak UITableView *_tableView;
    __weak UIImageView *_imageView;
    __weak UIImageView *_image;
    __weak UITextField *_txfCom;
    __weak SlipTitleView *_titleView;
    __weak UITextView *_textView;
    
}
@property(nonatomic,copy)NSString *strImageName;
@end

@implementation CreatCompilationVC

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    [self loadDefaultSetting];
}

-(void)loadDefaultSetting{
    __weak typeof(self) selfWeak = self;
    
    SlipTitleView *titleView = [[SlipTitleView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 40) title:@"新建故事集"];
//    titleView.backgroundColor = randomColor;
    [self.view addSubview:titleView];
    [titleView setBlkDidTapBackBtn:^{
        [selfWeak.navigationController popViewControllerAnimated:YES];
    }];
    _titleView = titleView;
    
    /** 确定按钮 */
    UIButton *btnConfirm = [[UIButton alloc]init];
    [btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
    [titleView addSubview:btnConfirm];
    [btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(titleView).offset(-10);
        make.top.bottom.equalTo(titleView);
    }];
    [btnConfirm addTarget:self action:@selector(tapbtnConfirm) forControlEvents:UIControlEventTouchUpInside];

    /** 表格视图 */
    UITableView *tableView = [[UITableView alloc]init];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view).offset(60);
        make.height.mas_equalTo(ScreenHeight - 20);
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.scrollEnabled = NO;
    _tableView = tableView;
    //删除多余的行
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth *0.6)];
    imageView.image = [UIImage imageNamed:@"work_4"];
    tableView.tableHeaderView = imageView;
    imageView.contentMode = UIViewContentModeScaleToFill;
    _imageView = imageView;
    
    //添加键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *strId = @"CreatCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strId];
    if (!cell) {
         cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:strId];
        if (indexPath.row == 0) {
            UILabel *lable = [[UILabel alloc]init];
            lable.text = @"专辑名称";
            lable.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:lable];
            [lable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView).offset(10);
                make.top.equalTo(cell.contentView).offset(10);
                make.bottom.equalTo(cell.contentView).offset(-10);
                make.width.mas_equalTo(65);
            }];
            
            UITextField *txfCom = [[UITextField alloc]init];
            txfCom.placeholder = @"不超过12字";
            txfCom.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:txfCom];
            [txfCom mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(lable.mas_trailing).offset(15);
                make.top.equalTo(cell.contentView).offset(8);
                make.bottom.equalTo(cell.contentView).offset(-8);
                make.trailing.equalTo(cell.contentView).offset(-10);
            }];
            [txfCom addTarget:self action:@selector(edit) forControlEvents:UIControlEventEditingChanged];
            _txfCom = txfCom;
        }
        if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *lable = [[UILabel alloc]init];
            lable.text = @"更换封面";
            lable.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:lable];
            [lable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.top.equalTo(cell.contentView).offset(10);
                make.bottom.equalTo(cell.contentView).offset(-10);
                make.width.mas_equalTo(65);
            }];
            
            UIImageView *image = [[UIImageView alloc]init];
            image.contentMode = UIViewContentModeScaleToFill;
            image.image = [UIImage imageNamed:@"work_4"];
            [cell.contentView addSubview:image];
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(lable.mas_trailing).offset(15);
                make.top.equalTo(cell.contentView).offset(4);
                make.width.mas_equalTo(36/0.65);
                make.height.mas_equalTo(36);
            }];
            cell.contentView.clipsToBounds = YES;
            _image = image;
        }
        if (indexPath.row == 2) {
            
            UILabel *lable = [[UILabel alloc]init];
            lable.text = @"专辑描述";
            lable.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:lable];
            [lable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.top.equalTo(cell.contentView).offset(10);
                make.bottom.equalTo(cell.contentView).offset(-10);
                make.width.mas_equalTo(65);
            }];
            
            UITextView *textView = [[UITextView alloc]init];
            textView.font = [UIFont systemFontOfSize:16];
            [cell.contentView addSubview:textView];
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(lable.mas_trailing).offset(15);
                make.top.bottom.equalTo(cell.contentView);
                make.trailing.equalTo(cell.contentView).offset(-5);
            }];
            textView.delegate = self;
            _textView = textView;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 44;
    }else if (indexPath.row == 1){
        return 44;
    }
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        ChooseCoverVC *coverVC = [[ChooseCoverVC alloc]init];
        [self.navigationController pushViewController:coverVC animated:YES];
        coverVC.blkCoverImage = ^(NSString *coverImage){
            _image.image = [UIImage imageNamed:coverImage];
            _imageView.image = [UIImage imageNamed:coverImage];
            self.strImageName = coverImage;
        };
    }
}

- (void)edit{
    if (_txfCom.text.length > 12) {
        _txfCom.text = [_txfCom.text substringToIndex:12];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if (_textView.text.length > 80) {
        _textView.text = [_textView.text substringToIndex:80];
    }
}


#pragma mark - ▷ 保存故事集 ◁
- (void)tapbtnConfirm{
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970];
    
    if (_txfCom.text.length == 0) {
        TipView *tip = [[TipView alloc]initWithFrame:CGRectMake((ScreenWidth - 150)/2, 20 + 40 + ScreenWidth * 0.6, 150, 50) Title:@"定个小目标，写个小标题" Time:1.5];
        [self.view addSubview:tip];
        return;
    }
    
    CompilationModel *compilationModel = [[CompilationModel alloc]init];
    compilationModel.cId = time;
    compilationModel.ctitle = _txfCom.text;
    compilationModel.cdescribe = _textView.text;
    if (self.strImageName.length == 0) {
        compilationModel.coverImage = @"work_4";
    }else{
        compilationModel.coverImage = self.strImageName;
    }
    [[CompilationDb shareInstance]Insert:compilationModel];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ▷ 键盘即将出现 ◁
-(void)keyboardWillShow:(NSNotification *)noti{
    CGFloat animation = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:animation animations:^{
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
        }];
        [self.view layoutIfNeeded];
        [self.view bringSubviewToFront:_titleView];
    }];
}

#pragma mark - ▷ 键盘即将消失 ◁
-(void)keyboardWillHide:(NSNotification *)noti{
    //根据动画事件,调整底部的约束
    CGFloat animation = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animation animations:^{
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(60);
        }];
        [self.view layoutIfNeeded];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
