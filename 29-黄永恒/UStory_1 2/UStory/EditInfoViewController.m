//
//  EditInfoViewController.m
//  UStory
//
//  Created by qingyun on 16/8/31.
//  Copyright © 2016年 黄永恒. All rights reserved.
//  修改个人信息

#import "EditInfoViewController.h"
#import "SlipTitleView.h"
#import "ChooseGenderView.h"
#import "TZImagePickerController.h"

@interface EditInfoViewController ()<UITableViewDataSource,UITableViewDelegate,ChooseGenderDelegate,TZImagePickerControllerDelegate>
{
    __weak ChooseGenderView *_chooseGenderView;
    __weak UIView *_bgView;
    __weak UILabel *_labShowGender;
    __weak UILabel *_labShowBirth;
    __weak UIDatePicker *_datePicker;
    __weak UIButton *_dateBtn;
    __weak UITextField *_txfName;
    __weak UIImageView *_headImage;
}
@end

@implementation EditInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadDefaultSetting];
}

- (void)loadDefaultSetting{
    __weak typeof(self) selfWeak = self;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefault dataForKey:@"usersHeaderImage"];
    UIImage *image = [UIImage imageWithData:data];

    /** 背景图片 */
    UIImageView *bgImage = [[UIImageView alloc]init];
    bgImage.image = [UIImage imageNamed:@"bg2.jpg"];
    [self.view addSubview:bgImage];
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
        make.height.mas_equalTo(ScreenWidth * 0.618);
    }];
    
    /** 标题视图 */
    SlipTitleView *titleView = [[SlipTitleView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 40) title:@"个人资料"];
    titleView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleView];
    [titleView setBlkDidTapBackBtn:^{
        [selfWeak.navigationController popViewControllerAnimated:YES];
    }];
    
    /** 保存按钮 */
    UIButton *saveBtn = [[UIButton alloc]init];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [titleView addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.equalTo(titleView).offset(-10);
        make.top.equalTo(titleView).offset(10);
    }];
    [saveBtn addTarget:self action:@selector(didTapSaveBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    /** 头像 */
    UIImageView *headImage = [[UIImageView alloc]init];
    headImage.image = [UIImage imageNamed:@"headimage"];
    [self.view addSubview:headImage];
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(bgImage);
        make.width.height.mas_equalTo(80);
    }];
    _headImage = headImage;
    headImage.layer.cornerRadius = 40;
    headImage.layer.masksToBounds = YES;
    if (image != nil) {
        headImage.image = image;
    }
    
    /** 更换头像 */
    UIButton *changeBtn = [[UIButton alloc]init];
    [changeBtn setTitle:@"更换头像" forState:UIControlStateNormal];
    changeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:changeBtn];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgImage);
        make.top.equalTo(headImage.mas_bottom).offset(20);
        make.width.mas_equalTo(100);
    }];
    [changeBtn addTarget:self action:@selector(ChangeUserHeaderImage) forControlEvents:UIControlEventTouchUpInside];
    
    /** 表格视图 */
    UITableView *tableView = [[UITableView alloc]init];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(10);
        make.trailing.equalTo(self.view).offset(-10);
        make.top.equalTo(bgImage.mas_bottom).offset(10);
        make.height.mas_equalTo(44 * 2);
    }];
    tableView.dataSource = self;
    tableView.delegate = self;
    //tableView.allowsSelection = NO;
    tableView.scrollEnabled = NO;
    
    /** 退出登录 */
    UIButton *logoutBtn = [[UIButton alloc]init];
    logoutBtn.backgroundColor = [UIColor colorWithRed:105/255.0 green:193/255.0 blue:149/255.0 alpha:1];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:logoutBtn];
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(tableView);
        make.bottom.equalTo(self.view).offset(-50);
        make.height.mas_equalTo(40);
    }];
    logoutBtn.layer.cornerRadius = 5;
    logoutBtn.layer.masksToBounds = YES;
    [logoutBtn addTarget:self action:@selector(tapLogOutBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.top.equalTo(self.view);
    }];
    _bgView = bgView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBgview)];
    [bgView addGestureRecognizer:tap];
    
    /** 选择性别 */
    ChooseGenderView *chooseGenderView = [[ChooseGenderView alloc]init];
    chooseGenderView.backgroundColor = [UIColor whiteColor];
    chooseGenderView.alpha = 0;
    [self.view addSubview:chooseGenderView];
    [chooseGenderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.width.mas_equalTo(ScreenWidth - 100);
        make.height.mas_equalTo((ScreenWidth - 100)*0.6);
    }];
    chooseGenderView.layer.cornerRadius = 5;
    chooseGenderView.layer.masksToBounds = YES;
    chooseGenderView.delegate = self;
    _chooseGenderView = chooseGenderView;
    
    /** 时间选择器 */
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_cn"];
    //[self.view addSubview:datePicker];
    [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(tableView);
        make.top.equalTo(bgImage.mas_bottom).offset(20);
        make.height.mas_equalTo(180);
    }];
    datePicker.layer.cornerRadius = 5;
    datePicker.layer.masksToBounds = YES;
    _datePicker = datePicker;
    _datePicker.alpha = 0;
    
    /** 选择生日按钮 */
    UIButton *dateBtn = [[UIButton alloc]init];
    dateBtn.backgroundColor = [UIColor whiteColor];
    [dateBtn setTitle:@"确  定" forState:UIControlStateNormal];
    [dateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
   // [self.view addSubview:dateBtn];
    [dateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(datePicker);
        make.height.mas_equalTo(40);
        make.top.equalTo(datePicker.mas_bottom);
    }];
    _dateBtn = dateBtn;
    dateBtn.alpha = 0;
    [dateBtn addTarget:self action:@selector(chooseBirthday) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *strId = @"editcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:strId];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if (indexPath.row == 0) {
            /** 昵称 */
            UILabel *labName = [[UILabel alloc]init];
            labName.text = @"昵称";
            labName.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:labName];
            [labName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView).offset(15);
                make.top.bottom.equalTo(cell.contentView);
                make.width.mas_equalTo(40);
            }];
            
            UITextField *txfName = [[UITextField alloc]init];
            txfName.text = [userDefault stringForKey:@"usersName"];
            txfName.placeholder = @"请输入昵称";
            [cell.contentView addSubview:txfName];
            [txfName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(labName.mas_trailing).offset(15);
                make.top.bottom.trailing.equalTo(cell.contentView);
            }];
            _txfName = txfName;
        }else if (indexPath.row == 1){
            /** 性别 */
            UILabel *labGender = [[UILabel alloc]init];
            labGender.text = @"性别";
            labGender.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:labGender];
            [labGender mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView).offset(15);
                make.top.bottom.equalTo(cell.contentView);
                make.width.mas_equalTo(40);
            }];
            
            UILabel *labShowGender = [[UILabel alloc]init];
            labShowGender.text = [userDefault stringForKey:@"usersGender"];
            labShowGender.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:labShowGender];
            [labShowGender mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(labGender.mas_trailing).offset(15);
                make.top.bottom.equalTo(cell.contentView);
                make.width.mas_equalTo(100);
            }];
         _labShowGender = labShowGender;
        }else{
            /** 生日 */
            UILabel *labBirthday= [[UILabel alloc]init];
            labBirthday.text = @"生日";
            labBirthday.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:labBirthday];
            [labBirthday mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView).offset(15);
                make.top.bottom.equalTo(cell.contentView);
                make.width.mas_equalTo(40);
            }];
            
            UILabel *labShowBirth = [[UILabel alloc]init];
            labShowBirth.text = [userDefault stringForKey:@"usersBirth"];
            labShowBirth.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:labShowBirth];
            [labShowBirth mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(labBirthday.mas_trailing).offset(15);
                make.top.bottom.equalTo(cell.contentView);
                make.width.mas_equalTo(150);
            }];
            _labShowBirth = labShowBirth;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        [UIView animateWithDuration:0.25 animations:^{
            _bgView.alpha = 0.5;
            _chooseGenderView.alpha = 1;
        }];
    }if (indexPath.row == 2) {
        [UIView animateWithDuration:1 animations:^{
            _bgView.alpha = 0.5;
            _datePicker.alpha = 1;
            _dateBtn.alpha = 1;
        }];
    }
}

