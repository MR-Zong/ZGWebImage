//
//  UIImage+ZGGif.m
//  ZGWebImage
//
//  Created by Zong on 16/10/26.
//  Copyright © 2016年 XuZonggen. All rights reserved.
//

#import "UIImage+ZGGif.h"
#import <objc/runtime.h>
#import <ImageIO/ImageIO.h>

static char * const kZGGifImageTypeKey = "kZGGifImageTypeKey";
static char * const kZGGifFramesKey = "kZGGifFramesKey";

NSString *const ZGImageTypePNG = @"image/png";
NSString *const ZGImageTypeJPEG = @"image/jpeg";
NSString *const ZGImageTypeGIF = @"image/gif";
NSString *const ZGImageTypeTIFF = @"image/tiff";

@implementation UIImage (ZGGif)

#pragma mark - accociated
- (NSString *)imageType
{
     return objc_getAssociatedObject(self, kZGGifImageTypeKey);
}

- (void)setImageType:(NSString *)imageType
{
    objc_setAssociatedObject(self, kZGGifImageTypeKey, imageType, OBJC_ASSOCIATION_RETAIN);
}

- (NSArray *)frames
{
    return objc_getAssociatedObject(self, kZGGifFramesKey);
}

- (void)setFrames:(NSArray *)frames
{
    objc_setAssociatedObject(self, kZGGifFramesKey, frames, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark -
// 这两个方法UIImageJPEGRepresentation，UIImagePNGRepresentation可以将UIImage转换成二进制的形式，
// 如果用前者产生的NSData是空，那么图片可能就是PNG格式，反之亦然。
// 如果你的图片本身就是2进制的NSData形式，那么可以判断第一个字节得出类型：
+ (NSString *)typeForImageData:(NSData *)data {
    
    
    uint8_t c;
    
    [data getBytes:&c length:1];
    
    switch (c) {
            
        case 0xFF:
            
            return @"image/jpeg";
            
        case 0x89:
            
            return @"image/png";
            
        case 0x47:
            
            return @"image/gif";
            
        case 0x49:
            
        case 0x4D:
            
            return @"image/tiff";
            
    }
    
    return nil;
    
}


//创建一个数组，数组中按顺序添加要播放的图片（图片为静态的图片）
- (NSArray *)framesWithUrl:(NSURL *)url
{
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)url, NULL);//将GIF图片转换成对应的图片源
    size_t frameCout=CGImageSourceGetCount(gifSource);//获取其中图片源个数，即由多少帧图片组成
    NSMutableArray* frames=[[NSMutableArray alloc] init];//定义数组存储拆分出来的图片
    for (size_t i=0; i<frameCout;i++){
        CGImageRef imageRef=CGImageSourceCreateImageAtIndex(gifSource, i, NULL);//从GIF图片中取出源图片
        UIImage* imageName=[UIImage imageWithCGImage:imageRef];//将图片源转换成UIimageView能使用的图片源
        [frames addObject:imageName];//将图片加入数组中
        CGImageRelease(imageRef);
    }
    return frames.copy;
}

- (NSArray *)framesWithData:(NSData *)data
{
    CGImageSourceRef gifSource = CGImageSourceCreateWithData((__bridge CFDataRef)data,NULL);
    size_t frameCout=CGImageSourceGetCount(gifSource);
    NSMutableArray* frames=[[NSMutableArray alloc] init];
    for (size_t i=0; i<frameCout;i++){
        CGImageRef imageRef=CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage* imageName=[UIImage imageWithCGImage:imageRef];
        [frames addObject:imageName];
        CGImageRelease(imageRef);
    }
    return frames.copy;
}


@end
