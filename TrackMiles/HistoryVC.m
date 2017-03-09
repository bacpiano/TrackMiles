//
//  HistoryVC.m
//  TrackMiles
//
//  Created by Adrian Borcea Saeed on 22/06/2016.
//  Copyright © 2016 Adrian Borcea. All rights reserved.
//

#import "HistoryVC.h"

@interface HistoryVC ()

@end

@implementation HistoryVC{
    
    NSMutableArray *sectionArray;
    NSMutableArray *tracksArray;
    NSInteger currSelection;
    NSDate *currDate;
    
    NSArray *results;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    currDate=[NSDate date];
    [self getAllData];
}

-(void)getAllData{
    
    AppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *theContext=[appdelegate managedObjectContext];
    NSError *error;
    NSFetchRequest *fReq=[[NSFetchRequest alloc] initWithEntityName:@"Track"];
    NSSortDescriptor *sortDecp=[[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
    [fReq setSortDescriptors:@[sortDecp]];
    
    results=[theContext executeFetchRequest:fReq error:&error];
    [self getResultsForDate];
    
}

-(void)totaldistanceTracks{
    
    NSInteger selection=[[NSUserDefaults standardUserDefaults] integerForKey:k_Unit_selection];
    
    NSInteger totalDistance=0;
    
    for (Track *track in tracksArray) {
        
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
    
    _lblTotal.text=retValue;
    
}


-(void)getResultsForDate{
    
    tracksArray=[[NSMutableArray alloc] init];
    
    NSInteger timeSel=[[NSUserDefaults standardUserDefaults] integerForKey:k_Time_selection];
    if (timeSel==0) {
        
        
        if (_btnLeft.selected) {
            
            
            NSCalendar *cal         = [NSCalendar currentCalendar];
            NSDateComponents *comps = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                             fromDate:currDate];
            comps.month -= 1;
            currDate = [cal dateFromComponents:comps];
            
        }else if (_btnRight.selected){
            
            NSCalendar *cal= [NSCalendar currentCalendar];
            NSDateComponents *comps = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                             fromDate:currDate];
            comps.month += 1;
            currDate = [cal dateFromComponents:comps];
        }
        
        NSCalendar *gregorian = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [gregorian components:(NSMonthCalendarUnit) fromDate:currDate];
        NSInteger currMonth=[dateComponents month];
        
        for (Track *tk in results) {
            
            dateComponents = [gregorian components:(NSMonthCalendarUnit) fromDate:tk.created_at];
            NSInteger createdMonth=dateComponents.month;
            
            if (currMonth==createdMonth) {
                
                [tracksArray addObject:tk];
            }
        }
        
        NSDateFormatter *df=[[NSDateFormatter alloc] init];
        [df setDateFormat:@"MMMM"];
        _lblDuration.text=[df stringFromDate:currDate];
        
    }else{
        
        NSInteger monthSel=[[NSUserDefaults standardUserDefaults] integerForKey:k_Month_Index]+1;
        
        
        if (_btnLeft.selected) {
            
            
            NSCalendar *cal         = [NSCalendar currentCalendar];
            NSDateComponents *comps = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                             fromDate:currDate];
            comps.year -= 1;
            currDate = [cal dateFromComponents:comps];
            
        }else if (_btnRight.selected){
            
            NSCalendar *cal= [NSCalendar currentCalendar];
            NSDateComponents *comps = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                             fromDate:currDate];
            comps.year += 1;
            currDate = [cal dateFromComponents:comps];
        }
        
        NSDate *today = currDate;
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
                
                [tracksArray addObject:tk];
                
            }
            

        }
        
        NSDateFormatter *df=[[NSDateFormatter alloc] init];
        [df setDateFormat:@"YYYY"];
        _lblDuration.text=[df stringFromDate:currDate];
        
    }
    
    sectionArray =[[NSMutableArray alloc] init];
    
    for (Track *tk in tracksArray) {
        
        if ([sectionArray indexOfObject:tk.job_title] == NSNotFound) {
            
            [sectionArray addObject:tk.job_title];
        }
    }
    
    [self totaldistanceTracks];
    [_tblView reloadData];
}



- (IBAction)leftBtnPressed:(id)sender {
    
    _btnLeft.selected=YES;
    _btnRight.selected=NO;
    currSelection--;
    [self getResultsForDate];
}

- (IBAction)rightBtnPressed:(id)sender {
    
    _btnLeft.selected=NO;
    _btnRight.selected=YES;
    currSelection++;
    [self getResultsForDate];
}

#pragma mark - TableView
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [[UIView alloc] initWithFrame:CGRectZero];
}
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    
//    return sectionArray.count;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return sectionArray.count;
    
//    NSString *jobtitle=[sectionArray objectAtIndex:section];
//    return [self getTracksForJobTitle:jobtitle].count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     SWTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.delegate=self;
    cell.rightUtilityButtons=[self rightButtons];
    
    UILabel *lblTitle=[cell viewWithTag:10];
    
    NSString *jobtitle=[sectionArray objectAtIndex:indexPath.row];
    
    NSArray *rowsForSection = [self getTracksForJobTitle:jobtitle];
    
    lblTitle.text=[self getTotalForJob:jobtitle andTrack:rowsForSection];
    
    return cell;
}

