//
//  DoLogin.h
//  SKLMAgent
//
//  Created by bqzhu on 12-9-21.
//  Copyright (c) 2012年 bqzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKLUtility.h"
#import "ASIFormDataRequest.h"

#define LOGIN_NAME  @"Login"

@interface DoLogin : NSObject <ASIHTTPRequestDelegate>

@property (nonatomic, assign) id processdelegate;

@property (nonatomic, retain) NSString *account;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *imagecode;

- (id)initWithAccount:(NSString *)acc Password:(NSString *)pwd ImageCode:(NSString *)code;

- (void) request;

@end
