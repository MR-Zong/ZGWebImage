//
//  UIImage+ZGGif.h
//  ZGWebImage
//
//  Created by Zong on 16/10/26.
//  Copyright © 2016年 XuZonggen. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const ZGImageTypePNG;
UIKIT_EXTERN NSString *const ZGImageTypeJPEG;
UIKIT_EXTERN NSString *const ZGImageTypeGIF;
UIKIT_EXTERN NSString *const ZGImageTypeTIFF;

@interface UIImage (ZGGif)

+ (NSString *)typeForImageData:(NSData *)data;
- (NSArray *)framesWithUrl:(NSURL *)url;
- (NSArray *)framesWithData:(NSData *)data;

@property (nonatomic, copy) NSString *imageType;
@property (nonatomic, copy) NSArray *frames;

@end
