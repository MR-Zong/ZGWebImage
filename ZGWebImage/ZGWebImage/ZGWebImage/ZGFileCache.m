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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initialize
{
    [self createFileCacheDirectory];
    [self listenNotification];
}

- (void)listenNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAppEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAppFinishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
}

- (void)createFileCacheDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileCacheDir = [NSString stringWithFormat:@"%@/%@", cacheDir,fileCacheDirectory];
    
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:fileCacheDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:fileCacheDir withIntermediateDirectories:YES attributes:nil error:nil];
    }else {
        NSLog(@"FileCacheDir is exists.");
    }
}

- (void)didAppEnterBackground:(NSNotification *)note
{
    [self deleteExpireFileCache];
}

- (void)didAppFinishLaunching:(NSNotification *)note
{
    [self deleteExpireFileCache];
}

- (void)deleteExpireFileCache
{
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileCacheDir = [NSString stringWithFormat:@"%@/%@", cacheDir,fileCacheDirectory];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray* tempArray = [fileManager contentsOfDirectoryAtPath:fileCacheDir error:nil];
    
    for (NSString* fileName in tempArray) {
        
        BOOL flag = YES;
        
        NSString* fullPath = [fileCacheDir stringByAppendingPathComponent:fileName];
        
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&flag]) {
            
            if (!flag) {
                if ([fileName isEqualToString:@".DS_Store"]) {
                    continue;
                }
                NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:fullPath error:nil];
                if (fileAttributes != nil) {

                    //文件大小
                     NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
                    if (fileSize) {
                        NSLog(@"File size: %qi\n", [fileSize unsignedLongLongValue]);
                    }
                    //文件创建日期
                    NSDate *creationDate = [fileAttributes objectForKey:NSFileCreationDate];
                    
                    if (creationDate) {
                        NSLog(@"File creationDate: %@\n", creationDate);
                        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                        
                        NSDateComponents *comp = [calendar components:NSCalendarUnitDay
                                                             fromDate:creationDate
                                                               toDate:[NSDate date]
                                                              options:NSCalendarWrapComponents];
                        if ( comp.day > 7 ) { // expire fileCache
                            [fileManager removeItemAtPath:fullPath error:nil];
                        }
                    }
                    
                    //文件所有者
                    NSString *fileOwner = [fileAttributes objectForKey:NSFileOwnerAccountName];
                    if (fileOwner) {
                        NSLog(@"Owner: %@\n", fileOwner);
                    }
                    //文件修改日期
                    NSDate *fileModDate = [fileAttributes objectForKey:NSFileModificationDate];
                    if (fileModDate) {
                        NSLog(@"Modification date: %@\n", fileModDate);
                    }
                }
                else {
                    NSLog(@"Path (%@) is invalid.", fullPath);
                }// end if (fileAttributes != nil)
                
            } //if (!flag)
            
        }
        
    }
    
}

- (void)clearFileCache
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileCacheDir = [NSString stringWithFormat:@"%@/%@", cacheDir,fileCacheDirectory];
    
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:fileCacheDir isDirectory:&isDir];
    if ( isDir == YES && existed == YES )
    {
        [fileManager removeItemAtPath:fileCacheDir error:nil];
        [self createFileCacheDirectory];
    }else {
        NSLog(@"FileCacheDir is not exists.");
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
