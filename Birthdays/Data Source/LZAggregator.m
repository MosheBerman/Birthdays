//
//  LZAggregator.m
//  Lyze
//
//  Created by Moshe Berman on 7/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "LZAggregator.h"

#import "LZComment.h"

#import "LZUser.h"

@implementation LZAggregator

#pragma mark - Word Aggregates

+ (NSArray *)wordsInComment:(LZComment *)comment
{
		NSCharacterSet *set = [[NSCharacterSet letterCharacterSet] invertedSet];
		NSString *lowercase = [[comment message] lowercaseString];
		
		return [lowercase componentsSeparatedByCharactersInSet:set];
}

+ (NSArray *)wordsInCollectionOfComments:(id)comments
{
		NSMutableArray *words = [[NSMutableArray alloc] init];
		
		for (LZComment *comment in comments) {
				[words addObjectsFromArray:[self wordsInComment:comment]];
		}
		
		NSMutableArray *wordsToRemove = [[NSMutableArray alloc] init];
		
		for (NSString *string in words) {
				if (![string length] > 0) {
						[wordsToRemove addObject:string];
				}
		}
		
		[words removeObjectsInArray:wordsToRemove];
		
		return words;
}

+ (NSSet *)uniqueWordsInComment:(LZComment *)comment
{
		return [NSSet setWithArray:[self wordsInComment:comment]];
}

+ (NSArray *)uniqueWordsInCollectionOfComments:(id)comments
{
		return [NSSet setWithArray:[self wordsInCollectionOfComments:comments]];
}

#pragma mark - Word Count Aggregates

+ (NSInteger)numberOfWordsInComment:(LZComment *)comment
{
		return [self wordsInComment:comment].count;
}

+ (NSInteger)numberOfWordsInCollectionOfComments:(id)comments
{
		return [self wordsInCollectionOfComments:comments].count;
}

+ (NSInteger)numberOfUniqueWordsInComment:(LZComment *)comment
{
		return [self uniqueWordsInComment:comment].count;
}

+ (NSInteger)numberOfUniqueWordsInCollectionOfComments:(id)comments
{
		return [self uniqueWordsInCollectionOfComments:comments].count;
}

#pragma mark - User Comment Aggregates

+ (NSArray *)commentsForCollectionOfUsers:(id)users
{
		NSMutableArray *comments = [[NSMutableArray alloc] init];
		
		for (LZUser *user in users) {
				[comments addObjectsFromArray:user.comments];
		}
		
		return comments;
}

+ (NSInteger)numberOfCommentsForCollectionOfUsers:(id)users
{
		return [self commentsForCollectionOfUsers:users].count;
}

#pragma mark - User Stats

+(NSArray *)wordsSpokenByUser:(LZUser *)user
{
		return [self wordsInCollectionOfComments:user.comments];
}

+(NSSet *)uniqueWordsSpokenByUser:(LZUser *)user
{
		return [self uniqueWordsInCollectionOfComments:user.comments];
}

+ (NSInteger)numberOfWordsSpokenByUser:(LZUser *)user
{
		return [self wordsSpokenByUser:user].count;
}

+ (NSInteger)numberOfUniqueWordsSpokenByUser:(LZUser *)user
{
		return [self uniqueWordsSpokenByUser:user].count;
}

#pragma mark - Like Aggregates

+ (NSInteger)numberOfLikesForCollectionOfComments:(id)comments
{
		NSInteger likes = 0;
		
		for (LZComment *comment in comments) {
				likes += comment.likeCount;
		}
		
		return likes;
}

+ (NSInteger)numberOfLikesForUser:(LZUser *)user
{
		return [self numberOfLikesForCollectionOfComments:user.comments];
}

#pragma mark - Popularity Contests

+ (LZComment *)mostPopularCommentInCollectionOfComments:(id)comments
{
		LZComment *popularComment = nil;
		
		for (LZComment *comment in comments) {
				if (!popularComment && comment.likeCount > 0) {
						popularComment = comment;
				}
				
				else if (popularComment && comment.likeCount > popularComment.likeCount)
				{
						popularComment = comment;
				}
		}
		
		return popularComment;
}

+ (LZComment *)mostPopularCommentForUser:(LZUser *)user
{
		return [self mostPopularCommentInCollectionOfComments:user.comments];
}

