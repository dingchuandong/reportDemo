//
//  WW_ItemsCollectionViewCell.m
//  WW_Report
//
//  Created by dingchuandong on 2017/7/17.
//  Copyright © 2017年 dingchuandong. All rights reserved.
//

#import "WW_ItemsCollectionViewCell.h"

@implementation WW_ItemsCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _mLabel = [[UILabel alloc] init];
        _mLabel.textAlignment = NSTextAlignmentCenter;
        _mLabel.textColor = [UIColor whiteColor];
        _mLabel.font = [UIFont fontWithName:@"PingFangSC-Regular"size:14];
        _mLabel.backgroundColor = [UIColor colorWithRed:46/255.0
                                                  green:60/255.0
                                                   blue:73/255.0
                                                  alpha:1];
        _mLabel.layer.borderWidth = 0.5;
        _mLabel.layer.borderColor = [UIColor colorWithRed:40/255.0
                                                    green:54/255.0
                                                     blue:63/255.0
                                                    alpha:1].CGColor;
        _mLabel.numberOfLines = 0;
        [self.contentView addSubview:_mLabel];
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _mLabel.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
}

-(void)setTitle:(NSString *)title;
{
    self.mLabel.text = [NSString stringWithFormat:@"%@",title];
}

@end
