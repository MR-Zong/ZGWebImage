//
//  UIButton+ZGWebCache.m
//  ZGWebImage
//
//  Created by Zong on 16/10/25.
//  Copyright © 2016年 XuZonggen. All rights reserved.
//

#import "UIButton+ZGWebCache.h"
#import "ZGWebImageDownloader.h"
#import "ZGImageCache.h"
#import "ZGFileCache.h"

@implementation UIButton (ZGWebCache)

- (void)zg_setImageWithUrl:(NSURL *)url forState:(UIControlState)state completeBlock:(void (^)(UIImage *, NSError *))completeBlock
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
        [self setImage:tmpImage forState:state];
        
        if (completeBlock) {
            completeBlock(tmpImage,nil);
        }
        return;
    }
    
    // 文件缓存获取
    tmpImage = [[ZGFileCache defaultFileCache] imageForKey:url.description];
    if (tmpImage) {
        [self setImage:tmpImage forState:state];
        
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
                    [strongSelf setImage:image forState:state];
                    
                    // 内存缓存
                    [[ZGImageCache defaultImageCache] storeImage:image forKey:url.description];
                }
            }
        }
    }];
}

- (void)zg_setImageWithUrl:(NSURL *)url forState:(UIControlState)state
{
    [self zg_setImageWithUrl:url forState:state completeBlock:nil];
}

- (void)zg_setImageWithUrl:(NSURL *)url forState:(UIControlState)state placeholder:(UIImage *)placeholder
{
    if (placeholder) {
        [self setImage:placeholder forState:state];
    }
    [self zg_setImageWithUrl:url forState:state completeBlock:nil];
}

- (void)zg_setImageWithUrl:(NSURL *)url forState:(UIControlState)state placeholder:(UIImage *)placeholder completeBlock:(void (^)(UIImage *, NSError *))completeBlock
{
    if (placeholder) {
        [self setImage:placeholder forState:state];
    }
    [self zg_setImageWithUrl:url forState:state completeBlock:completeBlock];
}


@end
