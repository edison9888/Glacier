//
//  SearchCell.h
//  StockDoctor
//
//  Created by cnzhao on 13-4-9.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCell:UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UILabel *codeLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *selectImg;
@end