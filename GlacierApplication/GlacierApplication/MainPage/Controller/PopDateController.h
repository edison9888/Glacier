//
//  PopDateController.h
//  GlacierApplication
//
//  Created by chang liang on 12-9-20.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "GlacierController.h"

@protocol PopDateDelegate <NSObject>
@required
- (void) onOkClick:(NSDate *) date;
- (void) onCancelClick;
@end

@interface PopDateController : GlacierController
@property (retain, nonatomic) IBOutlet UIDatePicker *picker;
@property (nonatomic,assign)  id<PopDateDelegate> popDateDelegate;
@property (nonatomic,retain) NSDate * maxDate;
@property (nonatomic,retain) NSDate * minDate;
@end