+ (LZUser *)userWithMostPopularCommentInCollection:(id)users
{
		LZUser *popularUser = nil;
		LZComment *popularComment = nil;
		
		for (LZUser *user in users) {
				
				LZComment *userPopularComment = [self mostPopularCommentForUser:user];
				
				if (userPopularComment.likeCount > popularComment.likeCount) {
						popularComment = userPopularComment;
						popularUser = user;
				}
		}
		
		return popularUser;
}

+ (LZUser *)userWithMostLikesAmongUsers:(id)users
{
		LZUser *userWithMost = nil;
		
		for (LZUser *user in users) {
				if (user.likes > userWithMost.likes) {
						userWithMost = user;
				}
		}
		
		return userWithMost;
}

+ (LZUser *)userWithMostAverageLikesAmongUsers:(id)users
{
		LZUser *userWithMost = nil;
		
		for (LZUser *user in users) {
				if (user.averageLikesPerComment > userWithMost.averageLikesPerComment) {
						userWithMost = user;
				}
		}
		
		return userWithMost;
}

+ (LZUser *)mostTalkativeUserByPostCountInCollection:(id)users
{
		LZUser *talkativeUser = nil;
		
		for (LZUser *user in users) {
				if (user.comments.count > talkativeUser.comments.count) {
						talkativeUser = user;
				}
		}
		return talkativeUser;
}

+ (LZUser *)mostTalkativeUserByWordCountInCollection:(id)users
{
		LZUser *talkativeUser = nil;
		NSInteger talkativeWordCount = 0;
		
		for (LZUser *user in users) {
				NSInteger wordCount = [self wordsSpokenByUser:user].count;
				if (wordCount > talkativeWordCount) {
						talkativeWordCount = wordCount;
						talkativeUser = user;
				}
		}
		return talkativeUser;
}

+ (LZUser *)mostTalkativeUserByWordsPerPostInCollection:(id)users
{
		LZUser *talkativeUser = nil;
		float highestAverage = 0;
		
		for (LZUser *user in users) {
				float average = 0;
				
				for (LZComment *comment in user.comments) {
						average += [self numberOfWordsInComment:comment];
				}
				
				average/= (float)user.comments.count;
				
				if (average > highestAverage) {
						talkativeUser = user;
						highestAverage = average;
				}
		}
		
		return talkativeUser;
}

#pragma mark - Word Popularity

+ (NSDictionary *)wordsByPopularityInCollectionOfComments:(id)comments ignoringCommon:(BOOL)ignoring
{
		NSMutableDictionary *countByWord = [[NSMutableDictionary alloc] init];
		NSMutableArray *words = [[self wordsInCollectionOfComments:comments] mutableCopy];
		
		if (ignoring) {
				
				NSArray *common = [self commonWords];
				
				for (NSString *commonWord in common) {
						[words removeObject:commonWord];
				}
				
		}
		
		for (NSString *word in words) {
				
				if ([word length] < 3)
				{
						continue;
				}
				
				if (countByWord[word]) {
						countByWord[word] = @([countByWord[word] integerValue]+1);
				}
				else {
						countByWord[word] = @(1);
				}
		}
		
		return countByWord;
}

+ (NSString *)mostPopularWordInComments:(NSArray *)comments
{
		return [self mostPopularWordInComments:comments ignoringCommonWords:YES];
}


+ (NSString *)mostPopularWordForUser:(LZUser *)user
{
				return  [self mostPopularWordInComments:user.comments];
}

+ (NSString *)mostPopularWordInComments:(NSArray *)comments ignoringCommonWords:(BOOL)ignoring
{
		NSDictionary *countByWord = [self wordsByPopularityInCollectionOfComments:comments ignoringCommon:ignoring];
		
		NSString *popularWord = nil;
		NSInteger times = 0;
		
		for (NSString *key in [countByWord allKeys]) {
				if ([countByWord[key] integerValue] > times) {
						times = [countByWord[key] integerValue];
						popularWord = key;
				}
		}
		
		
		return popularWord;
}

+ (NSString *)mostPopularWordForUser:(LZUser *)user ignoringCommonWords:(BOOL)ignoring
{
		return [self mostPopularWordInComments:user.comments ignoringCommonWords:ignoring];
}

+ (NSArray *)commonWords
{
				return @[@"you", @"the", @"or", @"but", @"and", @"he", @"she", @"they", @"them", @"us", @"we", @"why", @"for", @"to", @"that", @"it", @"of", @"is", @"your", @"if", @"what", @"in", @"this", @"are", @"not", @"then", @"about", @"have", @"with", @"when", @"was", @"like", @"just", @"all"];
}

@end
