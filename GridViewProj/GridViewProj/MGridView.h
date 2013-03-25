//
//  MGridView.h
//  GridViewProj
//
//  Created by cnzhao on 13-3-25.
//  Copyright (c) 2013年 cnzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGridView : UIView<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain) NSArray * dataSource;
- (void)reloadData;
@end
