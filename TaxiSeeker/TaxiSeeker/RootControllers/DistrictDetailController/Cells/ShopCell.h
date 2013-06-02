//
//  ShopCell.h
//  DirShanghai
//
//  Created by spring sky on 13-5-11.
//  Copyright (c) 2013年 spring sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "FiveStarView.h"

@interface ShopCell : UITableViewCell
@property (strong,nonatomic) IBOutlet UILabel* shopNameLable;
@property (strong,nonatomic) IBOutlet EGOImageView* shopImageView;
@property (strong,nonatomic) IBOutlet UILabel* shopAddressLable;
@property (strong,nonatomic) IBOutlet UILabel* shopPriceLable;
@property (strong,nonatomic)IBOutlet UILabel* shopDistanceLable;
@property (strong,nonatomic)IBOutlet FiveStarView * shopRateView;
@end
