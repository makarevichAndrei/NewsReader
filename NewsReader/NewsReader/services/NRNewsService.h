//
//  NRNewsService.h
//  NewsReader
//
//  Created by Andrei on 1/24/19.
//  Copyright © 2019 makarevich. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NRNewsService : NSObject

- (void)loadNewsWithComplition:(void (^ __nullable)(void))completion;
- (NSFetchedResultsController *)newsFetchedResultsController;

@end
