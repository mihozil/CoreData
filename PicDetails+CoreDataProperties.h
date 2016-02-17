//
//  PicDetails+CoreDataProperties.h
//  CoreData
//
//  Created by Apple on 2/16/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PicDetails.h"

NS_ASSUME_NONNULL_BEGIN

@interface PicDetails (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSString *details;
@property (nullable, nonatomic, retain) NSNumber *rating;
@property (nullable, nonatomic, retain) NSManagedObject *pic;

@end

NS_ASSUME_NONNULL_END
