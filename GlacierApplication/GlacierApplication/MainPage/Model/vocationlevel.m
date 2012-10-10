//
//  VOCATIONLEVEL.m
//  GlacierApplication
//
//  Created by cnzhao on 12-9-29.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "VOCATIONLEVEL.h"

@implementation VOCATIONLEVEL
@synthesize  CODE_ID;
@synthesize  PARENT_CODE_ID;
@synthesize  CODE_CNAME;
@synthesize  VALUE;

+(NSArray *) emptyArr
{
    VOCATIONLEVEL * wModel = [[VOCATIONLEVEL alloc]init];
    wModel.CODE_ID =  @"-1";
    wModel.PARENT_CODE_ID = @"-1";
    wModel.CODE_CNAME = @"未找到相關紀錄";
    wModel.VALUE = @"-1";
    NSArray * wArr = [NSArray arrayWithObject:wModel];
    return wArr;
}

@end
