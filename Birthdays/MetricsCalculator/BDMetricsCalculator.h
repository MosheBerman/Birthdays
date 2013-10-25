//
//  BDMetricsCalculator.h
//  Birthdays
//
//  Created by Moshe Berman on 10/24/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDMetricsCalculator : NSObject

/**
 *  This method runs all of the metrics and logs the results.
 *
 *  TODO: Refactor this into neat little methods.
 *
 */

- (void)runMetricsOnPosts:(NSArray *)posts;

@end
