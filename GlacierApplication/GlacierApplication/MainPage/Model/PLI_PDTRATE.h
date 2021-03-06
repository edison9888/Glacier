//
//  PLI_PDTRATE.h
//  GlacierApplication
//
//  Created by cnzhao on 12-9-29.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "SQLitePersistentObject.h"

@interface PLI_PDTRATE : SQLitePersistentObject
@property (nonatomic,copy) NSString * PR_PDTCODE;
@property (nonatomic,assign) double PR_PDTYEAR;
@property (nonatomic,assign) double PR_AGE;
@property (nonatomic,assign) double PR_SALES;
@property (nonatomic,assign) double PR_MRATE;
@property (nonatomic,assign) double PR_FRATE;
@property (nonatomic,assign) double PR_MODENO;
@property (nonatomic,copy) NSString * MODIDATE;
@property (nonatomic,copy) NSString * MODISTATE;
+ (bool) checkNeedPR_AGE:(NSString *) aPR_PDTCODE pdtYear:(double) aPR_PDTYEAR;
+ (bool) checkNeedPR_SALES:(NSString *) aPR_PDTCODE pdtYear:(double) aPR_PDTYEAR;
@end
