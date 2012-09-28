//
//  plipdtm.h
//  GlacierApplication
//
//  Created by chang liang on 12-9-14.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "SQLitePersistentObject.h"

@interface plipdtm : SQLitePersistentObject
@property (nonatomic,copy) NSString * pdpdtcode; 
@property (nonatomic,copy) NSString * pdpdtname; 
@property (nonatomic,assign) int  pkclass; 
@property (nonatomic,assign) int  pdkind;
@property (nonatomic,copy) NSString * pdrattabletype; 
@property (nonatomic,copy) NSString * pdunit; 
@property (nonatomic,assign) float pdself; 
@property (nonatomic,assign) float  pdcouple; 
@property (nonatomic,assign) float  pdchild; 
@property (nonatomic,assign) float  pdowner; 
@property (nonatomic,copy) NSString * pdfeetype; 
@property (nonatomic,copy) NSString * pdpremcategory; 
@property (nonatomic,assign) float  pdhighprem; 
@property (nonatomic,assign) float  pyfullyear; 
@property (nonatomic,assign) float  pdonepay; 
@property (nonatomic,copy) NSString * pdreport; 
@property (nonatomic,copy) NSString * pdinv; 
@property (nonatomic,copy) NSString * pdmainflag; 
@property (nonatomic,assign) float  pdmodelimit; 
@property (nonatomic,copy) NSString * pdpdtcont; 
@property (nonatomic,copy) NSString * pdpdtcont1; 
@property (nonatomic,assign) float  pdversionno; 
@property (nonatomic,copy) NSString * pdadddeny; 
@property (nonatomic,copy) NSString * pdcurrency; 
@property (nonatomic,copy) NSString * pdlbenf; 
@property (nonatomic,copy) NSString * pdmbenf; 
@property (nonatomic,copy) NSString * pddbenf; 
@property (nonatomic,copy) NSString * pdbbenf; 
@property (nonatomic,copy) NSString * modidate; 
@property (nonatomic,copy) NSString * modistate;
@end
