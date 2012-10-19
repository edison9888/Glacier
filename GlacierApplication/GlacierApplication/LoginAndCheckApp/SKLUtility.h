//
//  SKLUtility.h
//  SKLMAgent
//
//  Created by bqzhu on 12-9-20.
//  Copyright (c) 2012年 bqzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <unistd.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <string.h>

@interface SKLUtility : NSObject {
    
}

@property (nonatomic, retain) NSMutableDictionary *sharedCellList;
-(void)clearSharedCellList;

+ (SKLUtility *)sharedInstance;

+ (NSString *)getPathOfDocuments;

+ (NSString *)dataFilePath:(NSString*)fileName;


+ (NSString *)getDateTimeStr:(NSString *)format;

+ (NSString *)getIPAddress;

+ (NSString *)md5:(NSString *)str;


@end
