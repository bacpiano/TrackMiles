//
//  SettingsVC.m
//  TrackMiles
//
//  Created by Jahangir on 6/5/16.
//  Copyright © 2016 Adrian Borcea. All rights reserved.
//

#import "SettingsVC.h"
#import "MonthSelectionVC.h"

@interface SettingsVC ()

@end

@implementation SettingsVC{
    
    NSArray *unitsArry;
    NSArray *timeArry;
    NSArray *sectionArry;
    NSUserDefaults *defaults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    defaults=[NSUserDefaults standardUserDefaults];
    sectionArry=@[@"Units",@"Duration"];
    unitsArry=@[@"Miles",@"Kilometers"];
    timeArry=@[@"A month",@"A Year"];
}
#pragma mark - TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return sectionArry.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return unitsArry.count;
    }else{
        return timeArry.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *lblTitle=[cell viewWithTag:10];
    
    if (indexPath.section==0) {
        
        lblTitle.text=[unitsArry objectAtIndex:indexPath.row];
        NSInteger selection=[defaults integerForKey:k_Unit_selection];
        
        if (selection==indexPath.row) {
            
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        
    }else{
        
        lblTitle.text=[timeArry objectAtIndex:indexPath.row];
        NSInteger selection=[defaults integerForKey:k_Time_selection];
        if (selection==indexPath.row) {
            
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        
    }
    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [[UIView alloc] initWithFrame:CGRectZero];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_tblView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0) {
        [defaults setInteger:indexPath.row forKey:k_Unit_selection];
    }else{
        
        if (indexPath.row==0) {
            [defaults setInteger:indexPath.row forKey:k_Time_selection];
        }else{
            [defaults setInteger:1 forKey:k_Time_selection];
            [defaults setInteger:0 forKey:k_Month_Index];
//            [self openViewForMonthSelection];
        }
        
    }
    
    
    [defaults synchronize];
    
    [_tblView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40.0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    headerView.backgroundColor=[UIColor lightGrayColor];
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 40)];
    lbl.textColor=[UIColor darkGrayColor];
    lbl.text=[self tableView:_tblView titleForHeaderInSection:section];
    [headerView addSubview:lbl];
    return headerView;
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [sectionArry objectAtIndex:section];
}
-(void)openViewForMonthSelection{
    
    MonthSelectionVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MonthSelectionVC"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    formSheet.presentedFormSheetSize = CGSizeMake(250, 250);
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    
    [[MZFormSheetController sharedBackgroundWindow] setBackgroundBlurEffect:YES];
    [[MZFormSheetController sharedBackgroundWindow] setBlurRadius:3.5];
    [[MZFormSheetController sharedBackgroundWindow] setBackgroundColor:[UIColor clearColor]];
    
    formSheet.transitionStyle = MZFormSheetTransitionStyleBounce;
    
    formSheet.willDismissCompletionHandler=^(UIViewController *presentedControll){
        
        NSLog(@"backkkkk");
        MonthSelectionVC *vc=(MonthSelectionVC*)presentedControll;
        if (vc.seelctedIndex>-1) {
            
            [defaults setInteger:1 forKey:k_Time_selection];
            [defaults setInteger:vc.seelctedIndex forKey:k_Month_Index];
            [defaults synchronize];
            
            [_tblView reloadData];
        }
        
    };
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
        NSLog(@"goingggggg");
        
    }];
    

}
@end
