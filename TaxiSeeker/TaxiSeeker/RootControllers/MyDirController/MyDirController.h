//
//  MyDirController.h
//  DirShanghai
//
//  Created by spring sky on 13-5-7.
//  Copyright (c) 2013年 spring sky. All rights reserved.
//


@interface MyDirController : GlacierController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray* mydirLableArray;
    NSArray* mydirIconArray;
}

@property (strong,nonatomic) IBOutlet UITableView* tableView;

@end
