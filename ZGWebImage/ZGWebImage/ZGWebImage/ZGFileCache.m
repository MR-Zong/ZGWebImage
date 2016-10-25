//
//  ZGFileCache.m
//  ZGWebImage
//
//  Created by Zong on 16/10/25.
//  Copyright © 2016年 XuZonggen. All rights reserved.
//

#import "ZGFileCache.h"

NSString *const fileCacheDirectory = @"zgDefaults";

@implementation ZGFileCache

+ (instancetype)defaultFileCache
{
    static ZGFileCache *_fileCache_ = nil;
    if (!_fileCache_) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _fileCache_ = [[ZGFileCache alloc] init];
            [_fileCache_ initialize];
        });
    }
    
    return _fileCache_;
}

- (void)initialize
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *createDir = [NSString stringWithFormat:@"%@/%@", cacheDir,fileCacheDirectory];

    if (![[NSFileManager defaultManager] fileExistsAtPath:createDir]) {
        [fileManager createDirectoryAtPath:createDir withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"FileCacheDir is exists.");
    }
}

- (void)storeImage:(UIImage *)image forKey:(NSString *)key
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:fileCacheDirectory] stringByAppendingPathComponent:[key.description md5String]];
    [imageData writeToFile:filePath atomically:NO];
}

- (UIImage *)imageForKey:(NSString *)key
{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:fileCacheDirectory] stringByAppendingPathComponent:key.md5String];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];
    return image;
}

@end
