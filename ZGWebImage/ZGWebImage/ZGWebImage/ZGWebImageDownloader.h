//
//  ZGWebImageDownloader.h
//  ZGWebImage
//
//  Created by Zong on 16/10/25.
//  Copyright © 2016年 XuZonggen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ZGWebImageDownloader : NSObject

+ (instancetype)defaulteWebImageDownLoader;

- (void)downLoaderImageWithUrl:(NSURL *)url completeBlock:(void (^)(UIImage *image,NSError *error))completeBlock;

@end
