//
//  CompilationEditVC.m
//  UStory
//
//  Created by qingyun on 16/9/12.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "CompilationEditVC.h"
#import "SlipTitleView.h"
#import "ChooseCoverVC.h"

@interface CompilationEditVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    __weak UITextView *_textView;
    __weak UITableView *_tableView;
    __weak SlipTitleView *_titleView;
}
@property(nonatomic,copy)NSString *strImageName;
@end

@implementation CompilationEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self loadDefaultSetting];
}

- (void)loadDefaultSetting{
    __weak typeof(self) selfWeak = self;
    
    SlipTitleView *titleView = [[SlipTitleView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 40) title:self.model.ctitle];
    [self.view addSubview:titleView];
    [titleView setBlkDidTapBackBtn:^{
        [selfWeak.navigationController popViewControllerAnimated:YES];
    }];
    _titleView = titleView;
    
    /** 确定按钮 */
    UIButton *btnConfirm = [[UIButton alloc]init];
    [btnConfirm setTitle:@"保存" forState:UIControlStateNormal];
    [titleView addSubview:btnConfirm];
    [btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(titleView).offset(-10);
        make.top.bottom.equalTo(titleView);
    }];
    [btnConfirm addTarget:self action:@selector(tapbtnSaveCompilation) forControlEvents:UIControlEventTouchUpInside];
    
    /** 表格视图 */
    UITableView *tableView = [[UITableView alloc]init];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(titleView.mas_bottom);
        make.height.mas_equalTo(ScreenWidth*0.6 + 176);
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.scrollEnabled = NO;
    _tableView = tableView;
    //删除多余的行
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    /** 故事集图片 */
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth *0.6)];
    self.imageView.image = [UIImage imageNamed:self.model.coverImage];
    tableView.tableHeaderView = self.imageView;
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    
    /** 删除按钮 */
    UIButton *btnDelete = [[UIButton alloc]init];
    btnDelete.backgroundColor = [UIColor whiteColor];
    [btnDelete setTitle:@"删除专辑" forState:UIControlStateNormal];
    [btnDelete setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btnDelete.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:btnDelete];
    [btnDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(tableView.mas_bottom).offset(15);
        make.height.mas_equalTo(40);
    }];
    [btnDelete addTarget:self action:@selector(deleteCompilatioin) forControlEvents:UIControlEventTouchUpInside];
    
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
            
            self.txfCom = [[UITextField alloc]init];
            self.txfCom.text = self.model.ctitle;
            self.txfCom.placeholder = @"不超过12字";
            self.txfCom.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:self.txfCom];
            [self.txfCom mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(lable.mas_trailing).offset(15);
                make.top.equalTo(cell.contentView).offset(8);
                make.bottom.equalTo(cell.contentView).offset(-8);
                make.trailing.equalTo(cell.contentView).offset(-10);
            }];
            [self.txfCom addTarget:self action:@selector(txfComEdit) forControlEvents:UIControlEventEditingChanged];

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
            
            self.image = [[UIImageView alloc]init];
            self.image.contentMode = UIViewContentModeScaleToFill;
            self.image.image = [UIImage imageNamed:self.model.coverImage];
            [cell.contentView addSubview:self.image];
            [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(lable.mas_trailing).offset(15);
                make.top.equalTo(cell.contentView).offset(4);
                make.width.mas_equalTo(36/0.65);
                make.height.mas_equalTo(36);
            }];
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
            textView.text = self.model.cdescribe;
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

#pragma mark - ▷ 设置行高 ◁
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 44;
    }else if (indexPath.row == 1){
        return 44;
    }
    return 88;
}

#pragma mark - ▷ 选中单元格 ◁
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        ChooseCoverVC *coverVC = [[ChooseCoverVC alloc]init];
        [self.navigationController pushViewController:coverVC animated:YES];
        coverVC.blkCoverImage = ^(NSString *coverImage){
            self.image.image = [UIImage imageNamed:coverImage];
            self.imageView.image = [UIImage imageNamed:coverImage];
            self.strImageName = coverImage;
        };
    }
}

- (void)txfComEdit{
    if (self.txfCom.text.length > 12) {
        self.txfCom.text = [self.txfCom.text substringToIndex:12];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if (_textView.text.length > 80) {
        _textView.text = [_textView.text substringToIndex:80];
    }
}

#pragma mark - ▷ 保存故事集 ◁
- (void)tapbtnSaveCompilation{
    CompilationModel *model = [[CompilationModel alloc]init];
    model.cId = self.model.cId;
    model.ctitle = self.txfCom.text;
    if (self.strImageName.length == 0) {
        model.coverImage = self.model.coverImage;
    }else{
    model.coverImage = self.strImageName;
    }
    model.cdescribe = _textView.text;
    [[CompilationDb shareInstance]Resave:self.model.cId Info:model];
    if (self.blkEditCompilation) {
        self.blkEditCompilation(self.txfCom.text,model.coverImage,_textView.text);
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - ▷ 删除故事集 ◁
- (void)deleteCompilatioin{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"删除故事集" message:@"确定要删除该故事集吗？\n删除故事集不会删除里面的故事内容" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[CompilationDb shareInstance]Delete:self.model.cId];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }]];
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

#pragma mark - ▷ 键盘即将出现 ◁
-(void)keyboardWillShow:(NSNotification *)noti{
    //根据通知的info,找到键盘显示的最终位置,显示过程中的动画时长
    CGFloat animation = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:animation animations:^{
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(-55);
        }];
        [self.view bringSubviewToFront:_titleView];
        [self.view layoutIfNeeded];
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
