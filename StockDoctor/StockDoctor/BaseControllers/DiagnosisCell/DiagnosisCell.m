//
//  DiagnosisCell.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-10.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "DiagnosisCell.h"
@interface DiagnosisCell()
@property (strong, nonatomic) IBOutlet UIButton *imgButton;
@end

@implementation DiagnosisCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]) {
            obj.hidden= true;
        }
    }];
    
    if (editing)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (self.isEditing)
    {
        if (selected)
        {
            self.imgButton.selected = false;
        }
        else
        {
            self.imgButton.selected = true;
        }
    }
}

@end
