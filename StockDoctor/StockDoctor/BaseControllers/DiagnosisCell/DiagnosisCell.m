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
@property (strong, nonatomic) IBOutlet UIImageView *changeImgView;
@property (strong, nonatomic) IBOutlet UIView *imgBgView;
@end

@implementation DiagnosisCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setChangeState:(int)state
{
    if (state < 0)
    {
        self.changeImgView.image = [UIImage imageNamed:@"greenbg"];
    }
    else if (state == 0)
    {
        self.changeImgView.image = [UIImage imageNamed:@"graybg"];
    }
    if (state > 0)
    {
        self.changeImgView.image = [UIImage imageNamed:@"redbg"];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if (self.isEditing != editing)
    {
        if (!editing)
        {
            self.imgBgView.alpha = 0;
            [UIView animateWithDuration:0.2f animations:^{
                self.imgBgView.alpha = 1;
            }];
            
        }
        else
        {
            self.imgBgView.alpha = 1;
            [UIView animateWithDuration:0.2f animations:^{
                self.imgBgView.alpha = 0;
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
            self.selectionStyle = UITableViewCellSelectionStyleGray;
        }
    }
    else
    {
        [super setEditing:editing animated:animated];
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
