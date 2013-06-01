//
//  MyDirController.m
//  DirShanghai
//
//  Created by spring sky on 13-5-7.
//  Copyright (c) 2013年 spring sky. All rights reserved.
//

#import "MyDirController.h"

@interface MyDirController ()

@end

@implementation MyDirController

@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mydirLableArray = [NSArray arrayWithObjects:@"My Profile",@"My Assistant",@"My Saves",@"My Draft Revies",@"My Journal",@"My Coupon", nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"My Dir";
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mydirLableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"moreIdentifier";
    UITableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        [cell.textLabel setTextColor:[UIColor blackColor]];
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    cell.textLabel.text = [mydirLableArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"mydir_item_%d.png",indexPath.row + 1]];
    return cell;
}

/**
 选中事件
 */
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


@end
