//
//  PopComboController.h
//  GlacierApplication
//
//  Created by chang liang on 12-9-21.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "GlacierController.h"
#import "vocationlevel.h"

@interface ComboModel : NSObject
@property (nonatomic,retain) vocationlevel * firstLevel;
@property (nonatomic,retain) vocationlevel * secondLevel;
@property (nonatomic,retain) vocationlevel * thirdLevel;
@property (nonatomic,assign) int firstSelected;
@property (nonatomic,assign) int secondSelected;
@property (nonatomic,assign) int thirdSelected;
@end

@protocol PopComboDelegate <NSObject>
@required
- (void) onComboOkClick:(ComboModel *) model;
- (void) onComboCancelClick;
@end



@interface PopComboController : GlacierController<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,retain) ComboModel * selectedModel;
@property (nonatomic,assign) id<PopComboDelegate> popComboDelegate;
@end
