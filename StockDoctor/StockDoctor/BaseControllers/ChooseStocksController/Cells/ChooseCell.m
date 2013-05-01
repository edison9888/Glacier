//
//  ChooseCell.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-18.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "ChooseCell.h"

@implementation ChooseCell
{

    IBOutlet UIImageView *_selectionView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    _selectionView.highlighted = highlighted;
}

@end
