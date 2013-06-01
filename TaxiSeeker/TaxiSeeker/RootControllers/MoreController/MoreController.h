//
//  MoreController.h
//  DirShanghai
//
//  Created by spring sky on 13-5-7.
//  Copyright (c) 2013年 spring sky. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MoreController : GlacierController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
{
    NSArray* moreLableArray;
    NSArray* moreIconArray;
}

@property (strong,nonatomic) IBOutlet UITableView* moreTableView;

@end
