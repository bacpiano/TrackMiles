//
//  Job+CoreDataProperties.h
//  TrackMiles
//
//  Created by Adrian Borcea Saeed on 07/07/2016.
//  Copyright © 2016 Adrian Borcea. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Job.h"

NS_ASSUME_NONNULL_BEGIN

@interface Job (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *created_at;
@property (nullable, nonatomic, retain) NSString *title;

@end

NS_ASSUME_NONNULL_END
