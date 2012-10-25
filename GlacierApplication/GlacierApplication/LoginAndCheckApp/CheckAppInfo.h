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

@interface CheckAppInfo : NSObject  <ASIHTTPRequestDelegate> 

//@property (nonatomic, assign) id checkAppInfoDelegate;

-(id) initWithCurrApp:(NSString*)curapp Version:(NSString*)ver;

- (void) request;

@end
