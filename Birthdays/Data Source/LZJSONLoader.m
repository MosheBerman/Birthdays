//
//  LZJSONLoader.m
//  Lyze
//
//  Created by Moshe Berman on 7/11/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "LZJSONLoader.h"

#import "LZComment.h"
#import "LZUser.h"



@interface LZJSONLoader ()

@property (nonatomic, strong) NSMutableArray *users;

@end

@implementation LZJSONLoader

- (id)init
{
    self = [super init];
    if (self) {
        _users = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadJSONFromURL:(NSURL *)url withCompletion:(void(^)(BOOL success))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            if (!data) {
                data = [NSData dataWithContentsOfFile:[url absoluteString]];
            }
            
            if (data) {
                
                //	Load JSON Data
                NSError *error = nil;
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                
                NSArray *commentDataSet = dictionary[@"data"];
                
                //	If there was an error, log it
                if (error) {
                    NSLog(@"Error loading data: %@", error);
                }
                
                //	if not, and there's a data set, load it up
                else if([commentDataSet isKindOfClass:[NSArray class]])
                {
                    
                    NSMutableDictionary *userCache = [[NSMutableDictionary alloc] init];
                    
                    for (NSDictionary *commentData in commentDataSet)
                    {
                        
                        NSString *userKey = [commentData[@"from"][@"name"] lowercaseString];
                        
                        if (!userCache[userKey]) {
                            
                            LZUser *user = [[LZUser alloc] init];
                            user.name = [userKey capitalizedString];
                            user.facebookID = commentData[@"from"][@"id"];
                            userCache[userKey] = user;
                        }
                        
                        LZComment *comment = [LZComment commentWithDictionary:commentData];
                        [userCache[userKey] addComment:comment];
                    }
                    
                    [_users removeAllObjects];
                    
                    for (NSString *key in [userCache allKeys]) {
                        [_users addObject:userCache[key]];
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(YES);
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(NO);
                });
            }
            
        }];
    });
    
}

- (NSArray *)users
{
    return _users;
}
@end
