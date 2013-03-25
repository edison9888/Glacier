//
//  MGridView.m
//  GridViewProj
//
//  Created by cnzhao on 13-3-25.
//  Copyright (c) 2013年 cnzhao. All rights reserved.
//

#import "MGridView.h"
#import "ContentCell.h"

@interface MGridView()
@property (strong, nonatomic) IBOutlet UIScrollView *verScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *horScrollView;
@property (strong, nonatomic) IBOutlet UITableView *leftTable;
@property (strong, nonatomic) IBOutlet UITableView *rightTable;

@end

@implementation MGridView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    return self;
}

- (int)numForRow
{
    return ((NSMutableArray *)self.dataSource[0]).count;
}

- (int)numForColumn
{
    return self.dataSource.count;
}

- (float)pageWidth
{
    return 100;
}

- (void)reloadData
{
    self.verScrollView.contentSize = CGSizeMake(1, self.leftTable.rowHeight * [self numForRow] + self.leftTable.sectionHeaderHeight);
    self.horScrollView.contentSize = CGSizeMake(([self numForColumn] - 1) * [self pageWidth] + self.leftTable.bounds.size.width ,1);
    CGRect rightFrame = self.rightTable.frame;
    rightFrame.size.width = ([self numForColumn] - 1) * [self pageWidth];
    self.rightTable.frame = rightFrame;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numForRow];
}

- (UIView *)viewForColumn:(int)column
{
    UILabel * label = [[UILabel alloc]init];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake(0, 0, 100, 44);
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTable)
    {
        NSString * idStr = @"LeftGridCell";
        ContentCell * wCell = [tableView dequeueReusableCellWithIdentifier:idStr];
        if (!wCell)
        {
            wCell = [[ContentCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:idStr];
            wCell.subViewWith = [self pageWidth];
            wCell.frame = CGRectMake(0, 0, [self pageWidth], 44);
            
            [wCell addView:[self viewForColumn:0] viewIndex:0];
        }
        UILabel * label = [wCell findView:0];
        label.text = self.dataSource[0][indexPath.row];
        return wCell;
    }
    else if (tableView == self.rightTable)
    {
        NSString * idStr = @"RightGridCell";
        ContentCell * wCell = [tableView dequeueReusableCellWithIdentifier:idStr];
        if (!wCell)
        {
            wCell = [[ContentCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:idStr];
            wCell.subViewWith = [self pageWidth];
            wCell.frame = CGRectMake(0, 0, [self pageWidth] * ([self numForColumn] - 1), 44);
            
            for (int i = 0; i < [self numForColumn] - 1; i++)
            {
                [wCell addView:[self viewForColumn:i] viewIndex:i];
            }
        }
        
        [wCell.viewDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * key, UILabel * obj, BOOL *stop) {
            obj.text = self.dataSource[key.intValue + 1][indexPath.row];
        }];
        
        return wCell;

    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"header";
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.verScrollView)
    {
        CGRect rect = self.horScrollView.frame;
        rect.origin.y = scrollView.contentOffset.y;
        self.horScrollView.frame = rect;
        self.leftTable.contentOffset = self.rightTable.contentOffset = scrollView.contentOffset;
    }
    else if (scrollView == self.horScrollView)
    {
        CGRect leftRect = self.leftTable.frame;
        leftRect.origin.x = scrollView.contentOffset.x;
        self.leftTable.frame = leftRect;
    }
}
@end
