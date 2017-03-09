//
//  TracksVC.m
//  TrackMiles
//
//  Created by Jahangir on 6/4/16.
//  Copyright © 2016 Adrian Borcea. All rights reserved.
//

#import "TracksVC.h"
#import "AddTrackVC.h"

@implementation TracksVC{
    
    NSMutableArray *tracksArry;
    
}

-(void)viewDidLoad{
    
     self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    self.title=_job.title;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self getAllTracksForJob];
}
-(void)getAllTracksForJob{
    
    AppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *theContext=[appdelegate managedObjectContext];
    NSError *error;
    NSFetchRequest *fReq=[[NSFetchRequest alloc] initWithEntityName:@"Track"];
    [fReq setPredicate:[NSPredicate predicateWithFormat:@"job_created_at == %@",_job.created_at]];
    NSSortDescriptor *sortDecp=[[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
    [fReq setSortDescriptors:@[sortDecp]];
    
    NSArray *results=[theContext executeFetchRequest:fReq error:&error];
    [self sortArchiveResults:results];
    [_tblView reloadData];
    
    [self totalDistaceForJob];
}

-(void)sortArchiveResults:(NSArray*)results{
    
    tracksArry=[[NSMutableArray alloc] init];
    
    NSInteger timeSel=[[NSUserDefaults standardUserDefaults] integerForKey:k_Time_selection];
    if (timeSel==0) {
        
        NSDate *today = [NSDate date];
        NSCalendar *gregorian = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [gregorian components:(NSMonthCalendarUnit) fromDate:today];
        NSInteger currMonth=[dateComponents month];
        NSInteger currYear=[dateComponents year];
        
        for (Track *tk in results) {
            
            dateComponents = [gregorian components:(NSMonthCalendarUnit) fromDate:tk.created_at];
            NSInteger createdMonth=dateComponents.month;
            NSInteger createdYear=dateComponents.year;
            
            if (currMonth==createdMonth && createdYear==currYear) {
                
                [tracksArry addObject:tk];
            }
        }
        
    }else{
        
        NSInteger monthSel=[[NSUserDefaults standardUserDefaults] integerForKey:k_Month_Index]+1;
        NSDate *today = [NSDate date];
        NSCalendar *gregorian = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [gregorian components:(NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        
        dateComponents.month=monthSel;
        
        NSDate *startDate=[gregorian dateFromComponents:dateComponents];
        dateComponents.year=dateComponents.year+1;
        
        NSDate *endDate=[gregorian dateFromComponents:dateComponents];
        
        for (Track *tk in results) {
            
            dateComponents = [gregorian components:(NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:tk.created_at];
            
        
            NSTimeInterval startDateInterval = [tk.created_at timeIntervalSinceDate:startDate];
            
            int startIntervalDays = startDateInterval / 86400;
            
            NSTimeInterval endDateInterval = [tk.created_at timeIntervalSinceDate:endDate];
            
            int endIntervalDays = endDateInterval / 86400;
            
            if (startIntervalDays>0 && endIntervalDays<=0) {
                
                 [tracksArry addObject:tk];
                
            }

            
//            if (monthSel>currMonth && currYear==createdYear) {
//                
//                    [tracksArry addObject:tk];
//                
//            }else if (monthSel<currMonth && currYear==createdYear+1) {
//                
//                    [tracksArry addObject:tk];
//                
//            }else if ((currYear==createdYear) || (currYear==createdYear+1)) {
//                
//                
//                    [tracksArry addObject:tk];
//                
//            }
        }

    }
}

#pragma mark - TableView

- (NSArray *)rightButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1 green:0.216 blue:0.216 alpha:1.0] title:@"Delete"];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0 green:0.494 blue:0.973 alpha:1.0] title:@"Edit"];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:178.0/255.0 green:172.0/255.0 blue:19.0/255.0 alpha:1.0] title:@"Share"];
    
    return leftUtilityButtons;
}

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
     NSIndexPath *indexPath=[_tblView indexPathForCell:cell];
    switch (index) {
            
        case 0:
            NSLog(@"Delete");
            [self deleteTrackAtIndex:indexPath];
            break;
            
        case 1:
            NSLog(@"Edit");
            [self editTrack:[tracksArry objectAtIndex:indexPath.row]];
            
            break;
        case 2:
            NSLog(@"Share");
            [self shareTrackAtIndex:indexPath];
            break;
            
            
        default:
            break;
    }
}

