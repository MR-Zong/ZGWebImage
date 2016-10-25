//
//  ZGImageCache.m
//  ZGWebImage
//
//  Created by Zong on 16/10/25.
//  Copyright © 2016年 XuZonggen. All rights reserved.
//

#import "ZGImageCache.h"


@interface ZGImageCache ()

@property (nonatomic, strong) NSCache *memoryCache;

@end

@implementation ZGImageCache

+ (instancetype)defaultImageCache
{
    static ZGImageCache *_imageCache_ = nil;
    if (!_imageCache_) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _imageCache_ = [[ZGImageCache alloc] init];
            [_imageCache_ initialize];
        });
    }
    
    return _imageCache_;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initialize
{
    _memoryCache = [[NSCache alloc] init];
    [self listenNotification];
}


- (void)listenNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

- (void)didReceiveMemoryWarning:(NSNotification *)note
{
    [_memoryCache removeAllObjects];
}

- (void)storeImage:(UIImage *)image forKey:(NSString *)key
{
    [self.memoryCache setObject:image forKey:key.md5String];
}

- (UIImage *)imageForKey:(NSString *)key
{
    return [self.memoryCache objectForKey:key.md5String];
}


@end
