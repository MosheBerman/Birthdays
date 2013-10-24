//
//  LZJSONLoader.h
//  Lyze
//
//  Created by Moshe Berman on 7/11/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZJSONLoader : NSObject

- (void)loadJSONFromURL:(NSURL *)url withCompletion:(void(^)(BOOL success))completion;

- (NSArray *)users;
- (NSArray *)posts;

@end
