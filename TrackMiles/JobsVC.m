//
//  JobsVC.m
//  TrackMiles
//
//  Created by Jahangir on 6/4/16.
//  Copyright © 2016 Adrian Borcea. All rights reserved.
//

#import "JobsVC.h"
#import "TracksVC.h"
#import "AddJobVC.h"

@implementation JobsVC{
    
    NSMutableArray *jobsArry;
    NSInteger selectedIndex;
    NSInteger editIndex;
}

-(void)viewDidLoad{
    
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    self.title=@"Jobs";
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self getAllJobs];
}

-(void)getAllJobs{
    
    AppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *theContext=[appdelegate managedObjectContext];
    NSError *error;
    NSFetchRequest *fReq=[[NSFetchRequest alloc] initWithEntityName:@"Job"];
    NSSortDescriptor *sortDecp=[[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
    [fReq setSortDescriptors:@[sortDecp]];
    
    jobsArry=[[NSMutableArray alloc] initWithArray:[theContext executeFetchRequest:fReq error:&error]];
    [_tblView reloadData];
}

#pragma mark - TableView Delegate/Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return jobsArry.count;
}

- (NSArray *)rightButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1 green:0.216 blue:0.216 alpha:1.0] title:@"Delete"];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:0 green:0.494 blue:0.973 alpha:1.0] title:@"Edit"];
    
    return leftUtilityButtons;
}
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    
    NSIndexPath *indexPath=[_tblView indexPathForCell:cell];
    switch (index) {
            
        case 0:
            NSLog(@"Delete");
            [self deleteJobAtIndex:indexPath];
            break;
            
        case 1:
            NSLog(@"Edit");
            editIndex=indexPath.row;
            [self performSegueWithIdentifier:@"edit" sender:self];
            
            break;

            
        default:
            break;
    }
}

-(void)deleteJobAtIndex:(NSIndexPath*)indexPath{
    
    AppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *theContext=[appdelegate managedObjectContext];
    NSError *error;
    Job *job=[jobsArry objectAtIndex:indexPath.row];
    [theContext deleteObject:job];
    
    [theContext save:&error];
    
    [jobsArry removeObject:job];
    [_tblView reloadData];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SWTableViewCell* cell=[_tblView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.delegate=self;
    cell.rightUtilityButtons=[self rightButtons];
    
    UILabel* lblTitle=[cell viewWithTag:10];
    
    Job *job=[jobsArry objectAtIndex:indexPath.row];
    lblTitle.text=job.title;
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [[UIView alloc] initWithFrame:CGRectZero];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedIndex=indexPath.row;
    [_tblView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"detail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"detail"]) {
        
        TracksVC *vc=[segue destinationViewController];
        vc.job=[jobsArry objectAtIndex:selectedIndex];
    }else if ([segue.identifier isEqualToString:@"edit"]){
        
        AddJobVC *vc=[segue destinationViewController];
        vc.job=[jobsArry objectAtIndex:editIndex];
    }
}
@end
