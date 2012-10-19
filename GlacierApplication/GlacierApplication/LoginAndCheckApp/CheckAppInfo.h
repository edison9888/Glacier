//
//  CheckAppInfo.h
//  SKLMAgent
//
//  Created by bqzhu on 12-10-11.
//  Copyright (c) 2012年 bqzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKLUtility.h"
#import "ASIFormDataRequest.h"

//#define CHECKAPPINFO_URL  @"http://10.1.2.3/SKLInHouse/CheckAppInfo.aspx"
//#define CHECKAPPINFO_NAME  @"CheckAppInfo"

@interface CheckAppInfo : NSObject  <ASIHTTPRequestDelegate> 

@property (nonatomic, assign) id checkAppInfoDelegate;

- (void) request;

@end
