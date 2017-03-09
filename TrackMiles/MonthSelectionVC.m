//
//  MonthSelectionVC.m
//  TrackMiles
//
//  Created by Jahangir on 6/14/16.
//  Copyright © 2016 Adrian Borcea. All rights reserved.
//

#import "MonthSelectionVC.h"

@interface MonthSelectionVC ()

@end

@implementation MonthSelectionVC{
    
    NSArray *monthsArry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _seelctedIndex=-1;
    monthsArry=@[@"January",
                 @"February",
                 @"March",
                 @"April",
                 @"May",
                 @"June",
                 @"July",
                 @"August",
                 @"September",
                 @"October",
                 @"November",
                 @"December"];
}

#pragma mark - Picker
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return monthsArry.count;
}
-(NSString*)
pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [monthsArry objectAtIndex:row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    _seelctedIndex=row;
    
}
- (IBAction)doneBtnPressed:(id)sender {
    
     _seelctedIndex=[_pickr selectedRowInComponent:0];
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
        
    }];
}
@end
