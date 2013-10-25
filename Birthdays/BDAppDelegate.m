//
//  BDAppDelegate.m
//  Birthdays
//
//  Created by Moshe Berman on 10/24/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "BDAppDelegate.h"

#import "LZJSONLoader.h"
#import "BDMetricsCalculator.h"

@interface BDAppDelegate ()

@property (nonatomic, strong) LZJSONLoader *dataSource;

@end

@implementation BDAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /**
     *  Create a data source.
     */
    
    _dataSource = [[LZJSONLoader alloc] init];

    /**
     *  Get the URL for the demo data.
     */
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"moshe_berman_oct_23" withExtension:@"json"];
    
    /**
     *  Load data from the demo file.
     */
    
    [[self dataSource] loadJSONFromURL:url withCompletion:^(BOOL success) {
        BDMetricsCalculator *calculator = [[BDMetricsCalculator alloc] init];
        [calculator runMetricsOnPosts:self.dataSource.posts];
    }];
}

@end
