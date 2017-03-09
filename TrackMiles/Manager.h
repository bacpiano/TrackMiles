//
//  Manager.h
//  TrackMiles
//
//  Created by Jahangir on 6/5/16.
//  Copyright © 2016 Adrian Borcea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Manager : NSObject

+(NSString *)milesFromKilometer:(NSInteger)km;
+(NSString*)kilometersFromMiles:(NSInteger)miles;

+(NSString *)standerdFormateStringForDate:(NSDate*)date;
+(NSMutableArray*)sortArchiveResults:(NSArray*)results;
+(NSMutableArray*)findArchiveResults:(NSArray*)results;
@end
