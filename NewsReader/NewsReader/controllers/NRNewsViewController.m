//
//  NRNewsViewController.m
//  NewsReader
//
//  Created by Andrei on 1/25/19.
//  Copyright © 2019 makarevich. All rights reserved.
//

#import "NRNewsViewController.h"

@interface NRNewsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UILabel *newsDetails;
@property (strong, nonatomic) NRNews *news;

@end

@implementation NRNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.newsTitle.text = self.news.title;
    self.newsDetails.text = self.news.content;
}

- (void)setupWithNews:(NRNews *)news {
    self.news = news;
}

@end
