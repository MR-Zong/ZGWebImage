//
//  UIImageView+ZGWebCache.h
//  ZGWebImage
//
//  Created by Zong on 16/10/25.
//  Copyright © 2016年 XuZonggen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ZGWebCache)

- (void)zg_setImageWithUrl:(NSURL *)url;
- (void)zg_setImageWithUrl:(NSURL *)url completeBlock:(void (^)(UIImage *image,NSError *error))completeBlock;
- (void)zg_setImageWithUrl:(NSURL *)url placeholder:(UIImage *)placeholder;
- (void)zg_setImageWithUrl:(NSURL *)url placeholder:(UIImage *)placeholder completeBlock:(void (^)(UIImage *image,NSError *error))completeBlock;

@end
