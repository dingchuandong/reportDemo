//
//  WW_BaseReportViewController.m
//  WW_Report
//
//  Created by dingchuandong on 2017/7/3.
//  Copyright © 2017年 dingchuandong. All rights reserved.
//

#import "WW_BaseReportViewController.h"

#define NormalWidth 100  //表格默认宽度
#define mWindow             [[[UIApplication sharedApplication] windows] lastObject]
#define kThirdLevelFont [UIFont fontWithName:@"PingFangSC-Regular"size:14]


@interface WW_BaseReportViewController ()

@property (nonatomic, strong) NSArray *keyAry,*columnWidths;
@property (nonatomic, assign) BOOL isJump;
@property (nonatomic, assign) int lockColumn;
@property (nonatomic, strong) NSMutableArray *infoAry;

@end

@implementation WW_BaseReportViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:46/255.0
                                                green:60/255.0
                                                 blue:73/255.0
                                                alpha:1];
    
    _infoAry = [[NSMutableArray alloc] init];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 4, self.view.frame.size.width, self.view.frame.size.height - 64 - 4)];
    [self.view addSubview:_bgView];
    
//    _headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
//    [_bgView addSubview:_headerBgView];
    
    _headerViewScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    _headerViewScrollView.showsHorizontalScrollIndicator = NO;
    _headerViewScrollView.delegate = self;
    [_bgView addSubview:_headerViewScrollView];
    
    //1.初始化layout
    WW_ItemsLayer *layout = [[WW_ItemsLayer alloc] init];
    //2.初始化collectionView
    _listCV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    _listCV.backgroundColor = [UIColor clearColor];
    [_listCV setDirectionalLockEnabled:YES];
    _listCV.delegate = self;
    _listCV.dataSource = self;
    [_listCV registerClass:[WW_ItemsCollectionViewCell class] forCellWithReuseIdentifier:@"BaoBiaoItem"];
    [_bgView addSubview:_listCV];
}

//更新数据
-(void)updateMyList:(NSDictionary *)data withColumnWidths:(NSArray *)columnWidths{
    _lockColumn = [data[@"lockColumn"] intValue];
    if (_lockColumn < 0) {
        _lockColumn = 0;
    }
    _columnWidths = [[NSArray alloc] initWithArray:columnWidths];
    if (data) {
        NSArray *titleAry = [[NSArray alloc] initWithArray:data[@"TitleResult"]];
        if (titleAry.count > 0) {
            [self headerScrollerWithStr:titleAry[0][@"Column1"]];
        }
    }
    self.infoAry = [[NSMutableArray alloc]initWithArray:data[@"DataResult"] copyItems:YES];
    self.keyAry = [data[@"KeyStr"] componentsSeparatedByString:@","];
    for (NSString *key in self.keyAry) {
        if ([key rangeOfString:@"Report"].location != NSNotFound) {
            _isJump = YES;
        }
    }
    if(!self.layout){
        self.layout = [[WW_ItemsLayer alloc]init];
        self.listCV.collectionViewLayout = self.layout;
    }
    [self.layout reset];
    [self.layout setLockColumn:_lockColumn];
    if (mWindow.frame.size.width > 375) {
        [self.layout setItemHeight:50];
    }else{
        [self.layout setItemHeight:44];
    }
    
    if (self.infoAry == nil || self.infoAry.count == 0) {
        self.listCV.hidden = YES;
        self.listCV.contentOffset = CGPointMake(0, _listCV.contentOffset.y);
        [self.listCV reloadData];
        return;
    }
    self.listCV.hidden = NO;

    NSDictionary *dic = self.infoAry[0];
    if (_isJump == YES) {
        [self.layout setColumnWidths:columnWidths withColumns:(int)dic.allKeys.count - 2 withMaxWidth:mWindow.frame.size.width];
    }else{
        [self.layout setColumnWidths:columnWidths withColumns:(int)dic.allKeys.count withMaxWidth:mWindow.frame.size.width];
    }
    [self.listCV reloadData];
}

