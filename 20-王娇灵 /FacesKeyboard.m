//
//  FacesKeyboard.m
//  Yueba
//
//  Created by qingyun on 16/9/5.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "FacesKeyboard.h"

#import "FaceModel.h"
#import "FaceCell.h"

#define kFaceWidth 60
#define kFaceHeight 40
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface FacesKeyboard ()<UICollectionViewDataSource, UICollectionViewDelegate>;
@property (weak, nonatomic) IBOutlet UICollectionView *cllectionView;//布局表情
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


@property (nonatomic)NSInteger columns;//每页的列数
@property (nonatomic)NSInteger lines;//每页的行数
@property (nonatomic)NSInteger pageCount;//总共有多少页

@property (nonatomic, strong)NSArray *faces;//表情模型数组


@end

@implementation FacesKeyboard

//nib初始化方法
-(void)awakeFromNib{
    self.columns = kScreenWidth / kFaceWidth;
    self.lines = CGRectGetHeight(self.frame)/kFaceHeight;
    [self loadFaces];//将表情加载到内存
    
    //配置CollectionView
    _cllectionView.dataSource = self;
    _cllectionView.delegate = self;
    //注册nib
    UINib *nib = [UINib nibWithNibName:@"FaceCell" bundle:nil];
    
    [_cllectionView registerNib:nib forCellWithReuseIdentifier:@"facecell"];
    
    //调整item大小,根据个数
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *)self.cllectionView.collectionViewLayout;
    flow.itemSize = CGSizeMake(kScreenWidth / _columns, CGRectGetHeight(self.frame)/ _lines);
    
    _cllectionView.pagingEnabled = YES;
    _cllectionView.showsHorizontalScrollIndicator = NO;
    
    self.pageControl.numberOfPages = self.faces.count /(_lines * _columns);
}

//加载表情
-(void)loadFaces{
    //度取出plist文件
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"Faces" ofType:@"plist"];
    NSDictionary *facesDict = [NSDictionary dictionaryWithContentsOfFile:filepath];
    NSArray *result = facesDict[@"TT"];//读取出TT表情的内容
    //转化为model
    NSMutableArray *models = [NSMutableArray array];
    for (NSUInteger index = 0; index < result.count; index ++) {
        NSDictionary *face = result[index];
        FaceModel *faceModel = [[FaceModel alloc] initWithDict:face];
        
        //在每一页的最后位置添加一个back
        //如果遇到back按钮则添加
        if (index %(_lines * _columns - 1) == 0 && index != 0) {
            FaceModel *back = [[FaceModel alloc] init];
            back.imgName = @"ic_back_emojis";
            back.isBack = YES;
            [models addObject:back];
        }
        
        [models addObject:faceModel];
    }
    
    //在最后一页,不满的位置用空白占位
    //最后一页差的个数
    NSInteger last =_lines * _columns -  models.count %(_lines * _columns);
    if (last >0) {
        //添加空白模型,除了最后一个
        for (NSUInteger index = 0; index < (last -1); index ++) {
            FaceModel *black = [[FaceModel alloc] init];
            black.isBlack = YES;
            [models addObject:black];
        }
        
        //最后添加一个back
        FaceModel *back = [[FaceModel alloc] init];
        back.imgName = @"ic_back_emojis";
        back.isBack = YES;
        [models addObject:back];
    }
    
    self.faces = models;
    
}

#pragma mark - collection delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    //总共多少列
    return self.faces.count/_lines;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _lines;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FaceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"facecell" forIndexPath:indexPath];
    //找到对应的模型对象
    //第几页
    NSInteger indexPage = indexPath.section/_columns;
    
    
    //每页的起点 + 水平方向的增加 + 垂直方向的增加
    NSInteger index = indexPage * (_columns *_lines) + (indexPath.section % _columns) + (indexPath.row * _columns);
    
    FaceModel *model = self.faces[index];
    
    cell.imageView.image = [UIImage imageNamed:model.imgName];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //找到对应的模型对象
    //第几页
    NSInteger indexPage = indexPath.section/_columns;
    //每页的起点 + 水平方向的增加 + 垂直方向的增加
    NSInteger index = indexPage * (_columns *_lines) + (indexPath.section % _columns) + (indexPath.row * _columns);
    FaceModel *model = [self.faces objectAtIndex:index];
    if (self.selectedFace) {
        self.selectedFace(model);
    }
}

@end
