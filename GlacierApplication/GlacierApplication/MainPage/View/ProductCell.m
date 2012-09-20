//
//  ProductCell.m
//  GlacierApplication
//
//  Created by chang liang on 12-9-19.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "ProductCell.h"
@interface ProductCell()
@property (retain, nonatomic) IBOutlet UIImageView *bgImg;

@end
@implementation ProductCell
@synthesize bgImg;
@synthesize nameLabel;
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
        self.bgImg.highlighted = selected;
        self.nameLabel.highlighted = selected;
}

- (void)dealloc {
    [nameLabel release];
    [bgImg release];
    [super dealloc];
}
@end
