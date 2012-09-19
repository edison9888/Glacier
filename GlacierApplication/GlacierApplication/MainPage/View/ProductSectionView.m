//
//  ProductSectionView.m
//  GlacierApplication
//
//  Created by chang liang on 12-9-19.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "ProductSectionView.h"

@implementation ProductSectionView
@synthesize nameLabel;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}


- (void)dealloc {
    [nameLabel release];
    [super dealloc];
}
@end
