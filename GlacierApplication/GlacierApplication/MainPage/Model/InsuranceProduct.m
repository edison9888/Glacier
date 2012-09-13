//
//  InsuranceProduct.m
//  GlacierApplication
//
//  Created by chang liang on 12-9-13.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "InsuranceProduct.h"

@implementation InsuranceProduct
@synthesize insuranceName;
- (void)dealloc
{
    self.insuranceName = nil;
    [super dealloc];
}
@end
