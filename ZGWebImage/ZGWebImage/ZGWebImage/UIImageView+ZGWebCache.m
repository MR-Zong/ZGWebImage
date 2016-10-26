//
//  UIImageView+ZGWebCache.m
//  ZGWebImage
//
//  Created by Zong on 16/10/25.
//  Copyright © 2016年 XuZonggen. All rights reserved.
//

#import "UIImageView+ZGWebCache.h"
#import "ZGWebImageDownloader.h"
#import "ZGImageCache.h"
#import "ZGFileCache.h"

@implementation UIImageView (ZGWebCache)

- (void)zg_setImageWithUrl:(NSURL *)url completeBlock:(void (^)(UIImage *image,NSError *error))completeBlock
{
    if (url.description.length <= 0) {
        
        if (completeBlock) {
            completeBlock(nil,nil);
        }
        return;
    }
    
    // 内存缓存获取
    UIImage *tmpImage = [[ZGImageCache defaultImageCache] imageForKey:url.description];
    if (tmpImage) {
        self.image = tmpImage;
        
        if (completeBlock) {
            completeBlock(tmpImage,nil);
        }
        return;
    }
    
    // 文件缓存获取
    tmpImage = [[ZGFileCache defaultFileCache] imageForKey:url.description];
    if (tmpImage) {
        self.image = tmpImage;
        
        if (completeBlock) {
            completeBlock(tmpImage,nil);
        }
        // 内存缓存
        [[ZGImageCache defaultImageCache] storeImage:tmpImage forKey:url.description];
        return;
    }
    
    // 下载
    __weak typeof(self) weakSelf = self;
    ZGWebImageDownloader *defaultWebImageDownLoader = [ZGWebImageDownloader defaulteWebImageDownLoader];
    [defaultWebImageDownLoader downLoaderImageWithUrl:url completeBlock:^(UIImage *image,NSError *error) {
        
        if (completeBlock) {
            completeBlock(image,error);
        }
        if (!error) {
            if (image) {
                typeof(weakSelf) strongSelf = weakSelf;
                if (strongSelf) {
                    
                    // 下载成功设置图片
                    strongSelf.image = image;
                    
                    // 内存缓存
                    [[ZGImageCache defaultImageCache] storeImage:image forKey:url.description];
                }
            }
        }
    }];
}


- (void)zg_setImageWithUrl:(NSURL *)url
{
    [self zg_setImageWithUrl:url completeBlock:nil];
}


- (void)zg_setImageWithUrl:(NSURL *)url placeholder:(UIImage *)placeholder
{
    if (placeholder) {
        self.image = placeholder;
    }
    [self zg_setImageWithUrl:url completeBlock:nil];
}

- (void)zg_setImageWithUrl:(NSURL *)url placeholder:(UIImage *)placeholder completeBlock:(void (^)(UIImage *image,NSError *error))completeBlock
{
    if (placeholder) {
        self.image = placeholder;
    }
    [self zg_setImageWithUrl:url completeBlock:completeBlock];
}

@end
