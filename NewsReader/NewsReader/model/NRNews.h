//
//  NRNews.h
//  NewsReader
//
//  Created by Andrei on 1/24/19.
//  Copyright © 2019 makarevich. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NRNews: NSManagedObject

+ (NSFetchRequest<NRNews *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *author;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSDate *publishedAt;
@property (nullable, nonatomic, copy) NSString *newsDescription;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, copy) NSString *urlToImage;

@end
