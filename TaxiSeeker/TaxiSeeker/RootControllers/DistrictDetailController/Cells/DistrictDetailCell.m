//
//  NearByCell.m
//  TaxiSeeker
//
//  Created by cnzhao on 13-6-1.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "DistrictDetailCell.h"

@implementation DistrictDetailCell
{

    IBOutlet UIImageView *_bgImg;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    self.titleLabel.highlighted = highlighted;
    if (highlighted)
    {
        _imgBar.alpha = _bgImg.alpha = 0.2;
    }
    else
    {
       _imgBar.alpha = _bgImg.alpha = 1;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	
	if(!newSuperview) {
		[_imgBar cancelImageLoad];
	}
}

@end