- (void)headerScrollerWithStr:(NSString *)titleStr
{
    if (titleStr) {
        BOOL isTwo; //是否是两行表头
        isTwo = [titleStr containsString:@" "];

        _headerViewScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, isTwo ? 80 : 50);
        for (UILabel *lab in _headerViewScrollView.subviews) {
            if ([lab isKindOfClass:[UILabel class]]) {
                [lab removeFromSuperview];
            }
        }
        NSMutableArray *titleAry = [[NSMutableArray alloc] initWithArray:[titleStr componentsSeparatedByString:@"#"]];
        if (titleAry.count > 0) {
            if ([titleAry[0] isEqualToString:@""]) {
                [titleAry removeObjectAtIndex:0];
            }
        }
        NSInteger col = -1; //行数 初始化
        NSMutableArray *rowAry = [[NSMutableArray alloc] init];//需要合并的行数组
        NSMutableArray *colAry = [[NSMutableArray alloc] init];//需要合并的列数组
        float scrollViewWidth = 0;
        float scrollViewLeft = 0;   //左边 初始位置
        for (int i = 0; i < titleAry.count; i ++) {
            float labWidth = 0;
            if (i < _columnWidths.count) {
                labWidth = ([_columnWidths[i] floatValue]) ;
            }else{
                labWidth = NormalWidth ;
            }

            NSString *str = titleAry[i];
            //一级标题
            NSMutableArray *detailAry = [[NSMutableArray alloc] initWithArray:[str componentsSeparatedByString:@" "]];
            if (detailAry.count == 1) {
                //存取行标 及标题
                col = col + 1;
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)col],@"col",detailAry[0],@"title", nil];
                [colAry addObject:dic];
                
                UILabel *lab = [[UILabel alloc] init];
                lab.textAlignment = NSTextAlignmentCenter;
                lab.textColor = [UIColor colorWithRed:46/255.0
                                                green:148/255.0
                                                 blue:197/255.0
                                                alpha:1];
                lab.font = kThirdLevelFont;
                lab.backgroundColor = [UIColor colorWithRed:46/255.0
                                                      green:60/255.0
                                                       blue:73/255.0
                                                      alpha:1];
                lab.layer.borderWidth = 0.5;
                lab.layer.borderColor = [UIColor colorWithRed:40/255.0
                                                        green:54/255.0
                                                         blue:63/255.0
                                                        alpha:1].CGColor;
                lab.numberOfLines = 0;
                lab.text = detailAry[0];
                
                if (i < _lockColumn) {
                    lab.frame = CGRectMake(scrollViewLeft , 0, labWidth, isTwo ? 80 : 50);
                    [_bgView addSubview:lab];
                    scrollViewLeft = scrollViewLeft + labWidth;
                }else{
                    lab.frame = CGRectMake(scrollViewWidth , 0, labWidth, isTwo ? 80 : 50);
                    [_headerViewScrollView addSubview:lab];
                    scrollViewWidth = scrollViewWidth + labWidth;
                }
                
            }else{
                //二级标题
                NSArray *detail2Ary = [detailAry[1] componentsSeparatedByString:@","];
                col = col + detail2Ary.count;
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)col],@"col",detailAry[0],@"title",detail2Ary,@"secondTitle", nil];
                [rowAry addObject:dic];
                
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(scrollViewWidth , 0, labWidth * detail2Ary.count,  40)];
                lab.textAlignment = NSTextAlignmentCenter;
                lab.textColor = [UIColor colorWithRed:46/255.0
                                                green:148/255.0
                                                 blue:197/255.0
                                                alpha:1];
                lab.font = kThirdLevelFont;
                lab.backgroundColor = [UIColor colorWithRed:46/255.0
                                                      green:60/255.0
                                                       blue:73/255.0
                                                      alpha:1];
                lab.layer.borderWidth = 0.5;
                lab.layer.borderColor = [UIColor colorWithRed:40/255.0
                                                        green:54/255.0
                                                         blue:63/255.0
                                                        alpha:1].CGColor;
                lab.numberOfLines = 0;
                lab.text = detailAry[0];
                
                if (i < _lockColumn) {
                    lab.frame = CGRectMake(scrollViewLeft , 0, labWidth, isTwo ? 80 : 50);
                    [_bgView addSubview:lab];
                    scrollViewLeft = scrollViewLeft + labWidth;
                }else{
                    lab.frame = CGRectMake(scrollViewWidth , 0, labWidth, isTwo ? 80 : 50);
                    [_headerViewScrollView addSubview:lab];
                    scrollViewWidth = scrollViewWidth + labWidth;
                }
                
                for (int j = 0; j < detail2Ary.count; j ++) {
                    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(scrollViewWidth + labWidth * j, 40, labWidth , 40)];
                    lab2.textAlignment = NSTextAlignmentCenter;
                    lab2.textColor = [UIColor colorWithRed:46/255.0
                                                     green:148/255.0
                                                      blue:197/255.0
                                                     alpha:1];
                    lab2.font = kThirdLevelFont;
                    lab2.backgroundColor = [UIColor colorWithRed:46/255.0
                                                           green:60/255.0
                                                            blue:73/255.0
                                                           alpha:1];
                    lab2.layer.borderWidth = 0.5;
                    lab2.layer.borderColor = [UIColor colorWithRed:40/255.0
                                                             green:54/255.0
                                                              blue:63/255.0
                                                             alpha:1].CGColor;
                    lab2.numberOfLines = 0;
                    lab2.text = detail2Ary[j];
                    
                    if (i < _lockColumn) {
                        lab.frame = CGRectMake(scrollViewLeft , 0, labWidth, isTwo ? 80 : 50);
                        [_bgView addSubview:lab];
                        scrollViewLeft = scrollViewLeft + detail2Ary.count * labWidth;
                    }else{
                        lab.frame = CGRectMake(scrollViewWidth , 0, labWidth, isTwo ? 80 : 50);
                        [_headerViewScrollView addSubview:lab];
                        scrollViewWidth = scrollViewWidth + detail2Ary.count * labWidth;
                    }
                }
            }
        }
        _headerViewScrollView.frame = CGRectMake(scrollViewLeft, 0, scrollViewWidth,  _headerViewScrollView.frame.size.height);
    }
   _listCV.frame = CGRectMake(0, _headerViewScrollView.frame.origin.x + _headerViewScrollView.frame.size.height, _listCV.frame.size.width, _bgView.frame.size.height - _headerViewScrollView.frame.origin.x - _headerViewScrollView.frame.size.height);
}

#pragma mark - UICollectionView 的代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    [collectionView.collectionViewLayout invalidateLayout];
    
    return self.infoAry.count;//返回 报表 共有多少行
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSDictionary *dic = self.infoAry[section];
    return _isJump ? dic.allKeys.count - 2 : dic.allKeys.count;//返回 报表 每行有多少列
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

        WW_ItemsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BaoBiaoItem" forIndexPath:indexPath];
        
        NSDictionary *dic = self.infoAry[indexPath.section];
        [cell setTitle:dic[_keyAry[indexPath.row]]];
    
        return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //处理 点击 事件
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _listCV) {
        _headerViewScrollView.contentOffset = CGPointMake(_listCV.contentOffset.x, _headerViewScrollView.contentOffset.y);
    }else if (scrollView == _headerViewScrollView){
        if (self.infoAry.count > 0) {
            _listCV.contentOffset = CGPointMake(_headerViewScrollView.contentOffset.x, _listCV.contentOffset.y);
        }
    }
}

@end
