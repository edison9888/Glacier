//
//  vocationlevel.m
//  GlacierApplication
//
//  Created by chang liang on 12-9-21.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "vocationlevel.h"

@implementation vocationlevel
@synthesize codeid = _codeid;
@synthesize codecname = _codecname;
@synthesize parentcodeid = _parentcodeid;
@synthesize value = _value;

- (void)dealloc
{
    self.codeid = nil;
    self.codecname = nil;
    self.parentcodeid = nil;
    self.value = nil;
    [super dealloc];
}
@end
