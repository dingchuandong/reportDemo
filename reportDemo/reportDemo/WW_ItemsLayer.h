//
//  WW_ItemsLayer.h
//  WW_Report
//
//  Created by dingchuandong on 2017/7/17.
//  Copyright © 2017年 dingchuandong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WW_ItemsLayer : UICollectionViewLayout

//设置锁定列数量
-(void)setLockColumn:(NSInteger)lockColumn;

//设置每个item高度
-(void)setItemHeight:(float)height;

/**
 设置每一列的实际宽度，确定表的总宽度
 
 @param columnWidths 每一列的宽度（放在数组里）
 @param allColumns 总列数
 @param maxWidth 报表最大的宽度
 */
-(void)setColumnWidths:(NSArray *)columnWidths withColumns:(int)allColumns withMaxWidth:(int)maxWidth;

//重置每一个item的大小和布局
-(void)reset;

@end
