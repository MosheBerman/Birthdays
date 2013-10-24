//
//  LZComment.m
//  Lyze
//
//  Created by Moshe Berman on 7/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "LZComment.h"

@implementation LZComment

+ (LZComment *)commentWithDictionary:(NSDictionary *)dictionary
{
		LZComment *comment = [[LZComment alloc] init];
		
		if (comment) {
				comment.facebookID	= dictionary[@"id"];
				comment.user = nil;
				comment.message = dictionary[@"message"];
				comment.createdTime = dictionary[@"created_time"];
				comment.likeCount		= [dictionary[@"like_count"] integerValue];
				comment.userLikes		= [dictionary[@"user_likes"] boolValue];
		}
		
		return comment;
}

@end