#pragma mark - ▷ 保存信息 ◁
- (void)didTapSaveBtn{
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        
        NSData *imageData = UIImagePNGRepresentation(_headImage.image);
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setValue:_txfName.text forKey:@"usersName"];
        [userDefault setValue:_labShowGender.text forKey:@"usersGender"];
        [userDefault setValue:_labShowBirth.text forKey:@"usersBirth"];
        [userDefault setObject:imageData forKey:@"usersHeaderImage"];
        [userDefault synchronize];
        
        TipView *tipView = [[TipView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 50, ScreenHeight - 200, 100, 30) Title:@"保存成功" Time:1];
        tipView.blkTipView = ^{
            [self.navigationController popViewControllerAnimated:YES];
        };
        [self.view addSubview:tipView];
        
    }else{
        TipView *tipView = [[TipView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 75, ScreenHeight - 200, 150, 30) Title:@"请先登录，即可上传个人信息" Time:2];
        [self.view addSubview:tipView];
    }
    
}

#pragma mark - ▷ 退出登录 ◁
- (void)tapLogOutBtn{
    [AVUser logOut];  //清除缓存用户对象
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ▷ 更换头像 ◁
- (void)ChangeUserHeaderImage{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    // 你可以通过block或者代理，来得到用户选择的照片.
    imagePickerVc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto){
        _headImage.image = photos[0];
    };
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - ▷ 选择性别 ◁
- (void)ChooseGenderWithTag:(NSInteger)sex Gender:(NSString *)gender{
    _labShowGender.text = gender;
    [UIView animateWithDuration:0.7 animations:^{
        _bgView.alpha = 0;
        _chooseGenderView.alpha = 0;
    }];
}

#pragma mark - ▷ 选择生日 ◁
- (void)chooseBirthday{
    [UIView animateWithDuration:1 animations:^{
        _bgView.alpha = 0;
        _datePicker.alpha = 0;
        _dateBtn.alpha = 0;
    }];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    _labShowBirth.text = [formatter stringFromDate:_datePicker.date];
}

- (void)tapBgview{
    [UIView animateWithDuration:0.7 animations:^{
        _bgView.alpha = 0;
        _dateBtn.alpha = 0;
        _datePicker.alpha = 0;
        _chooseGenderView.alpha = 0;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
