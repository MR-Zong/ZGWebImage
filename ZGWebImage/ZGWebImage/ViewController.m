//
//  ViewController.m
//  ZGWebImage
//
//  Created by 徐宗根 on 16/10/24.
//  Copyright (c) 2016年 XuZonggen. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+ZGWebCache.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake(100, 100, 100, 100);
    _imageView.backgroundColor = [UIColor redColor];
    // 大图地址 http://anchortest.shuoba.org/anchorImage/10979/3410b8fe210331d215000499fa54c120
    // 小图地址 http://anchortest.shuoba.org/anchorImage/10979/3410b8fe210331d215000499fa54c120
    [_imageView zg_setImageWithUrl:[NSURL URLWithString:@"http://anchortest.shuoba.org/anchorImage/10979/3410b8fe210331d215000499fa54c120"]];
    [self.view addSubview:_imageView];
}



@end
