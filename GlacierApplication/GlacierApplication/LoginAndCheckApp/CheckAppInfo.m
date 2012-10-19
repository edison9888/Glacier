//
//  CheckAppInfo.m
//  SKLMAgent
//
//  Created by bqzhu on 12-10-11.
//  Copyright (c) 2012年 bqzhu. All rights reserved.
//

#import "CheckAppInfo.h"

@implementation CheckAppInfo {
    ASIFormDataRequest *_request;
    NSString *returnMessage;
}
//@synthesize checkAppInfoDelegate;

-(id) init
{
    return self;
};

//-(void) dealloc
//{
//    [_request release], _request = nil;
//    [returnMessage release], returnMessage = nil;
//	[super dealloc];
//}

-(void)request {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    
    NSString *urlStr = [[NSString alloc]initWithFormat:@"http://10.1.2.3/SKLInHouse/CheckAppInfo.aspx?CurrApp=sklminsurancecal&CurrVer=%@",version];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    _request = [ASIFormDataRequest requestWithURL:url];
    
    //    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    
    //    [_request setPostValue:@"sklmmedia" forKey:@"CurrApp"];
    //    [_request setPostValue:version forKey:@"CurrVer"];
    
    [_request setDelegate:self];
    
    [_request startAsynchronous];
    
}

-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    //    NSLog(@"total size: %lld", request.contentLength);
}

-(void)requestStarted:(ASIHTTPRequest *)request{
    NSLog(@"requestStarted");
//    [[self checkAppInfoDelegate] performSelector:@selector(CheckAppInfoStarted:) withObject:self];
}

-(void)requestFinished:(ASIHTTPRequest *)request{
    NSLog(@"requestFinished");
    returnMessage = [[NSString alloc]initWithString:[request responseString]];
    NSLog(@"returnMessage = %@",returnMessage);
    
    
    if ([returnMessage isEqualToString:@"[無新版本]"]) {
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"有新版本程式需要更新！" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil];
        [alert show];
//        [alert release];
        
    }
    
//    [[self checkAppInfoDelegate] performSelector:@selector(CheckAppInfoFinished:) withObject:self];
}

-(void)requestFailed:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    NSLog(@"requestFailed, download failed, error: %@", error);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *subString = [returnMessage substringWithRange:NSMakeRange(1, returnMessage.length-2)];
    NSURL *urlAppStore = [NSURL URLWithString:subString];
    [[UIApplication sharedApplication] openURL:urlAppStore];
}

@end
