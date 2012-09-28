//
//  plipdtrate.h
//  GlacierApplication
//
//  Created by chang liang on 12-9-15.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "SQLitePersistentObject.h"

@interface plipdtrate : SQLitePersistentObject
@property (nonatomic,copy) NSString * prpdtcode; 
@property (nonatomic,assign) float prpdtyear; 
@property (nonatomic,assign) float prage; 
@property (nonatomic,assign) float prsales; 
@property (nonatomic,assign) float prmrate; 
@property (nonatomic,assign) float prfrate; 
@property (nonatomic,assign) float prmodeno;
@property (nonatomic,copy) NSString * modidate; 
@property (nonatomic,copy) NSString * modistate;
@end
