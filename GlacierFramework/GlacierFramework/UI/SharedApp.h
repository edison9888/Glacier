//
//  SharedApp.h
//  GlacierFramework
//
//  Created by chang liang on 12-7-15.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//
#import "ASINetworkQueue.h"
struct SDKVersion 
{
    int firstVersion;
    int secondVersion;
    int thirdVersion;
};
typedef struct SDKVersion SDKVersion;


@interface SharedApp : NSObject
+ (SharedApp *) instance;
@property (nonatomic,readonly) SDKVersion currentVersion;
@property (nonatomic,readonly) ASINetworkQueue * networkQueue;
@end

@interface SharedApp(http)
- (void) removeNetworkReceiver:(id)receiver;
-(void) doASIHttpRequest:(ASIHTTPRequest *) request;
@end
