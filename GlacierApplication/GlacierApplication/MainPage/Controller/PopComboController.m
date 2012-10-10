//
//  PopComboController.m
//  GlacierApplication
//
//  Created by chang liang on 12-9-21.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "PopComboController.h"
@implementation ComboModel
@synthesize firstLevel;
@synthesize secondLevel;
@synthesize thirdLevel;
@synthesize firstSelected;
@synthesize secondSelected;
@synthesize thirdSelected;

//- (void)dealloc
//{
//    self.firstLevel = nil;
//    self.secondLevel = nil;
//    self.thirdLevel = nil;
//    [super dealloc];
//}
@end


@interface PopComboController ()
@property (nonatomic,retain) NSArray * typeOneArr;
@property (nonatomic,retain) NSArray * typeTwoArr;
@property (nonatomic,retain) NSArray * typeThreeArr;
@end


@implementation PopComboController
{
    IBOutlet UIPickerView *onePicker;
    IBOutlet UIPickerView *twoPicker;
    IBOutlet UIPickerView *threePicker;
}

@synthesize typeOneArr = _typeOneArr;
@synthesize typeTwoArr = _typeTwoArr;
@synthesize typeThreeArr = _typeThreeArr;
@synthesize popComboDelegate;
@synthesize selectedModel;

//- (void)dealloc
//{
//    self.selectedModel = nil;
//    self.typeOneArr = nil;
//    self.typeTwoArr = nil;
//    self.typeThreeArr = nil;
//    [onePicker release];
//    [twoPicker release];
//    [threePicker release];
//    [super dealloc];
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.selectedModel) 
    {
        ComboModel * model = [[ComboModel alloc]init];
        self.selectedModel = model;
//        [model release];
    }
    [self initPicker];
}

//- (void)viewDidUnload
//{
//    [onePicker release];
//    onePicker = nil;
//    [twoPicker release];
//    twoPicker = nil;
//    [threePicker release];
//    threePicker = nil;
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}

- (void) initPicker
{
    self.typeOneArr = [VOCATIONLEVEL findByCriteria:@"where parent_code_id = ''"];
    
   
    
    self.typeTwoArr = [VOCATIONLEVEL findByCriteria:@"where parent_code_id = '%@'",((VOCATIONLEVEL *)[self.typeOneArr objectAtIndex:self.selectedModel.firstSelected]).CODE_ID];
    [twoPicker reloadAllComponents];
  
    
    self.typeThreeArr = [VOCATIONLEVEL findByCriteria:@"where parent_code_id = '%@'",((VOCATIONLEVEL *)[self.typeTwoArr objectAtIndex:self.selectedModel.secondSelected]).CODE_ID];
    [threePicker reloadAllComponents];
    
    [onePicker selectRow:self.selectedModel.firstSelected inComponent:0 animated:false];
    [twoPicker selectRow:self.selectedModel.secondSelected inComponent:0 animated:false];
    [threePicker selectRow:self.selectedModel.thirdSelected inComponent:0 animated:false];
    
    [self fillModel];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 0) 
    {
        return self.typeOneArr.count;
    }
    else if(pickerView.tag == 1) 
    {
        return self.typeTwoArr.count;
    }
    else if(pickerView.tag == 2) 
    {
        return self.typeThreeArr.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 0)
    {
        return ((VOCATIONLEVEL *)[self.typeOneArr objectAtIndex:row]).CODE_CNAME;
    }
    else if (pickerView.tag == 1)
    {
        return ((VOCATIONLEVEL *)[self.typeTwoArr objectAtIndex:row]).CODE_CNAME;
    }
    else if (pickerView.tag == 2)
    {
        return ((VOCATIONLEVEL *)[self.typeThreeArr objectAtIndex:row]).CODE_CNAME;
    }
    return nil;
}

