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
#import "LZPost.h"


@interface LZJSONLoader ()

@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) NSMutableArray *posts;

@end

@implementation LZJSONLoader

- (id)init
{
    self = [super init];
    if (self) {
        _users = [[NSMutableArray alloc] init];
        _posts = [[NSMutableArray alloc] init];
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
                
                NSArray *dataSet = dictionary[@"data"];
                
                //	If there was an error, log it
                if (error) {
                    NSLog(@"Error loading data: %@", error);
                }
                
                //	if not, and there's a data set, load it up
                else if([dataSet isKindOfClass:[NSArray class]])
                {
                    
                    NSMutableDictionary *userCache = [[NSMutableDictionary alloc] init];
                    
                    for (NSDictionary *postData in dataSet)
                    {
                        
                        /**
                         *  Load the post into an array.
                         */
                        
                        LZPost *post = [LZPost postWithDictionary:postData];
                        [[self posts] addObject:post];
                        
                        /**
                         *  Add the poster to the user list if 
                         *  he or she isn't accounted for yet.
                         *
                         */
                        NSString *userKey = [postData[@"from"][@"name"] lowercaseString];
                        
                        if (!userCache[userKey]) {
                            
                            LZUser *user = [[LZUser alloc] init];
                            user.name = [userKey capitalizedString];
                            user.facebookID = postData[@"from"][@"id"];
                            userCache[userKey] = user;
                        }
                        
                        
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
