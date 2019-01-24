//
//  NRNews.m
//  NewsReader
//
//  Created by Andrei on 1/24/19.
//  Copyright © 2019 makarevich. All rights reserved.
//
//

#import "NRNews.h"

@implementation NRNews

+ (NSFetchRequest<NRNews *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"NRNews"];
}

@dynamic author;
@dynamic content;
@dynamic publishedAt;
@dynamic newsDescription;
@dynamic title;
@dynamic url;
@dynamic urlToImage;

@end
