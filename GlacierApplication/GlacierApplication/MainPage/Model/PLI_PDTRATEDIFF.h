//
//  PLI_PDTRATEDIFF.h
//  GlacierApplication
//
//  Created by cnzhao on 12-9-29.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "SQLitePersistentObject.h"

@interface PLI_PDTRATEDIFF : SQLitePersistentObject
@property (nonatomic,copy) NSString * PR_PDTCODE;
@property (nonatomic,assign) float PR_PDTYEAR;
@property (nonatomic,copy) NSString * PR_SEX;
@property (nonatomic,assign) float PR_AGE;
@property (nonatomic,assign) float PR_SALES;
@property (nonatomic,assign) float PR_RATE6;
@property (nonatomic,assign) float PR_RATE3;
@property (nonatomic,assign) float PR_RATE1;
@property (nonatomic,copy) NSString * MODIDATE;
@property (nonatomic,copy) NSString * MODISTATE;
@end
