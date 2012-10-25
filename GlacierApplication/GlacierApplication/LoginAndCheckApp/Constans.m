//
//  Constans.m
//  SKLMAgent
//
//  Created by bqzhu on 12-10-24.
//  Copyright (c) 2012年 bqzhu. All rights reserved.
//

#import "Constans.h"

#ifdef TEST
//NSString * const BASE_ADDRESS = @"http://test-sklweb.skl.com.tw/sklpad/MAgent/WebService/MAgentWebService.asmx";
//NSString * const CHECK_APP_ADDRESS = @"http://10.1.2.3/SKLInHouse/CheckAppInfo.aspx";
//NSString * const INTRANET_TRANSIT_ADDRESS = @"http://10.1.2.3/PTMService/IntranetTransit.aspx";
//NSString * const SFA_ADDRESS = @"http://10.11.50.33/sfa/login/loginAdapter.aspx";
#else
NSString * const BASE_ADDRESS = @"https://einsurance.skl.com.tw/MAgent/WebService/MAgentWebService.asmx";
NSString * const CHECK_APP_ADDRESS = @"http://www.skl.com.tw/intranet/SKLInHouse/CheckAppInfo.aspx";
NSString * const INTRANET_TRANSIT_ADDRESS = @"https://einsurance.skl.com.tw/PTMService/IntranetTransit.aspx";
NSString * const SFA_ADDRESS = @"https://agent01.skl.com.tw/sfa/login/loginAdapter.aspx";
NSString * const LOGIN_ADDRESS = @"https://einsurance.skl.com.tw/PTMService/svcportal.aspx";
#endif



@implementation Constans {

}

-(id) init
{
    if (self = [super init]) {
    }
    return self;
};

@end
