//
//  ProductSectionView.h
//  GlacierApplication
//
//  Created by chang liang on 12-9-19.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SectionClickDelegate <NSObject>

@required
- (void) onSectionClcikDelegate:(NSInteger)section;
@end

@interface ProductSectionView : UIView
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic,assign) id<SectionClickDelegate> delegate;
@end
