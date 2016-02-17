//
//  Pic+CoreDataProperties.h
//  CoreData
//
//  Created by Apple on 2/16/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Pic.h"

NS_ASSUME_NONNULL_BEGIN

@interface Pic (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) PicDetails *picDetails;

@end

NS_ASSUME_NONNULL_END
