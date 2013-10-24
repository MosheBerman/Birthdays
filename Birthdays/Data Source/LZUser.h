//
//  LZUser.h
//  Lyze
//
//  Created by Moshe Berman on 7/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LZComment;

@interface LZUser : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *facebookID;

- (NSUInteger)likes;				//	Total number of likes
- (NSArray *)comments;			//	Comments made by user
- (float)averageLikesPerComment;

- (void)addComment:(LZComment *)comment;

@end

