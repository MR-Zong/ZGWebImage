//
//  ViewController.m
//  ZGWebImage
//
//  Created by 徐宗根 on 16/10/24.
//  Copyright (c) 2016年 XuZonggen. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+ZGWebCache.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = self.view.bounds;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
}

- (void)example1
{
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake(100, 100, 100, 100);
    _imageView.backgroundColor = [UIColor redColor];
    // 大图地址 http://anchortest.shuoba.org/anchorImage/10979/3410b8fe210331d215000499fa54c120
    // 小图地址 http://anchortest.shuoba.org/anchorImage/10979/3410b8fe210331d215000499fa54c120
    [_imageView zg_setImageWithUrl:[NSURL URLWithString:@"http://anchortest.shuoba.org/anchorImage/10979/3410b8fe210331d215000499fa54c120"]];
    [self.view addSubview:_imageView];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZGWebImageExample"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZGWebImageExample"];
    }
    [cell.imageView zg_setImageWithUrl:[NSURL URLWithString:@"http://anchortest.shuoba.org/anchorImage/10979/3410b8fe210331d215000499fa54c120"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0;
}

@end
