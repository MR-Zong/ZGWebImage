//
//  ViewController.m
//  ZGWebImage
//
//  Created by 徐宗根 on 16/10/24.
//  Copyright (c) 2016年 XuZonggen. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+ZGWebCache.h"
#import "UIButton+ZGWebCache.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self example3];
}

- (void)example1
{
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake(100, 100, 100, 100);
    _imageView.backgroundColor = [UIColor redColor];
    // 大图地址 http://bbsimg.qianlong.com/data/attachment/forum/201409/30/105858f62a7uum6i446770.jpg
    // 小图地址 http://anchortest.shuoba.org/anchorImage/10979/3410b8fe210331d215000499fa54c120
//    [_imageView zg_setImageWithUrl:[NSURL URLWithString:@"http://anchortest.shuoba.org/anchorImage/10979/3410b8fe210331d215000499fa54c120"]];
    [_imageView zg_setImageWithUrl:[NSURL URLWithString:@"http://bbsimg.qianlong.com/data/attachment/forum/201409/30/105858f62a7uum6i446770.jpg"] placeholder:[UIImage imageNamed:@"test.jpg"] completeBlock:^(UIImage *image, NSError *error) {
        NSLog(@"image %@   ************",image);
    }];
    [self.view addSubview:_imageView];
}

- (void)example2
{
    _tableView = [[UITableView alloc] init];
    _tableView.frame = self.view.bounds;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)example3
{
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn.frame = CGRectMake(100, 100, 100, 100);
    self.btn.backgroundColor = [UIColor orangeColor];
    [self.btn zg_setImageWithUrl:[NSURL URLWithString:@"http://bbsimg.qianlong.com/data/attachment/forum/201409/30/105858f62a7uum6i446770.jpg"] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"test.jpg"] completeBlock:^(UIImage *image, NSError *error) {
        NSLog(@"image %@   ************",image);;
    }];
    [self.view addSubview:self.btn];
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
    [cell.imageView zg_setImageWithUrl:[NSURL URLWithString:@"http://anchortest.shuoba.org/anchorImage/10979/3410b8fe210331d215000499fa54c120"] placeholder:[UIImage imageNamed:@"test.jpg"] completeBlock:^(UIImage *image, NSError *error) {
        NSLog(@"image %@   ************",image);
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0;
}

@end
