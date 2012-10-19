//
//  DownLoadDelegate.h
//  SKLMAgent
//
//  Created by bqzhu on 12-9-20.
//  Copyright (c) 2012年 bqzhu. All rights reserved.
//

@class ASIHTTPRequest;

@protocol DownLoadDelegate <NSObject>

@optional

- (void)requestStarted:(ASIHTTPRequest *)request;
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders;
- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;
@end
