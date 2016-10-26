//
//  UIButton+ZGWebCache.h
//  ZGWebImage
//
//  Created by Zong on 16/10/25.
//  Copyright © 2016年 XuZonggen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ZGWebCache)

- (void)zg_setImageWithUrl:(NSURL *)url forState:(UIControlState)state;
- (void)zg_setImageWithUrl:(NSURL *)url forState:(UIControlState)state completeBlock:(void (^)(UIImage *image,NSError *error))completeBlock;
- (void)zg_setImageWithUrl:(NSURL *)url forState:(UIControlState)state placeholder:(UIImage *)placeholder;
- (void)zg_setImageWithUrl:(NSURL *)url forState:(UIControlState)state placeholder:(UIImage *)placeholder completeBlock:(void (^)(UIImage *image,NSError *error))completeBlock;

@end
