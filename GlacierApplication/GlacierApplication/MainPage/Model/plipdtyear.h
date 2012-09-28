//
//  plipdtyear.h
//  GlacierApplication
//
//  Created by chang liang on 12-9-15.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "SQLitePersistentObject.h"

@interface plipdtyear : SQLitePersistentObject

@property (nonatomic,copy) NSString * pdpdtcode; 
@property (nonatomic,assign) float pypdtyear;
@property (nonatomic,copy) NSString * pypdtyeartype; 
@property (nonatomic,copy) NSString * pypdtyearna; 
@property (nonatomic,copy) NSString * pyratecode; 
@property (nonatomic,copy) NSString * pyminamt; 
@property (nonatomic,copy) NSString * pymaxamt; 
@property (nonatomic,assign) float pyamtunit; 
@property (nonatomic,assign) float pyminage; 
@property (nonatomic,assign) float pymaxage; 
@property (nonatomic,assign) float pyinsureyear; 
@property (nonatomic,copy) NSString * pyinsureyeartype; 
@property (nonatomic,copy) NSString * pyinsureyearna; 
@property (nonatomic,copy) NSString * pywpcode; 
@property (nonatomic,copy) NSString * pywp; 
@property (nonatomic,copy) NSString * pyminprem; 
@property (nonatomic,assign) float pyfycitem; 
@property (nonatomic,copy) NSString * pyminageind; 
@property (nonatomic,copy) NSString * pymaxageind; 
@property (nonatomic,copy) NSString * modidate; 
@property (nonatomic,copy) NSString * modistate;
@end