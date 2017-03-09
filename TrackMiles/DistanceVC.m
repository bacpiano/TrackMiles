//
//  DistanceVC.m
//  TrackMiles
//
//  Created by Jahangir on 6/4/16.
//  Copyright © 2016 Adrian Borcea. All rights reserved.
//

#import "DistanceVC.h"

@implementation DistanceVC{
    
    NSMutableArray *dataArry;
    NSInteger currSelection;
    NSDate *currDate;
}

-(void)viewDidLoad{
    
    currDate=[NSDate date];
    
     self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    self.title=@"Distance";
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self getAllJobsData];
    [self totaldistanceTracks];
}

-(void)getAllJobsData{
    
    AppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *theContext=[appdelegate managedObjectContext];
    NSError *error;
    NSFetchRequest *fReq=[[NSFetchRequest alloc] initWithEntityName:@"Job"];
    NSSortDescriptor *sortDecp=[[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
    [fReq setSortDescriptors:@[sortDecp]];
    
    dataArry=[Manager sortArchiveResults:[theContext executeFetchRequest:fReq error:&error]];
    [_tblView reloadData];
    

}

#pragma mark - TableView Delegate
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [[UIView alloc] initWithFrame:CGRectZero];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataArry.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SWTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.delegate=self;
    cell.rightUtilityButtons=[self leftButtons];
    UILabel *lblTitle=[cell viewWithTag:10];
    lblTitle.text=[self getTotalForJob:[dataArry objectAtIndex:indexPath.row]];
    return cell;
}

-(NSArray*)leftButtons{
    
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:178.0/255.0 green:172.0/255.0 blue:19.0/255.0 alpha:1.0] title:@"Share"];
    
    return leftUtilityButtons;
}

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    
    NSIndexPath *indexPath=[_tblView indexPathForCell:cell];
    switch (index) {
            
        case 0:
            NSLog(@"Share");
            [self shareTrackAtIndex:indexPath];
            break;
            
        default:
            break;
    }
    
    
}


-(NSString *)getTotalForJob:(Job*)job{
    
    AppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *theContext=[appdelegate managedObjectContext];
    NSError *error;
    NSFetchRequest *fReq=[[NSFetchRequest alloc] initWithEntityName:@"Track"];
    [fReq setPredicate:[NSPredicate predicateWithFormat:@"job_created_at == %@ && end_value > %@",job.created_at,@(0)]];
    NSArray *resultArry=[theContext executeFetchRequest:fReq error:&error];
    resultArry = [Manager sortArchiveResults:resultArry];
    NSInteger selection=[[NSUserDefaults standardUserDefaults] integerForKey:k_Unit_selection];
    
    NSInteger totalDistance=0;
    
    for (Track *track in resultArry) {
        
        NSInteger distance=[track.end_value integerValue]-[track.start_value integerValue];
        
        if ([track.isMiles boolValue] && selection==0) {
            
            totalDistance=totalDistance+distance;
            
        }else if ([track.isMiles boolValue] && selection==1){
            
            totalDistance=totalDistance+[[Manager kilometersFromMiles:distance] integerValue];
            
        }else if (![track.isMiles boolValue] && selection==0){
            
            totalDistance=totalDistance+[[Manager milesFromKilometer:distance] integerValue];
            
            
        }else if (![track.isMiles boolValue] && selection==1){
            
            totalDistance=totalDistance+distance;
        }
    }
    
    NSString *retValue;
    if (selection==0) {
        retValue=[NSString stringWithFormat:@"%li Miles for %@",(long)totalDistance,job.title];
    }else{
        retValue=[NSString stringWithFormat:@"%li KM for %@",(long)totalDistance,job.title];
    }

    return retValue;
    
}

-(void)totaldistanceTracks{
    
    AppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *theContext=[appdelegate managedObjectContext];
    NSError *error;
    NSFetchRequest *fReq=[[NSFetchRequest alloc] initWithEntityName:@"Track"];
    NSArray *resultArry=[theContext executeFetchRequest:fReq error:&error];
    
    NSArray *sortedArry = [Manager sortArchiveResults:resultArry];
    
    NSInteger selection=[[NSUserDefaults standardUserDefaults] integerForKey:k_Unit_selection];
    
    NSInteger totalDistance=0;
    
    for (Track *track in sortedArry) {
        
        if ([track.end_value integerValue]>0) {
            
            NSInteger distance=[track.end_value integerValue]-[track.start_value integerValue];
            
            if ([track.isMiles boolValue] && selection==0) {
                
                totalDistance=totalDistance+distance;
                
            }else if ([track.isMiles boolValue] && selection==1){
                
                totalDistance=totalDistance+[[Manager kilometersFromMiles:distance] integerValue];
                
            }else if (![track.isMiles boolValue] && selection==0){
                
                totalDistance=totalDistance+[[Manager milesFromKilometer:distance] integerValue];
                
                
            }else if (![track.isMiles boolValue] && selection==1){
                
                totalDistance=totalDistance+distance;
            }

            
        }
        
    }
    
    NSString *retValue;
    if (selection==0) {
        retValue=[NSString stringWithFormat:@"Total distance: %li Miles",(long)totalDistance];
    }else{
        retValue=[NSString stringWithFormat:@"Total distance: %li KM",(long)totalDistance];
    }
    
    _lblTotalDistance.text=retValue;

}

-(void)shareTrackAtIndex:(NSIndexPath*)indexPath{
    
    NSArray *itemsToShare = @[[self getTotalForJob:[dataArry objectAtIndex:indexPath.row]]];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        CGRect rectInTableView = CGRectMake(0, 0, 0, 0);
        //        CGRect rectInSuperview = [self.tblView convertRect:rectInTableView toView:[self.tblView superview]];
        NSLog(@"%f",rectInTableView.origin.y);
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityVC];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, rectInTableView.origin.y+120, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else{
        
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    
}

@end
