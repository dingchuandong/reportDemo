//
//  ViewController.m
//  reportDemo
//
//  Created by dingchuandong on 2017/7/19.
//  Copyright © 2017年 dingchuandong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"表格 demo";
    
    [self loadData];
}

- (void)loadData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    //设置 锁定 列
    [dic setObject:@1 forKey:@"lockColumn"];
    [self updateMyList:dic withColumnWidths:@[@150]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
