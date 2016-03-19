//
//  YKDownloadOperator.m
//  Yinner
//
//  Created by Maru on 16/3/17.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "YKDownloadOperator.h"
#import "NSURL+File.h"

@implementation YKDownloadOperator

- (void)downloadWithMatter:(YKMatterModel *)model successHandler:(SuccessHander)successHandler failureHandler:(FailHander)failurehandler {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request_srt = [NSURLRequest requestWithURL:[NSURL URLWithString:model.srt_url]];
    NSURLRequest *request_mp3 = [NSURLRequest requestWithURL:[NSURL URLWithString:model.audio_url]];
    NSURLRequest *request_mp4 = [NSURLRequest requestWithURL:[NSURL URLWithString:model.video_url]];
    
    __block BOOL srt_ok = NO;
    __block BOOL mp3_ok = NO;
    __block BOOL mp4_ok = NO;
    
    void (^result)();
    result = ^(){
        if (srt_ok && mp3_ok && mp4_ok) {
            successHandler(nil);
        }
    };
    
    NSURLSessionDownloadTask *downloadTask_0 = [manager downloadTaskWithRequest:request_srt progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *url = [NSURL urlWithMatter:model andType:YKMatterTypeSRT];
        return url;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        srt_ok = YES;
        result();
    }];
    
    NSURLSessionDownloadTask *downloadTask_1 = [manager downloadTaskWithRequest:request_mp3 progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *url = [NSURL urlWithMatter:model andType:YKMatterTypeMP3];
        return url;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        mp3_ok = YES;
        result();
    }];
    
    NSURLSessionDownloadTask *downloadTask_2 = [manager downloadTaskWithRequest:request_mp4 progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *url = [NSURL urlWithMatter:model andType:YKMatterTypeMP4];
        return url;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        mp4_ok = YES;
        result();
    }];

    [downloadTask_0 resume];
    [downloadTask_1 resume];
    [downloadTask_2 resume];
}

@end
