//
//  WW_ItemsCollectionViewCell.h
//  WW_Report
//
//  Created by dingchuandong on 2017/7/17.
//  Copyright © 2017年 dingchuandong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WW_ItemsCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *mLabel;
//@property (strong, nonatomic) UIView *lineView;

-(void)setTitle:(NSString *)title;

@end
