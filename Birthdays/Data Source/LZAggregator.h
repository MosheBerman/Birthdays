//
//  LZAggregator.h
//  Lyze
//
//  Created by Moshe Berman on 7/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LZComment;
@class LZUser;

@interface LZAggregator : NSObject

#pragma mark - Word Aggregates

+ (NSArray *)wordsInComment:(LZComment *)comment;
+ (NSArray *)wordsInCollectionOfComments:(id)comments;

+ (NSSet *)uniqueWordsInComment:(LZComment *)comment;
+ (NSSet *)uniqueWordsInCollectionOfComments:(id)comments;

#pragma mark - Word Count Aggregates

+ (NSInteger)numberOfWordsInComment:(LZComment *)comment;
+ (NSInteger)numberOfWordsInCollectionOfComments:(id)comments;

+ (NSInteger)numberOfUniqueWordsInComment:(LZComment *)comment;
+ (NSInteger)numberOfUniqueWordsInCollectionOfComments:(id)comments;

#pragma mark - User Comment Aggregates

+ (NSArray *)commentsForCollectionOfUsers:(id)users;
+ (NSInteger)numberOfCommentsForCollectionOfUsers:(id)users;

#pragma mark - User Stats

+(NSArray *)wordsSpokenByUser:(LZUser *)user;
+(NSSet *)uniqueWordsSpokenByUser:(LZUser *)user;

+ (NSInteger)numberOfWordsSpokenByUser:(LZUser *)user;
+ (NSInteger)numberOfUniqueWordsSpokenByUser:(LZUser *)user;

#pragma mark - Like Aggregates

+ (NSInteger)numberOfLikesForCollectionOfComments:(id)comments;
+ (NSInteger)numberOfLikesForUser:(LZUser *)user;

#pragma mark - Popularity Contests

+ (LZComment *)mostPopularCommentInCollectionOfComments:(id)comments;
+ (LZComment *)mostPopularCommentForUser:(LZUser *)user;

+ (LZUser *)userWithMostPopularCommentInCollection:(id)users;
+ (LZUser *)userWithMostLikesAmongUsers:(id)users;
+ (LZUser *)userWithMostAverageLikesAmongUsers:(id)users;

+ (LZUser *)mostTalkativeUserByPostCountInCollection:(id)users;
+ (LZUser *)mostTalkativeUserByWordCountInCollection:(id)users;
+ (LZUser *)mostTalkativeUserByWordsPerPostInCollection:(id)users;

#pragma mark - Word Popularity

+ (NSString *)mostPopularWordInComments:(NSArray *)comments;
+ (NSString *)mostPopularWordForUser:(LZUser *)user;

+ (NSString *)mostPopularWordInComments:(NSArray *)comments ignoringCommonWords:(BOOL)ignoring;
+ (NSString *)mostPopularWordForUser:(LZUser *)user ignoringCommonWords:(BOOL)ignoring;

+ (NSDictionary *)wordsByPopularityInCollectionOfComments:(id)comments ignoringCommon:(BOOL)ignoring;

@end
