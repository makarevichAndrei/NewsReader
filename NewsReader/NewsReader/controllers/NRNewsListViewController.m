//
//  NRNewsListViewController.m
//  NewsReader
//
//  Created by Andrei on 1/24/19.
//  Copyright © 2019 makarevich. All rights reserved.
//

#import "NRNews.h"
#import "NRNewsListViewController.h"
#import "NRNewsService.h"
#import "NRNewsViewController.h"

static NSString *newsTableViewCell = @"NewsTableViewCell";
static NSString *detailsSegue = @"NewsDetails";

@interface NRNewsListViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NRNewsService *service;
@property (nonatomic, strong) NSFetchedResultsController *frc;

@end

@implementation NRNewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.service = [[NRNewsService alloc] init];
    [self.service loadNewsWithComplition: nil];
    self.frc = self.service.newsFetchedResultsController;
    self.frc.delegate = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshNews) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
}

- (void)refreshNews {
    __weak typeof(self) weakSelf = self;
    [self.service loadNewsWithComplition: ^{
        [[[weakSelf tableView] refreshControl] endRefreshing];
    }];
}

#pragma mark - Fetched Results Controller Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.frc.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.frc.sections[section].numberOfObjects;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newsTableViewCell forIndexPath:indexPath];
    
    NRNews *news = [self.frc objectAtIndexPath:indexPath];
    cell.textLabel.text = news.title;
    cell.detailTextLabel.text = news.content;
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:detailsSegue]) {
        NRNewsViewController *vc = (NRNewsViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        if (indexPath) {
            NRNews *news = [self.frc objectAtIndexPath:indexPath];
            [vc setNews:news];
        }
    }
}
@end
