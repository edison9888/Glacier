//
//  GlacierController.m
//  GlacierFramework
//
//  Created by chang liang on 12-7-12.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "GlacierController.h"
#import "JSONKit.h"
#import "ASINetworkQueue.h"

@interface GlacierController ()
@end

@implementation GlacierController
@synthesize sharedApp;
- (SharedApp *)sharedApp
{
    return [SharedApp instance];
}

- (void)dealloc
{
    [self.sharedApp removeNetworkReceiver:self];
    [super dealloc];
}

-(void) doHttpRequest:(NSString *) requestUrl
{
    ASIHTTPRequest * wRequest = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:requestUrl]];
    [self doRawHttpRequest:wRequest];
    [wRequest release];
}

-(void) doHttpRequest:(NSString *) requestUrl tag:(int)tag
{
    ASIHTTPRequest * wRequest = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:requestUrl]];
    wRequest.tag = tag;
    [self doRawHttpRequest:wRequest];
    [wRequest release];
}

-(void) doHttpRequest:(NSString *) requestUrl userInfo:(NSDictionary *)info;
{
    ASIHTTPRequest * wRequest = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:requestUrl]];
    wRequest.userInfo = info;
    [self doRawHttpRequest:wRequest];
    [wRequest release];
}

-(void) doHttpRequest:(NSString *) requestUrl postData:(NSData *)data
{
    ASIHTTPRequest * wRequest = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:requestUrl]];
    [wRequest setPostLength:data.length];
    [wRequest setPostBody:[NSMutableData dataWithData:data]];
    [self doRawHttpRequest:wRequest];
    [wRequest release];
}

- (void)doHttpRequest:(NSString *)requestUrl postJSONData:(JSONObject *)json
{
    ASIHTTPRequest * wRequest = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:requestUrl]];
    NSData * wData = [json toJsonData];
    [wRequest setPostLength:wData.length];
    [wRequest setPostBody:[NSMutableData dataWithData:wData]];
    [self doRawHttpRequest:wRequest];
    [wRequest release];
}

-(void) doRawHttpRequest:(ASIHTTPRequest *) request
{
    request.delegate = self;
    [self.sharedApp doASIHttpRequest:request];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return  UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}
@end

