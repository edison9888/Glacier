//
//  SharedApp.m
//  GlacierFramework
//
//  Created by chang liang on 12-7-15.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "SharedApp.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#define TIMEOUT_SECONDS 30
static ASINetworkQueue * _ASINetworkQueue;
#define FMDBFileName @"db.sqlite"

@implementation SharedApp
{
    SDKVersion mSDKVersion;
}

+ (SharedApp *) instance
{
    static SharedApp * _instance;
    if (!_instance) 
    {
        _instance = [[SharedApp alloc]init];
    }
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.appDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (SDKVersion)currentVersion
{
    if (!mSDKVersion.firstVersion) 
    {
        UIDevice * wDevice = [UIDevice currentDevice];
        NSArray * wArr = [wDevice.systemVersion componentsSeparatedByString:@"."];
        if ([wArr count] > 0) {
            mSDKVersion.firstVersion = ((NSString *)[wArr objectAtIndex:0]).intValue;
        }
        if ([wArr count] > 2) {
            mSDKVersion.secondVersion = ((NSString *)[wArr objectAtIndex:2]).intValue;
        }
        if ([wArr count] > 4) {
            mSDKVersion.thirdVersion = ((NSString *)[wArr objectAtIndex:4]).intValue;
        }
    }
    return mSDKVersion;
}

- (ASINetworkQueue *)httpQueue
{
    if (!_ASINetworkQueue)
    {
        _ASINetworkQueue = [[ASINetworkQueue alloc] init];
        [_ASINetworkQueue setMaxConcurrentOperationCount:4];
        [_ASINetworkQueue go];
    }
    return _ASINetworkQueue;
}

@end

@implementation SharedApp (http)


- (void)removeNetworkReceiver:(id)receiver
{
    NSArray * wArr = [_ASINetworkQueue.operations copy];
    for (ASIHTTPRequest * wReq in wArr) 
    {
        if (wReq.delegate == receiver) 
        {
            [wReq clearDelegatesAndCancel];
        }
    }
    [wArr release];
}

-(void) doASIHttpRequest:(ASIHTTPRequest *) request
{
    [request setTimeOutSeconds:TIMEOUT_SECONDS];
    [self.httpQueue addOperation:request];
}
@end

@implementation SharedApp(FMDatabase)
+ (FMDatabaseQueue *)FMDatabaseQueue
{
    static FMDatabaseQueue * _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instance)
        {
            NSArray* paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) ;
            _instance = [[FMDatabaseQueue alloc]initWithPath:[[paths objectAtIndex:0]stringByAppendingPathComponent:FMDBFileName]];
        }
    });
    return _instance;
}
@end


