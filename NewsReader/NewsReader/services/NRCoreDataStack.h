//
//  NRCoreDataStack.h
//  NewsReader
//
//  Created by Andrei on 1/24/19.
//  Copyright © 2019 makarevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NRCoreDataStack : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

+ (instancetype)sharedInstance;
- (void)saveContext;

@end
