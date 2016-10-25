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
            _imageCache_.memoryCache = [[NSCache alloc] init];
        });
    }
    
    return _imageCache_;
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
