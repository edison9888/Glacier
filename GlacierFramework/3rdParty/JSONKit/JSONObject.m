//
//  JsonObject.m
//  GlacierFramework
//
//  Created by chang liang on 12-7-14.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "JSONObject.h"
#import "JSONKit.h"
#if (! TARGET_OS_IPHONE)
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif

@interface JSONObject()
- (void) parseJsonDict:(NSDictionary *)dict;
@end

@implementation JSONObject
- (NSString *) toJson
{
    NSMutableDictionary * wDict = [[NSMutableDictionary alloc]init];
    
    unsigned int outCount;
    objc_property_t *propList = class_copyPropertyList([self class], &outCount);
    for (int i=0; i < outCount; i++)
	{
		objc_property_t oneProp = propList[i];
		NSString *propName = [NSString stringWithUTF8String:property_getName(oneProp)];
		NSString *attrs = [NSString stringWithUTF8String: property_getAttributes(oneProp)];
        
        if ([attrs rangeOfString:@"JSONObject"].location == NSNotFound)
        {
            [wDict setValue:[self valueForKey:propName] forKey:propName];
        }
        else 
        {
            [wDict setValue:[[self valueForKey:propName] toJson] forKey:propName];
        }
    }
    free(propList);
    NSString * wJson = [wDict JSONString];
    [wDict release];
    return wJson;
}

- (NSData *)toJsonData
{
    return [[self toJson] dataUsingEncoding:NSUTF8StringEncoding];
}

- (void) parseJsonDict:(NSDictionary *)dict
{
    unsigned int outCount;
    objc_property_t *propList = class_copyPropertyList([self class], &outCount);
    NSMutableDictionary * wPropDict = [[NSMutableDictionary alloc]init];
    
    for (int i=0; i < outCount; i++)
	{
        objc_property_t oneProp = propList[i];
		NSString *propName = [NSString stringWithUTF8String:property_getName(oneProp)];
        [wPropDict setValue:@"" forKey:propName];
    }
    
    for (NSString * wKey in [dict allKeys]) 
    {
        if ([wPropDict valueForKey:wKey]) 
        {
            [self setValue:[dict valueForKey:wKey] forKey:wKey];
        }
    }
    
    free(propList);
    [wPropDict release];

}

- (void) parseJson:(NSString*)jsonString
{
    [self parseJsonDict:[jsonString objectFromJSONString]];
}

@end

@implementation NSMutableArray (json)
-(void)parseJson:(NSString *)jsonString Elemclass:(NSString *) className
{
    NSMutableArray * wArr = [jsonString objectFromJSONString];
    
    for (NSDictionary * wDict in wArr) 
    {
        JSONObject * wObj = [[NSClassFromString(className) alloc] init];
        [wObj parseJsonDict:wDict];
        [self addObject:wObj];
        [wObj release];
    }
}
@end