-(void)editTrack:(Track*)trak{
    
    AddTrackVC *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"AddTrackVC"];
    vc.job=_job;
    vc.track=trak;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)shareTrackAtIndex:(NSIndexPath*)indexPath{
    
    NSArray *itemsToShare = @[[self titleForTrack:[tracksArry objectAtIndex:indexPath.row]]];
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

-(void)deleteTrackAtIndex:(NSIndexPath*)indexPath{
    
    AppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *theContext=[appdelegate managedObjectContext];
    NSError *error;
    Job *job=[tracksArry objectAtIndex:indexPath.row];
    [theContext deleteObject:job];
    
    [theContext save:&error];
    
    [tracksArry removeObject:job];
    [_tblView reloadData];
    
    [self totalDistaceForJob];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return tracksArry.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SWTableViewCell *cell=[_tblView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.delegate=self;
    cell.rightUtilityButtons=[self rightButtons];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    UILabel *lblTitle=[cell viewWithTag:10];
    lblTitle.text=[self titleForTrack:[tracksArry objectAtIndex:indexPath.row]];
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [[UIView alloc] initWithFrame:CGRectZero];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Track *tk=[tracksArry objectAtIndex:indexPath.row];
    if ([tk.end_value integerValue]>0) {
        
        NSString *stringToShow=[NSString stringWithFormat:@"Mileage: %li-%li",[tk.start_value integerValue],[tk.end_value integerValue]];
        
        [[[UIAlertView alloc] initWithTitle:@"Info" message:stringToShow delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
    }
    
}
-(NSString*)titleForTrack:(Track*)track{
    
    if ([track.end_value integerValue ]==0) {
        
        return [NSString stringWithFormat:@"In progress on %@",[Manager standerdFormateStringForDate:track.created_at]];
    }
    
    NSMutableString *retStr=[[NSMutableString alloc] init];
    
    NSInteger selection=[[NSUserDefaults standardUserDefaults] integerForKey:k_Unit_selection];
    
    NSInteger distance=[track.end_value integerValue]-[track.start_value integerValue];
    
    if ([track.isMiles boolValue] && selection==0) {
        
        [retStr appendString:[NSString stringWithFormat:@"%li Miles  on  ",(long)distance]];

    }else if ([track.isMiles boolValue] && selection==1){
        
        [retStr appendString:[NSString stringWithFormat:@"%@ KM  on  ",[Manager kilometersFromMiles:distance]]];
        
    }else if (![track.isMiles boolValue] && selection==0){
        
        [retStr appendString:[NSString stringWithFormat:@"%@ Miles  on  ",[Manager milesFromKilometer:distance]]];
        
    }else if (![track.isMiles boolValue] && selection==1){
        
         [retStr appendString:[NSString stringWithFormat:@"%li KM  on  ",(long)distance]];
    }
    
    [retStr appendString:[Manager standerdFormateStringForDate:track.created_at]];
    return retStr;
}

-(void)totalDistaceForJob{
    
     NSInteger selection=[[NSUserDefaults standardUserDefaults] integerForKey:k_Unit_selection];
    
    NSInteger totalDistance=0;
    
    for (Track *track in tracksArry) {
        
        NSInteger distance=[track.end_value integerValue]-[track.start_value integerValue];
        
        if ([track.end_value integerValue] > 0) {
            
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
    
    if (selection==0) {
        _lblTotal.text=[NSString stringWithFormat:@"Total:  %li Miles",(long)totalDistance];
    }else{
        _lblTotal.text=[NSString stringWithFormat:@"Total:  %li KM",(long)totalDistance];
    }
}

- (IBAction)addBtnPRessed:(id)sender {
    
    [self performSegueWithIdentifier:@"add" sender:self];
}

- (IBAction)shareAllBtnPressed:(id)sender {
    
    NSMutableString *shareStr=[[NSMutableString alloc] initWithString:@""];
    for (Track *tk in tracksArry) {
        
        [shareStr appendString:[NSString stringWithFormat:@"\n%@",[self titleForTrack:tk]]];
    }
    
    NSArray *itemsToShare = @[shareStr];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"add"]) {
        
        AddTrackVC *vc=[segue destinationViewController];
        vc.job=_job;
    }
}
@end
