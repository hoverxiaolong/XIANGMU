//
//  CompilationChangeVC.m
//  UStory
//
//  Created by 黄永恒 on 16/8/22.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "CompilationChangeVC.h"
#import "CreatCompilationVC.h"
#import "SlipTitleView.h"

@interface CompilationChangeVC ()<UITableViewDelegate,UITableViewDataSource>
{
//    __weak UITableView *_tableView;
}
@property(nonatomic,strong)NSMutableArray *dataCompilation;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *image;
@property(nonatomic,assign)NSInteger equalId;
@end

@implementation CompilationChangeVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self viewDidLoad];
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataCompilation = [[CompilationDb shareInstance]Query];
    [super viewDidLoad];
    [self loadDefaultSetting];
}

-(void)loadDefaultSetting{
    __weak typeof(self) selfWeak = self;
    
    SlipTitleView *titleView = [[SlipTitleView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 40) title:@"故事集"];
//    titleView.backgroundColor = randomColor;
    [self.view addSubview:titleView];
    [titleView setBlkDidTapBackBtn:^{
        [selfWeak.navigationController popViewControllerAnimated:YES];
    }];
     /** 新建按钮 */
    UIButton *btnCreat = [[UIButton alloc]init];
    [btnCreat setTitle:@"新建" forState:UIControlStateNormal];
    [btnCreat setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnCreat.titleLabel.font = [UIFont systemFontOfSize:15];
    [titleView addSubview:btnCreat];
    [btnCreat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView);
        make.trailing.equalTo(titleView).offset(-10);
        make.top.bottom.equalTo(titleView);
        make.width.mas_equalTo(50);
    }];
    [btnCreat addTarget:self action:@selector(tapBtnCreat) forControlEvents:UIControlEventTouchUpInside];
    
    /** 表格视图 */
    UITableView *tableView = [[UITableView alloc]init];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(titleView.mas_bottom);
    }];
    tableView.rowHeight = 70;
    tableView.delegate = self;
    tableView.dataSource = self;
    //删除多余的行
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataCompilation.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *strId = @"changecompilation";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strId];
    CompilationModel *model = self.dataCompilation[indexPath.row];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:strId];
        UIImageView *image = [[UIImageView alloc]init];
        image.image = [UIImage imageNamed:model.coverImage];
        image.contentMode = UIViewContentModeScaleToFill;
        [cell.contentView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).offset(10);
            make.leading.equalTo(cell.contentView).offset(15);
            make.width.height.mas_equalTo(50);
        }];
    
        cell.contentView.clipsToBounds = YES;
        
        UILabel *labName = [[UILabel alloc]init];
        labName.text = model.ctitle;
        labName.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:labName];
        [labName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(image.mas_trailing).offset(10);
            make.top.bottom.trailing.equalTo(cell.contentView);
        }];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    CompilationModel *model = self.dataCompilation[indexPath.row];
    self.name = model.ctitle;
    self.image = model.coverImage;
    self.equalId = model.cId;
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(back) userInfo:nil repeats:NO];
}

- (void)back{
    if (self.blkCompilationName) {
        self.blkCompilationName(self.name,self.image,self.equalId);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapBtnCreat{
    CreatCompilationVC *creatVC = [[CreatCompilationVC alloc]init];
    [self.navigationController pushViewController:creatVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
