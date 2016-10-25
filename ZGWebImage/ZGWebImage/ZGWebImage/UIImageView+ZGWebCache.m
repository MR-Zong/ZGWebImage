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

- (void)zg_setImageWithUrl:(NSURL *)url
{
    // 内存缓存获取
    UIImage *tmpImage = [[ZGImageCache defaultImageCache] imageForKey:url.description];
    if (tmpImage) {
        self.image = tmpImage;
        return;
    }
    
    // 文件缓存获取
    tmpImage = [[ZGFileCache defaultFileCache] imageForKey:url.description];
    if (tmpImage) {
        self.image = tmpImage;
        // 内存缓存
        [[ZGImageCache defaultImageCache] storeImage:tmpImage forKey:url.description];
        return;
    }
    
    // 下载
    __weak typeof(self) weakSelf = self;
    ZGWebImageDownloader *defaultWebImageDownLoader = [ZGWebImageDownloader defaulteWebImageDownLoader];
    [defaultWebImageDownLoader downLoaderImageWithUrl:url completeBlock:^(UIImage *image,NSError *error) {
        if (!error) {
            if (image) {
                typeof(weakSelf) strongSelf = weakSelf;
                if (strongSelf) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        // 下载成功设置图片
                        strongSelf.image = image;
                    });
                    // 内存缓存
                    [[ZGImageCache defaultImageCache] storeImage:image forKey:url.description];
                }
            }
        }
    }];
    
}

@end
