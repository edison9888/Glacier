//
//  MoreController.m
//  DirShanghai
//
//  Created by spring sky on 13-5-7.
//  Copyright (c) 2013年 spring sky. All rights reserved.
//

#import "MoreController.h"

#define SHARE_CONTENT @"Dir Shanghia:share to。。。"

@interface MoreController ()

@end

@implementation MoreController

@synthesize moreTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        moreLableArray = [NSArray arrayWithObjects:@"About Dir Shanghai",@"Software update",@"FAQs",@"Share with friends",@"Rate this app",@"Feedback",@"Settings/Sign In/Share In Weachat",@"For more apps", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"More";
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [moreLableArray count];
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
    cell.textLabel.text = [moreLableArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"more_item_%d.png",indexPath.row + 1]];
    return cell;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case 4:
        {
            if(buttonIndex == 0 )
            {
                NSLog(@"sms");
                [self sendSMSComposerSheet];
            }else if(buttonIndex == 1)
            {
                NSLog(@"email");
                [self sendMailComposerSheet];
            }
        }
            break;
    }
}

// Displays an SMS composition interface inside the application.
-(void)sendSMSComposerSheet
{
    MFMessageComposeViewController *messageCtrl = [[MFMessageComposeViewController alloc] init];
    messageCtrl.messageComposeDelegate = self;
    messageCtrl.body = @"share ....";
    [self presentModalViewController:messageCtrl animated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:^{}];
}

// Displays an email composition interface inside the application. Populates all the Mail fields.
-(void)sendMailComposerSheet
{
    MFMailComposeViewController *mailCtrl = [[MFMailComposeViewController alloc] init];
    mailCtrl.mailComposeDelegate = self;
    [mailCtrl setSubject:@"邮件标题"];

    [mailCtrl setMessageBody:@"邮件内容" isHTML:NO];
    [self presentModalViewController:mailCtrl animated:YES];
}


-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
     [controller dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