-  (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 0)
    {
        self.selectedModel.firstSelected = row;
        
        if ([VOCATIONLEVEL countByCriteria:@"where parent_code_id = '%@'",((VOCATIONLEVEL *)[self.typeOneArr objectAtIndex:self.selectedModel.firstSelected]).CODE_ID] > 0)
        {
             self.typeTwoArr = [VOCATIONLEVEL findByCriteria:@"where parent_code_id = '%@'",((VOCATIONLEVEL *)[self.typeOneArr objectAtIndex:self.selectedModel.firstSelected]).CODE_ID];
        }
        else
        {
            self.typeTwoArr = [VOCATIONLEVEL emptyArr];
        }
        
        [twoPicker reloadAllComponents];
        [twoPicker selectRow:-1 inComponent:0 animated:false];
        [threePicker selectRow:-1 inComponent:0 animated:false];
        self.selectedModel.secondSelected = 0;
        self.selectedModel.thirdSelected = 0;
        
        if ([VOCATIONLEVEL countByCriteria:@"where parent_code_id = '%@'",((VOCATIONLEVEL *)[self.typeTwoArr objectAtIndex:self.selectedModel.secondSelected]).CODE_ID] > 0)
        {
            self.typeThreeArr = [VOCATIONLEVEL findByCriteria:@"where parent_code_id = '%@'",((VOCATIONLEVEL *)[self.typeTwoArr objectAtIndex:self.selectedModel.secondSelected]).CODE_ID];
        }
        else
        {
            self.typeThreeArr = [VOCATIONLEVEL emptyArr];
        }
        
        [threePicker reloadAllComponents];
        [threePicker selectRow:-1 inComponent:0 animated:false];
         self.selectedModel.thirdSelected = 0;
    }
    else if (pickerView.tag == 1)
    {
        self.selectedModel.secondSelected = row;
        
        if ([VOCATIONLEVEL countByCriteria:@"where parent_code_id = '%@'",((VOCATIONLEVEL *)[self.typeTwoArr objectAtIndex:self.selectedModel.secondSelected]).CODE_ID] > 0)
        {
            self.typeThreeArr = [VOCATIONLEVEL findByCriteria:@"where parent_code_id = '%@'",((VOCATIONLEVEL *)[self.typeTwoArr objectAtIndex:self.selectedModel.secondSelected]).CODE_ID];
        }
        else
        {
            self.typeThreeArr = [VOCATIONLEVEL emptyArr];
        }
        
        [threePicker reloadAllComponents];
        [threePicker selectRow:-1 inComponent:0 animated:false];
        self.selectedModel.thirdSelected = 0;
    }
    else if (pickerView.tag == 2)
    {
        self.selectedModel.thirdSelected = row;
    }
    [self fillModel];
}


-(void) fillModel
{  
    if(self.typeOneArr.count > 0)
    {
        self.selectedModel.firstLevel = ((VOCATIONLEVEL *)[self.typeOneArr objectAtIndex:self.selectedModel.firstSelected]);
    }
    else 
    {
        self.selectedModel.firstLevel = nil;
    }
    if(self.typeTwoArr >0)
    {
        self.selectedModel.secondLevel = ((VOCATIONLEVEL *)[self.typeTwoArr objectAtIndex:self.selectedModel.secondSelected]);
    }
    else
    {
         self.selectedModel.secondLevel = nil;
    }
    
    if (self.typeThreeArr.count > 0) 
    {
        self.selectedModel.thirdLevel = ((VOCATIONLEVEL *)[self.typeThreeArr objectAtIndex:self.selectedModel.thirdSelected]);
    }
    else 
    {
        self.selectedModel.thirdLevel = nil;
    }
    
}

- (IBAction)onOkClick:(id)sender 
{
    if (self.selectedModel.firstLevel && self.selectedModel.secondLevel && self.selectedModel.thirdLevel && self.selectedModel.thirdLevel.VALUE.intValue != -1 )
    {
        if (self.popComboDelegate && [self.popComboDelegate respondsToSelector:@selector(onComboOkClick:)])
        {
            [self.popComboDelegate onComboOkClick:self.selectedModel];
        }
    }
    else {
        UIAlertView * wAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"請選擇一個有效職業" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [wAlert show];
//        [wAlert release];
    }
}

- (IBAction)onCancelClick:(id)sender 
{
    if (self.popComboDelegate && [self.popComboDelegate respondsToSelector:@selector(onComboCancelClick)])
    {
        [self.popComboDelegate onComboCancelClick];
    }
}
@end
