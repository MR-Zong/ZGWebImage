//
//  ZGImageCache.h
//  ZGWebImage
//
//  Created by Zong on 16/10/25.
//  Copyright © 2016年 XuZonggen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "NSString+ZGMd5.h"

@interface ZGImageCache : NSObject

+ (instancetype)defaultImageCache;

- (void)storeImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;

@end
