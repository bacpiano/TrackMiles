//
//  AddJobVC.m
//  TrackMiles
//
//  Created by Jahangir on 6/4/16.
//  Copyright © 2016 Adrian Borcea. All rights reserved.
//

#import "AddJobVC.h"

@implementation AddJobVC

-(void)viewDidLoad{
    
    if (_job) {
        
        _txtField.text=_job.title;
        _btnAdd.enabled=YES;
        [_btnAdd setTitle:@"Save" forState:UIControlStateNormal];
    }
}

- (IBAction)addBtnPressed:(id)sender {
    
    
    AppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *theContext=[appdelegate managedObjectContext];
    
    if (_job) {
        
         _job.title=_txtField.text;
        
    }else{
        
        Job *job=[NSEntityDescription insertNewObjectForEntityForName:@"Job" inManagedObjectContext:theContext];
        job.created_at=[NSDate date];
        job.title=_txtField.text;

    }
    
    
    NSError *error;
    [theContext save:&error];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextField Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *newStr=[textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newStr.length>0) {
        _btnAdd.enabled=YES;
    }else{
        _btnAdd.enabled=NO;
    }
    
    return YES;
}
@end
