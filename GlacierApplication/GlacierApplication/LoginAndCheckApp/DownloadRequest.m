//
//  DownloadRequest.m
//  SKLMAgent
//
//  Created by bqzhu on 12-10-9.
//  Copyright (c) 2012年 bqzhu. All rights reserved.
//

#import "DownloadRequest.h"

@implementation DownloadRequest {
    
}
@synthesize _request;
@synthesize _symbol;
@synthesize _url;
@synthesize _name;
@synthesize _fileType;
@synthesize _savePath;
@synthesize _progress;
@synthesize _downLoadDelegate;

-(id)initWithURL:(NSString*)url Name:(NSString*)name FileType:(NSString*)fileType SavePath:(NSString*)savePath Progress:(UIView*)progress DownloadDelegate:(id)delegate{
    if (self = [super init]) {
        _url = url;
        _name = name;
        _fileType = fileType;
        _savePath = savePath;
        _progress = progress;
        _downLoadDelegate = delegate;
        _symbol = [NSString stringWithFormat:@"%@.%@",_name,_fileType];
        
        NSURL *url = [NSURL URLWithString:_url];
        _request = [ASIHTTPRequest requestWithURL:url];
        _request.delegate = self;
        _request.temporaryFileDownloadPath = [self cachesPath];
        _request.downloadDestinationPath = [self actualSavePath];
        _request.downloadProgressDelegate = _progress;
        _request.allowResumeForFileDownloads = YES;
        _request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:_symbol, @"SYMBOL", nil];
    }
    return self;
}

- (void) start {
    [_request start];
}

-(NSString *)actualSavePath{
    return [_savePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", _name, _fileType]];
}

-(NSString *)cachesPath{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", _name, _fileType]];
    return path;
}

-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    NSLog(@"total size: %lld", request.contentLength);

    [_downLoadDelegate request:request didReceiveResponseHeaders:responseHeaders];
}
-(void)requestStarted:(ASIHTTPRequest *)request{
    NSLog(@"download requestStarted");
    
    [_downLoadDelegate requestStarted:request];
}
-(void)requestFinished:(ASIHTTPRequest *)request {
    NSLog(@"download requestFinished");
    [_downLoadDelegate requestFinished:request];
}
-(void)requestFailed:(ASIHTTPRequest *)request{
//    NSError *error = [request error];
//    NSLog(@"download failed, error: %@", error);
    
    [_downLoadDelegate requestFailed:request];
}

- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL {
    NSLog(@"willRedirectToURL");
}

//- (void) dealloc{
//    [super dealloc];
//}

@end
