//
//  WW_BaseReportViewController.h
//  WW_Report
//
//  Created by dingchuandong on 2017/7/3.
//  Copyright © 2017年 dingchuandong. All rights reserved.
//

#import "WW_ItemsLayer.h"
#import "WW_ItemsCollectionViewCell.h"

@interface WW_BaseReportViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) WW_ItemsLayer *layout;
@property (nonatomic, strong) UICollectionView *listCV;
@property (nonatomic, strong) UIScrollView *headerViewScrollView;
@property (nonatomic, strong) UIView *headerBgView;   //报表头的背景
@property (nonatomic, strong) UIView *bgView;         //报表上如果有其他需要显示 调整这个



/**
 刷新报表
 
 @param data 报表的数据源
 @param columnWidths 指定每一列的宽度（放在数组里）列如：@5表示 （实际宽度 = 5 *（一个字的宽度【15号字体】）+ 6）；默认（3 *（一个字的宽度【15号字体】）+ 6）
 */
-(void)updateMyList:(NSDictionary *)data withColumnWidths:(NSArray *)columnWidths;

//collectionView 代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;



@end
