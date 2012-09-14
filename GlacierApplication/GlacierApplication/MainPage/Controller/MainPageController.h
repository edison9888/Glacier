//
//  MainPageController.h
//  GlacierApplication
//
//  Created by chang liang on 12-9-12.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "GlacierController.h"
#import <MessageUI/MessageUI.h>
#import "SKLSlider.h"

@interface MainPageController : GlacierController <MFMailComposeViewControllerDelegate, SKLSliderDelegate,UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) IBOutlet SKLSlider *slider;
@property (retain, nonatomic) IBOutlet UILabel *birDayLabel;
@property (retain, nonatomic) IBOutlet UILabel *yearsOldLabel;

@end
