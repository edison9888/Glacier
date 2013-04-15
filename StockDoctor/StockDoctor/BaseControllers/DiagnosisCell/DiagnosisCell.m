//
//  DiagnosisCell.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-10.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "DiagnosisCell.h"

@implementation DiagnosisCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if (!editing)
    {
        self.changLabel.alpha = 0;
        [UIView animateWithDuration:0.2f animations:^{
            self.changLabel.alpha = 1;
        }];
    }
    else
    {
        self.changLabel.alpha = 1;
        [UIView animateWithDuration:0.2f animations:^{
            self.changLabel.alpha = 0;
        }];
    }
    [super setEditing:editing animated:animated];
}
@end
