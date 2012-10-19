//
//  SKLUtility.m
//  SKLMAgent
//
//  Created by bqzhu on 12-9-20.
//  Copyright (c) 2012年 bqzhu. All rights reserved.
//

#import "SKLUtility.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
//#import "ListItemCell.h"

static SKLUtility *_share = nil;

@implementation SKLUtility
@synthesize sharedCellList;

- (id)init
{
    if (self = [super init]) {
        sharedCellList = [[NSMutableDictionary alloc]init];
    }
    return self;
}

//- (void)dealloc
//{
//    [sharedCellList release], sharedCellList = nil;
//	[super dealloc];
//}

+ (SKLUtility *)sharedInstance{
    @synchronized(self)
    {
        if (!_share) {
            _share = [[SKLUtility alloc] init];
        }
        return _share;
    }
}

-(void)clearSharedCellList {
//    ListItemCell *cell;
//    for (id currentID in [sharedCellList allKeys]) {
//        cell = (ListItemCell *)[sharedCellList objectForKey:currentID];
//        if (![cell isDownloading]) {
//            [sharedCellList removeObjectForKey:currentID];
//            [cell release], cell = nil;
//        }
//    }
//    NSLog(@"[sharedCellList count] = %d",[sharedCellList count]);
}

+ (NSString *)getPathOfDocuments{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathOfDocuments = [paths lastObject];
//    NSLog(@"%@",pathOfDocuments);
    return pathOfDocuments;
}

+ (NSString *)dataFilePath:(NSString*)fileName {
    return [NSString stringWithFormat:@"%@/%@",[self getPathOfDocuments],fileName];
}

+ (NSString *)getDateTimeStr:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    NSString *str = [formatter stringFromDate:[NSDate date]];
//    [formatter release];
    return str;
}

+ (NSString *)getIPAddress{
    
     NSString *address = @"error";
    
//    NSError *error;
//    NSURL *ipURL = [NSURL URLWithString:@"http://automation.whatismyip.com/n09230945.asp"];
//    address = [NSString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
//    if (error) {
        struct ifaddrs *interfaces = NULL;
        struct ifaddrs *temp_addr = NULL;
        int success = 0;
        // retrieve the current interfaces - returns 0 on success
        success = getifaddrs(&interfaces);
        if (success == 0) {
            // Loop through linked list of interfaces
            temp_addr = interfaces;
            while(temp_addr != NULL) {
                if(temp_addr->ifa_addr->sa_family == AF_INET) {
                    // Check if interface is en0 which is the wifi connection on the iPhone
                    if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                        // Get NSString from C String
                        address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    }
                }
                temp_addr = temp_addr->ifa_next;
            }
        }
        // Free memory
        freeifaddrs(interfaces);

//    }

    NSLog(@"address = %@",address);
    return address;
}

+ (NSString *) md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    
    return [NSString stringWithFormat:
            
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            
            result[0], result[1], result[2], result[3],
            
            result[4], result[5], result[6], result[7],
            
            result[8], result[9], result[10], result[11],
            
            result[12], result[13], result[14], result[15]
            
            ];
    
}

@end
