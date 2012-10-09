//
//  PLI_PDTRATE.m
//  GlacierApplication
//
//  Created by cnzhao on 12-9-29.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "PLI_PDTRATE.h"

@implementation PLI_PDTRATE
@synthesize  PR_PDTCODE;
@synthesize  PR_PDTYEAR;
@synthesize  PR_AGE;
@synthesize  PR_SALES;
@synthesize  PR_MRATE;
@synthesize  PR_FRATE;
@synthesize  PR_MODENO;
@synthesize  MODIDATE;
@synthesize  MODISTATE;

+ (bool)checkNeedPR_AGE:(NSString *)aPR_PDTCODE pdtYear:(float)aPR_PDTYEAR
{
    NSString * query = [NSString stringWithFormat:@"select count(1) from (select distinct PR_AGE from PLI_PDTRATE where PR_PDTCODE = '%@' and PR_PDTYEAR = %.1f)",aPR_PDTCODE,aPR_PDTYEAR];
    int count = [[SQLiteInstanceManager sharedManager] executeSelectIntSQL:query
     ];
    if (count > 1)
    {
        return true;
    }
    else
    {
        return false;
    }
}

+ (bool)checkNeedPR_SALES:(NSString *)aPR_PDTCODE pdtYear:(float)aPR_PDTYEAR
{
    int count = [[SQLiteInstanceManager sharedManager] executeSelectIntSQL:
                 [NSString stringWithFormat:@"select count(1) from (select distinct PR_SALES from PLI_PDTRATE where PR_PDTCODE = '%@' and PR_PDTYEAR = %.1f)",aPR_PDTCODE,aPR_PDTYEAR]];
    if (count > 1)
    {
        return true;
    }
    else
    {
        return false;
    }
}
@end
