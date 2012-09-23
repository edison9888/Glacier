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
    self.typeOneArr = [vocationlevel findByCriteria:@"where parentcodeid = ''"];
    
   
    
    self.typeTwoArr = [vocationlevel findByCriteria:@"where parentcodeid = '%@'",((vocationlevel *)[self.typeOneArr objectAtIndex:self.selectedModel.firstSelected]).codeid];
    [twoPicker reloadAllComponents];
  
    
    self.typeThreeArr = [vocationlevel findByCriteria:@"where parentcodeid = '%@'",((vocationlevel *)[self.typeTwoArr objectAtIndex:self.selectedModel.secondSelected]).codeid];
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
        return ((vocationlevel *)[self.typeOneArr objectAtIndex:row]).codecname;
    }
    else if (pickerView.tag == 1)
    {
        return ((vocationlevel *)[self.typeTwoArr objectAtIndex:row]).codecname;
    }
    else if (pickerView.tag == 2)
    {
        return ((vocationlevel *)[self.typeThreeArr objectAtIndex:row]).codecname;
    }
    return nil;
}

-  (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 0)
    {
        self.selectedModel.firstSelected = row;
        
      
        
        self.typeTwoArr = [vocationlevel findByCriteria:@"where parentcodeid = '%@'",((vocationlevel *)[self.typeOneArr objectAtIndex:self.selectedModel.firstSelected]).codeid];
        [twoPicker reloadAllComponents];
    }
    else if (pickerView.tag == 1)
    {
        self.selectedModel.secondSelected = row;
        self.typeThreeArr = [vocationlevel findByCriteria:@"where parentcodeid = '%@'",((vocationlevel *)[self.typeTwoArr objectAtIndex:self.selectedModel.secondSelected]).codeid];
        [threePicker reloadAllComponents];
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
        self.selectedModel.firstLevel = ((vocationlevel *)[self.typeOneArr objectAtIndex:self.selectedModel.firstSelected]);
    }
    else 
    {
        self.selectedModel.firstLevel = nil;
    }
    if(self.typeTwoArr >0)
    {
        self.selectedModel.secondLevel = ((vocationlevel *)[self.typeTwoArr objectAtIndex:self.selectedModel.secondSelected]);
    }
    else
    {
         self.selectedModel.secondLevel = nil;
    }
    
    if (self.typeThreeArr.count > 0) 
    {
        self.selectedModel.thirdLevel = ((vocationlevel *)[self.typeThreeArr objectAtIndex:self.selectedModel.thirdSelected]);
    }
    else 
    {
        self.selectedModel.thirdLevel = nil;
    }
    
}

- (IBAction)onOkClick:(id)sender 
{
    if (self.selectedModel.firstLevel && self.selectedModel.secondLevel && self.selectedModel.thirdLevel ) 
    {
        if (self.popComboDelegate && [self.popComboDelegate respondsToSelector:@selector(onComboOkClick:)])
        {
            [self.popComboDelegate onComboOkClick:self.selectedModel];
        }
    }
    else {
        UIAlertView * wAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择一个职业" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
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
