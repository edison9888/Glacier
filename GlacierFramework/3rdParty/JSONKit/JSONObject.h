//
//  JsonObject.h
//  GlacierFramework
//
//  Created by cnzhao on 12-7-14.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "JSONKit.h"

@interface JSONObject : NSObject
- (NSString *) toJson;
- (NSData *) toJsonData;
- (void) parseJson:(NSString*)jsonString;
@end

@interface NSMutableArray (json)
-(void)parseJson:(NSString *)jsonString Elemclass:(NSString *) className;
@end