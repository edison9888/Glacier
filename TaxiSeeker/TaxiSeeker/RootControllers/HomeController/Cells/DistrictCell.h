//
//  DistrictCell.h
//  TaxiSeeker
//
//  Created by cnzhao on 13-6-1.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface DistrictCell : UITableViewCell
@property (strong, nonatomic) IBOutlet EGOImageView *imgBar;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@end
