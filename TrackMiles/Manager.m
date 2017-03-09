//
//  Manager.m
//  TrackMiles
//
//  Created by Jahangir on 6/5/16.
//  Copyright © 2016 Adrian Borcea. All rights reserved.
//

#import "Manager.h"

@implementation Manager

+(NSString* )milesFromKilometer:(NSInteger)km{
    
    NSInteger doubleMiles=km * 0.621371;
    
    NSString *miles=[NSString stringWithFormat:@"%li",(long)doubleMiles];
    return miles;
}
+(NSString*)kilometersFromMiles:(NSInteger)miles{
    
    NSInteger km=miles * 1.60934;
    NSString *kmStr=[NSString stringWithFormat:@"%li",(long)km];
    return kmStr;
}

+(NSString *)standerdFormateStringForDate:(NSDate*)date{
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/YYYY"];
    return [formatter stringFromDate:date];
}

+(NSMutableArray*)sortArchiveResults:(NSArray*)results{
    
    NSMutableArray* tracksArry=[[NSMutableArray alloc] init];
    
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
            
            if (currMonth==createdMonth && currYear==createdYear) {
                
                [tracksArry addObject:tk];
            }
        }
        
    }else{
        
        NSInteger monthSel=[[NSUserDefaults standardUserDefaults] integerForKey:k_Month_Index]+1;
        NSDate *today = [NSDate date];
        NSCalendar *gregorian = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [gregorian components:(NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        NSInteger currMonth=[dateComponents month];
        NSInteger currYear=[dateComponents year];
        
        for (Track *tk in results) {
            
            dateComponents = [gregorian components:(NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:tk.created_at];
            
            NSInteger createdYear=dateComponents.year;
            
            if (monthSel>currMonth) {
                
                if (currYear==createdYear) {
                    [tracksArry addObject:tk];
                }
                
            }else if (monthSel<currMonth){
                
                if (currYear==createdYear+1) {
                    [tracksArry addObject:tk];
                }
                
            }else{
                
                if ((currYear==createdYear) || (currYear==createdYear+1)) {
                    [tracksArry addObject:tk];
                }
                
            }
        }
        
    }
    
    return  tracksArry;
}

+(NSMutableArray*)findArchiveResults:(NSArray*)results{
    
    NSMutableArray* tracksArry=[[NSMutableArray alloc] init];
    
    NSInteger timeSel=[[NSUserDefaults standardUserDefaults] integerForKey:k_Time_selection];
    if (timeSel==0) {
        
        NSDate *today = [NSDate date];
        NSCalendar *gregorian = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [gregorian components:(NSMonthCalendarUnit) fromDate:today];
        NSInteger currMonth=[dateComponents month];
        
        for (Track *tk in results) {
            
            dateComponents = [gregorian components:(NSMonthCalendarUnit) fromDate:tk.created_at];
            NSInteger createdMonth=dateComponents.month;
            
            if (currMonth==createdMonth) {
                
                [tracksArry addObject:tk];
            }
        }
        
    }else{
        
        NSInteger monthSel=[[NSUserDefaults standardUserDefaults] integerForKey:k_Month_Index]+1;
        NSDate *today = [NSDate date];
        NSCalendar *gregorian = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [gregorian components:(NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        NSInteger currMonth=[dateComponents month];
        NSInteger currYear=[dateComponents year];
        
        for (Track *tk in results) {
            
            dateComponents = [gregorian components:(NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:tk.created_at];
            
            NSInteger createdYear=dateComponents.year;
            
            if (monthSel>currMonth) {
                
                if (currYear==createdYear) {
                    [tracksArry addObject:tk];
                }
                
            }else if (monthSel<currMonth){
                
                if (currYear==createdYear+1) {
                    [tracksArry addObject:tk];
                }
                
            }else{
                
                if ((currYear==createdYear) || (currYear==createdYear+1)) {
                    [tracksArry addObject:tk];
                }
                
            }
        }
        
    }
    
    NSMutableArray *archiveArry= [[NSMutableArray alloc] init];
    for (Track *tk in results) {
        
        if ([tracksArry indexOfObject:tk] == NSNotFound) {
            
            [archiveArry addObject:tk];
        }
    }
    return  archiveArry;
}


@end
