//
//  AddTrackVC.m
//  TrackMiles
//
//  Created by Jahangir on 6/4/16.
//  Copyright © 2016 Adrian Borcea. All rights reserved.
//

#import "AddTrackVC.h"

@implementation AddTrackVC
-(void)viewDidLoad{
    
    NSInteger selection=[[NSUserDefaults standardUserDefaults] integerForKey:k_Unit_selection];
    if (selection==1) {
        
        _lblStartUnit.text=@"(km)";
        _lblEndUnit.text=@"(km)";
    }
    
    if (_track) {
        
        _btnSave.enabled=YES;
        [self popuateExistingData];
    }else{
        _pickerHeight.constant=0.0;
        _lblDate.hidden=YES;
        _dateHeight.constant=0.0;
    }
}

-(void)popuateExistingData{
    
     NSInteger selection=[[NSUserDefaults standardUserDefaults] integerForKey:k_Unit_selection];
    
    NSInteger endValue=[_track.end_value integerValue];
    NSInteger startValue=[_track.start_value integerValue];
    
    [_datePickr setDate:_track.created_at];
    
    if ([_track.isMiles boolValue] && selection==0) {
        
        _txtStart.text=[NSString stringWithFormat:@"%li",(long)startValue];
        _txtEnd.text=[NSString stringWithFormat:@"%li",(long)endValue];
        
    }else if ([_track.isMiles boolValue] && selection==1){
        
        _txtStart.text=[NSString stringWithFormat:@"%@",[Manager kilometersFromMiles:startValue]];
        _txtEnd.text=[NSString stringWithFormat:@"%@",[Manager kilometersFromMiles:endValue]];
        
    }else if (![_track.isMiles boolValue] && selection==0){
        
        _txtStart.text=[NSString stringWithFormat:@"%@",[Manager milesFromKilometer:startValue]];
        _txtEnd.text=[NSString stringWithFormat:@"%@",[Manager milesFromKilometer:endValue]];
        
    }else if (![_track.isMiles boolValue] && selection==1){
        
        _txtStart.text=[NSString stringWithFormat:@"%.li",(long)startValue];
        _txtEnd.text=[NSString stringWithFormat:@"%li",(long)endValue];
    }

    
}

- (IBAction)saveBtnPressed:(id)sender {
    
    if ([_txtEnd.text integerValue]<=[_txtStart.text integerValue] && [_txtEnd.text integerValue]!=0) {
        
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"End reading should be greater than start reading!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
        return;
    }
    
    AppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *theContext=[appdelegate managedObjectContext];
    NSInteger selection=[[NSUserDefaults standardUserDefaults] integerForKey:k_Unit_selection];
    
    NSInteger startValue = [_txtStart.text integerValue];
    NSInteger endValue;
    if (_txtEnd.text.length>0) {
        
        endValue = [_txtEnd.text integerValue];
    }else{
        endValue = 0;
    }
    
    if (_track) {
        
        _track.end_value=[NSNumber numberWithInteger:endValue];
        _track.start_value=[NSNumber numberWithInteger:startValue];
        _track.created_at=[_datePickr date];
        _track.job_title = _job.title;
        
        if (selection==0) {
            _track.isMiles=[NSNumber numberWithBool:YES];
        }else{
            _track.isMiles=[NSNumber numberWithBool:NO];
        }
        
        
    }else{
        
        Track *track=[NSEntityDescription insertNewObjectForEntityForName:@"Track" inManagedObjectContext:theContext];
        track.job_title = _job.title;
        track.created_at=[NSDate date];
        track.end_value=[NSNumber numberWithInteger:endValue];
        track.start_value=[NSNumber numberWithInteger:startValue];
        
        if (selection==0) {
            track.isMiles=[NSNumber numberWithBool:YES];
        }else{
            track.isMiles=[NSNumber numberWithBool:NO];
        }
        
        track.job_created_at=_job.created_at;
    }
    
    
    NSError *error;
    [theContext save:&error];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextfield Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *newStr=[textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField==_txtStart) {
        
        if (newStr.length>0) {
            
            _btnSave.enabled=YES;
        }else{
            _btnSave.enabled=NO;
        }
        
        
    }
    return YES;
}
@end
