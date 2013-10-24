//
//  LZPost.m
//  Birthdays
//
//  Created by Moshe Berman on 10/24/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "LZPost.h"
#import "LZComment.h"

@implementation LZPost

+ (LZPost *)postWithDictionary:(NSDictionary *)dictionary
{
    LZPost *post = [[LZPost alloc] init];
    
    if (post) {
        post.facebookID     = dictionary[@"id"];
        post.user           = nil;
        post.message        = dictionary[@"message"];
        post.createdTime    = dictionary[@"created_time"];
        post.likeCount		= [dictionary[@"likes"][@"data"] count];
        post.userLikes		= [dictionary[@"user_likes"] boolValue];
        post.application    = dictionary[@"application"][@"name"];
        post.comments = [[NSMutableArray alloc] init];
        
        for (NSDictionary *commentData in dictionary[@"comments"][@"data"]) {
            LZComment *comment = [LZComment commentWithDictionary:commentData];
            [[post comments] addObject:comment];
        }
    }
    
    return post;
}


@end
