//
//  Track+CoreDataProperties.h
//  TrackMiles
//
//  Created by Adrian Borcea Saeed on 07/07/2016.
//  Copyright © 2016 Adrian Borcea. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Track.h"

NS_ASSUME_NONNULL_BEGIN

@interface Track (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *created_at;
@property (nullable, nonatomic, retain) NSNumber *end_value;
@property (nullable, nonatomic, retain) NSNumber *isMiles;
@property (nullable, nonatomic, retain) NSDate *job_created_at;
@property (nullable, nonatomic, retain) NSNumber *start_value;
@property (nullable, nonatomic, retain) NSString *job_title;

@end

NS_ASSUME_NONNULL_END