- (NSArray *)rightButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1 green:0.216 blue:0.216 alpha:1.0] title:@"Delete"];
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
            NSLog(@"Share");
            [self shareTrackAtIndex:indexPath];
            break;
            
            
        default:
            break;
    }
}


//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    
//    return [sectionArray objectAtIndex:section];
//}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    float width=[UIScreen mainScreen].bounds.size.width;
//    UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
//    headerView.backgroundColor =_btnShare.tintColor;
//    UILabel *lblHeader=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, width-20, 20)];
//    lblHeader.font=[UIFont boldSystemFontOfSize:15.0];
//    lblHeader.textColor=[UIColor lightGrayColor];
//    lblHeader.text=[self tableView:_tblView titleForHeaderInSection:section];
//    [headerView addSubview:lblHeader];
//    
//    return headerView;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//    return 30;
//}

-(NSMutableArray *)getTracksForJobTitle:(NSString *)str{
    
    NSMutableArray *resultsArry=[[NSMutableArray alloc] init];
    for (Track *tk in tracksArray) {
        
        if ([tk.job_title isEqualToString:str]) {
            
            [resultsArry addObject:tk];
        }
    }
    return resultsArry;
}

-(NSString *)getTotalForJob:(NSString*)jobTitle andTrack:(NSArray*)trackArry{
    
    NSString *retStr;
    
    NSInteger distance=0;
    NSInteger selection=[[NSUserDefaults standardUserDefaults] integerForKey:k_Unit_selection];
    
    for (Track *tk in trackArry) {
        
        if ([tk.end_value integerValue ]>0) {
            
            if ([tk.isMiles boolValue] && selection==0) {
                
                distance=distance+([tk.end_value integerValue]-[tk.start_value integerValue]);
                
            }else if ([tk.isMiles boolValue] && selection==1){
                
                distance=distance+[[Manager kilometersFromMiles:([tk.end_value integerValue]-[tk.start_value integerValue])] integerValue];
                
                
            }else if (![tk.isMiles boolValue] && selection==0){
                
                distance=distance+[[Manager milesFromKilometer:([tk.end_value integerValue]-[tk.start_value integerValue])] integerValue];
                
                
            }else if (![tk.isMiles boolValue] && selection==1){
                
               distance=distance+([tk.end_value integerValue]-[tk.start_value integerValue]);
            }

            
        }
       
    }
    
    if (selection==0) {
        
        retStr=[NSString stringWithFormat:@"%@: %li Miles",jobTitle,(long)distance];
    }else{
        
         retStr=[NSString stringWithFormat:@"%@: %li KM",jobTitle,(long)distance];
    }
    
    return retStr;
    
}



- (IBAction)trashBtnPressed:(id)sender {
    
    if (tracksArray.count>0) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"All the history of jobs will be removed." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
        alert.tag=10;
        [alert show];
    }
}

- (IBAction)shareBtnPressed:(id)sender {
    
    if (tracksArray.count>0) {
        
        NSMutableString *shareStr=[[NSMutableString alloc] initWithString:@""];
        
        for (NSString *jobtitle in sectionArray) {
            
            NSArray *rowsForSection = [self getTracksForJobTitle:jobtitle];
            
            [shareStr appendString:[NSString stringWithFormat:@"\n%@",[self getTotalForJob:jobtitle andTrack:rowsForSection]]];
        }
        
       
        NSArray *itemsToShare = @[shareStr];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            CGRect rectInTableView = CGRectMake(0, 0, 0, 0);
        
            NSLog(@"%f",rectInTableView.origin.y);
            UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityVC];
            [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, rectInTableView.origin.y+120, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else{
            
            [self presentViewController:activityVC animated:YES completion:nil];
        }

    }
}
#pragma mark - AlertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==10 && buttonIndex == 1) {
        
        [self deleteAllData];

    }
    
}
-(void)deleteAllData{
    
    AppDelegate *appdelaget=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *theContext=[appdelaget managedObjectContext];
    for (Track *tk in tracksArray) {
        
        [theContext deleteObject:tk];
    }
    
    NSError *error;
    [theContext save:&error];
    [sectionArray removeAllObjects];
    [tracksArray removeAllObjects];
    [_tblView reloadData];
}

-(void)deleteTrackAtIndex:(NSIndexPath*)indexPath{
    
    AppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *theContext=[appdelegate managedObjectContext];
    NSError *error;
    
    NSString *jobTitle=[sectionArray objectAtIndex:indexPath.row];
    NSArray *rowsArry=[self getTracksForJobTitle:jobTitle];
    
    Track *track=[rowsArry objectAtIndex:indexPath.row];
    [theContext deleteObject:track];
    [theContext save:&error];
    
    [self getAllData];
    
}

-(void)shareTrackAtIndex:(NSIndexPath*)indexPath{
    
    NSString *jobTitle=[sectionArray objectAtIndex:indexPath.row];
    
    NSArray *rowsForSection = [self getTracksForJobTitle:jobTitle];
    
    NSArray *itemsToShare = @[[self getTotalForJob:jobTitle andTrack:rowsForSection]];
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
