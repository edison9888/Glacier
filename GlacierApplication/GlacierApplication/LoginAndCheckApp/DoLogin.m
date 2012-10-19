//
//  DoLogin.m
//  SKLMAgent
//
//  Created by bqzhu on 12-9-21.
//  Copyright (c) 2012年 bqzhu. All rights reserved.
//

#import "DoLogin.h"

@implementation DoLogin {
    ASIFormDataRequest *_request;
}
@synthesize account,password,imagecode;
@synthesize processdelegate;
-(id) init
{
    return self;
};

//-(void) dealloc
//{
////    [account release], account = nil;
////    [password release], password = nil;
////    [imagecode release], imagecode = nil;
//    [_request release], _request = nil;
//	[super dealloc];
//}

- (id)initWithAccount:(NSString *)acc Password:(NSString *)pwd ImageCode:(NSString *)code {
    self.account = acc;
    self.password = pwd;
    self.imagecode = code;
    return self;
}

- (void) request{
    
    NSString *reqdate = [SKLUtility getDateTimeStr:@"yyyyMMdd"];
    NSString *reqtime = [SKLUtility getDateTimeStr:@"HHmmss"];
    
    NSString *IPAddress = [SKLUtility getIPAddress];
    
    NSString *org_tcode = [NSString stringWithFormat:@"iPad%@%@%@Shin Kong Life", @"ptms1001", reqdate, reqtime];
    NSString *tcode = [[SKLUtility md5:org_tcode] lowercaseString];
    
    NSString* postString = [NSString stringWithFormat:@"<r><svcType>iPad</svcType><svcToken>ptms1001</svcToken><reqip>%@</reqip><reqdate>%@</reqdate><reqtime>%@</reqtime><sid></sid><tcode>%@</tcode><datalist><l>%@,%@,%@</l></datalist></r>",IPAddress, reqdate, reqtime, tcode, account,password,imagecode];

    
//    NSString* requestUrl = [NSString stringWithFormat:@"%@%@", @"https://einsurance.skl.com.tw/PTMService/", @"svcportal.aspx"];
    
    NSURL *url = [NSURL URLWithString:LOGIN_URL];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    _request = [ASIFormDataRequest requestWithURL:url];
    NSMutableData *mNSMutableData = [[NSMutableData alloc]initWithData:postData];
    [_request setPostBody:mNSMutableData];
    
    [_request setDelegate:self];

    [_request startAsynchronous];

}

-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    //    NSLog(@"total size: %lld", request.contentLength);
}

-(void)requestStarted:(ASIHTTPRequest *)request{
    NSLog(@"requestStarted");
    [[self processdelegate] performSelector:@selector(requestStarted:) withObject:request];
}

-(void)requestFinished:(ASIHTTPRequest *)request{
    NSLog(@"requestFinished");
    NSLog(@"%@",[request responseString]);
    [[self processdelegate] performSelector:@selector(requestFinished:) withObject:[request responseString]];
}

-(void)requestFailed:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    NSLog(@"requestFailed, download failed, error: %@", error);

}

@end
