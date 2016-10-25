//
//  ZGWebImageDownloader.m
//  ZGWebImage
//
//  Created by Zong on 16/10/25.
//  Copyright © 2016年 XuZonggen. All rights reserved.
//

#import "ZGWebImageDownloader.h"
#import "ZGFileCache.h"

@implementation ZGWebImageDownloader

+ (instancetype)defaulteWebImageDownLoader
{
    static ZGWebImageDownloader *_webImageDownloader_ = nil;
    if (!_webImageDownloader_) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _webImageDownloader_ = [[ZGWebImageDownloader alloc] init];
        });
    }
    
    return _webImageDownloader_;
}

- (void)downLoaderImageWithUrl:(NSURL *)url completeBlock:(void (^)(UIImage *, NSError *))completeBlock
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        // location是沙盒中tmp文件夹下的一个临时url,文件下载后会存到这个位置,
        // 由于tmp中的文件随时可能被删除,所以我们需要自己需要把下载的文件挪到需要的地方
//        NSLog(@"response %@",response);
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:fileCacheDirectory] stringByAppendingPathComponent:[url.description md5String]];

        // 移动文件
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:filePath] error:nil];
        
        if (completeBlock) {
            completeBlock([[ZGFileCache defaultFileCache] imageForKey:url.description],error);
        }
    }];
    // 启动任务
    [task resume];
}


//// 每次写入调用(会调用多次)
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
//    // 可在这里通过已写入的长度和总长度算出下载进度
//    CGFloat progress = 1.0 * totalBytesWritten / totalBytesExpectedToWrite; NSLog(@"%f",progress);
//}
//
//// 下载完成调用
//- (void)URLSession:(NSURLSession *)session
//      downloadTask:(NSURLSessionDownloadTask *)downloadTask
//didFinishDownloadingToURL:(NSURL *)location {
//    // location还是一个临时路径,需要自己挪到需要的路径(caches下面)
//    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
//    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:filePath] error:nil];
//}
//
//// 任务完成调用
//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
//    
//}

@end
