//
//  NRNewsService.m
//  NewsReader
//
//  Created by Andrei on 1/24/19.
//  Copyright © 2019 makarevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NRCoreDataStack.h"
#import "NRNewsService.h"
#import "NRNews.h"

@implementation NRNewsService

- (void)loadNewsWithComplition:(void (^ __nullable)(void))completion {
    NSString *path = @"https://newsapi.org/v2/top-headlines?country=us&apiKey=3c36bd5ccb184001bf62ab674755ce12";
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    
    [request setHTTPMethod:@"GET"];
    
    __weak typeof(self) weakself = self;
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSLog(@"%@", dataJSON);
        
        NSArray *articles = dataJSON[@"articles"];
        [weakself parseNews: articles];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    }];
    [dataTask resume];
}

- (NSFetchedResultsController *)newsFetchedResultsController {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"NRNews"];
    
    NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"publishedAt" ascending:NO];
    
    fetchRequest.sortDescriptors = @[dateSort];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:NRCoreDataStack.sharedInstance.persistentContainer.viewContext sectionNameKeyPath:nil cacheName:nil];
    
    NSError *fetchingError = nil;
    if (![frc performFetch:&fetchingError]) {
        NSLog(@"Failed to fetch");
    }
    
    return frc;
}

- (void)parseNews:(NSArray *)articles {
    NSManagedObjectContext *context = NRCoreDataStack.sharedInstance.persistentContainer.viewContext;
    NSDateFormatter * dateFormatter =  [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-ddTHH:mm:ssZ"];
    for (NSDictionary *article in articles) {
        NSString *title = article[@"title"] == [NSNull null] ? nil : article[@"title"];
        if (title) {
            NRNews *news = [self fetchNewsWithTitle:title fromContext:context];
            if (!news) {
                news = [NSEntityDescription insertNewObjectForEntityForName:@"NRNews" inManagedObjectContext:context];
                [news setTitle:title];
            }
            NSString *author = article[@"author"] == [NSNull null] ? nil : article[@"author"];
            [news setAuthor:author];
            NSString *url = article[@"url"] == [NSNull null] ? nil : article[@"url"];
            [news setUrl:url];
            NSString *content = article[@"content"] == [NSNull null] ? nil : article[@"content"];
            [news setContent:content];
            NSString *urlToImage = article[@"urlToImage"] == [NSNull null] ? nil : article[@"urlToImage"];
            [news setUrlToImage:urlToImage];
            NSDate *date = nil;
            NSString *dateString = article[@"publishedAt"] == [NSNull null] ? nil : article[@"publishedAt"];
            if (dateString) {
                date = [dateFormatter dateFromString:dateString];
            }
            [news setPublishedAt: date];
        }
    }
    
    if ([context hasChanges]) {
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Error, context not seved");
            [context reset];
        }
    }
}

- (NRNews *)fetchNewsWithTitle:(NSString *)title fromContext: (NSManagedObjectContext *)context {
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"NRNews"  inManagedObjectContext: context];
    [fetch setEntity:entityDescription];
    [fetch setPredicate:[NSPredicate predicateWithFormat:@"title == %@",title]];
    NSError * error = nil;
    return [[context executeFetchRequest:fetch error:&error] firstObject];
}

@end
