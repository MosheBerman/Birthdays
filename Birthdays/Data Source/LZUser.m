//
//  LZUser.m
//  Lyze
//
//  Created by Moshe Berman on 7/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "LZAggregator.h"

#import "LZComment.h"

#import "LZUser.h"

@interface LZUser ()

@property (nonatomic, strong) NSMutableArray *comments;

@end

@implementation LZUser

- (id)init
{
    self = [super init];
    if (self) {
                _name = nil;
				_facebookID = nil;
				_comments = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSUInteger)likes
{
		return [LZAggregator numberOfLikesForUser:self];
}

- (void)addComment:(LZComment *)comment
{
		[_comments addObject:comment];
		comment.user = self;
		
}

- (float)averageLikesPerComment
{
		return (float)self.likes/(float)self.comments.count;
}

- (NSString *)description
{
		
		NSMutableString *string = [[NSMutableString alloc] init];
		
		[string appendFormat:@"\n%@", self.name];
		[string appendFormat:@"\nComments: %li", (unsigned long)self.comments.count];
		[string appendFormat:@"\nLikes: %li", (unsigned long)self.likes];
		[string appendFormat:@"\nLikes per comment: %f", self.averageLikesPerComment];
		[string appendFormat:@"\n"];
		
		return string;
}

@end
