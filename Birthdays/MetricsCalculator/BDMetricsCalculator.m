//
//  BDMetricsCalculator.m
//  Birthdays
//
//  Created by Moshe Berman on 10/24/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "BDMetricsCalculator.h"

#import "LZPost.h"
#import "LZUser.h"

@implementation BDMetricsCalculator

- (void)runMetricsOnPosts:(NSArray *)posts {
    {
        
        /**
         *  Upon completion, do something...
         */
        
        NSMutableDictionary *messagesWithAssociatedUsers = [[NSMutableDictionary alloc] init];
        NSMutableArray * unsortedMessages = [[NSMutableArray alloc] init];
        
        /**
         *  Iterates the posts from the feed
         */
        for (LZPost *post in posts) {
            
            /**
             *  If the post has a message...
             */
            if (post.message && ![post.user.name isEqualToString:@"Moshe Berman"]) {
                
                /**
                 *  Use the message text as a key.
                 */
                NSString *key = post.message;
                
                /**
                 *  Ensure we have an array for the key.
                 */
                if (![[messagesWithAssociatedUsers allKeys] containsObject:key]) {
                    messagesWithAssociatedUsers[key] = [[NSMutableArray alloc] init];
                }
                
                /**
                 *  Keep the message around.
                 */
                [unsortedMessages addObject:post.message];
                
                /**
                 *  Add the user to the message's store.
                 */
                if(post.user) {
                    [messagesWithAssociatedUsers[key] addObject:post.user];
                }
            }
        }
        
        /**
         *  Log the total number of wishes.
         */
        
        NSLog(@"There were %lu birthday wishes in total.", unsortedMessages.count);
        
        /**
         *  Log the number of unique birthday wishes.
         */
        
        NSLog(@"There were %lu unique birthday wishes.", (unsigned long)messagesWithAssociatedUsers.allKeys.count);
        
        /**
         *  Sort the expressions from most common to least common.
         */
        
        NSMutableArray *expressionsByFrequency = [[NSMutableArray alloc] init];
        if (messagesWithAssociatedUsers.allKeys.count > 0) {
            [expressionsByFrequency addObject:messagesWithAssociatedUsers.allKeys[0]];
        }
        
        
        /**
         *  Sort the expressions by most to least used.
         */
        
        for (NSString * key in messagesWithAssociatedUsers.allKeys) {
            
            if ([expressionsByFrequency containsObject:key]) {
                continue;
            }
            
            NSInteger numberOfUserForKey = [messagesWithAssociatedUsers[key] count];
            
            for (NSInteger i = 0; i < expressionsByFrequency.count; i++) {
                NSInteger frequencyOfObjectAtIndex = [messagesWithAssociatedUsers[expressionsByFrequency[i]] count];
                
                if (numberOfUserForKey >= frequencyOfObjectAtIndex) {
                    [expressionsByFrequency insertObject:key atIndex:i];
                    break;
                }
            }
        }
        
        /**
         *  Log them out...
         */
        
        for (NSString *sortedKey in expressionsByFrequency) {
            //            NSInteger count = [messagesWithAssociatedUsers[sortedKey] count];
            //            NSLog(@"%@ was wished %li time(s)", sortedKey, (long)count);
        }
        
        /**
         *  Log out all the ones that used my name.
         */
        
        NSMutableArray *wishesWithMyName = [[NSMutableArray alloc] init];
        
        for (NSString* key in unsortedMessages) {
            if ([[key lowercaseString] rangeOfString:@"moshe"].location != NSNotFound) {
                [wishesWithMyName addObject:key];
            }
        }
        
        NSSet *set = [NSSet setWithArray:wishesWithMyName];
        
        NSLog(@"Wishes with my name appeared %lu times. (%lu unique.)", (unsigned long)wishesWithMyName.count, (unsigned long)set.count);
        
        /**
         *  Log out the ones that were unique.
         */
        
        NSMutableArray *expressionsThatAppearOnce = [[NSMutableArray alloc] init];
        
        for (NSString *expression in expressionsByFrequency) {
            if ([messagesWithAssociatedUsers[expression] count] == 1) {
                [expressionsThatAppearOnce addObject:expression];
            }
        }
        
        NSLog(@"There were %lu messages that appear only once.", (unsigned long)expressionsThatAppearOnce.count);
        
        /**
         *  Log out the ones that were in Hebrew.
         */
        
        NSCharacterSet *hebrewCaracters = [NSCharacterSet characterSetWithCharactersInString:@"אבגדהוזחטיכלמנסעפצקרשת"];
        NSMutableArray *messagesWithHebrewInThem = [[NSMutableArray alloc] init];
        
        for (NSString *message in unsortedMessages) {
            if ([message rangeOfCharacterFromSet:hebrewCaracters].location != NSNotFound) {
                [messagesWithHebrewInThem addObject:message];
            }
        }
        
        NSLog(@"There were %lu messages containing Hebrew.", (unsigned long)messagesWithHebrewInThem.count);
        
        /**
         *  Log out the number of exclamations points.
         */
        
        NSInteger numberOfExclamationMarks = 0;
        
        NSMutableArray *messagesWithMostExclamationMarks = [[NSMutableArray alloc] init];
        NSInteger maxExclamationsPerMessage = 0;
        
        for (NSString *message in unsortedMessages) {
            NSInteger numberPerMessage = [self numberOfExclamationMarksInString:message];
            numberOfExclamationMarks += numberPerMessage;
            
            if (numberOfExclamationMarks == maxExclamationsPerMessage) {
                [messagesWithMostExclamationMarks addObject:messagesWithMostExclamationMarks];
            }else if (numberPerMessage > maxExclamationsPerMessage) {
                maxExclamationsPerMessage = numberPerMessage;
                [messagesWithMostExclamationMarks removeAllObjects];
                [messagesWithMostExclamationMarks addObject:message];
            }
        }
        
        NSLog(@"A total of %li exclamation marks appeared on my timeline.", numberOfExclamationMarks);
        
        /**
         *  Post with the most.
         */
        
        if (messagesWithMostExclamationMarks.count == 0) {
            NSLog(@"There were no exclamation marks. :-(");
        }
        if (messagesWithMostExclamationMarks.count == 1) {
            NSLog(@"The most exclamation marks appear in this birthday wish: '%@'. There were %ld of them.", messagesWithMostExclamationMarks[0], (long)maxExclamationsPerMessage);
        }
        else {
            NSLog(@"The most exclamation marks appear in these birthday wishes: %@. There were %ld of them.", messagesWithMostExclamationMarks, (long)maxExclamationsPerMessage);
        }
        
        /**
         *  The average number of exclamation points per post.
         */
        
        CGFloat totalExclamations = (CGFloat)numberOfExclamationMarks;
        CGFloat numberOfMessages = (CGFloat)unsortedMessages.count;
        CGFloat numberOfUniqueMessages = (CGFloat)expressionsByFrequency.count;
        
        CGFloat averageNumberOfExclamationMarks = totalExclamations/numberOfMessages;
        CGFloat averageNumberOfExclamationMarksInUniqueSet = totalExclamations/numberOfUniqueMessages;
        
        NSLog(@"There were %f exclamations per post, on average.", averageNumberOfExclamationMarks);
        NSLog(@"There were %f exclamations per unique post, on average.", averageNumberOfExclamationMarksInUniqueSet);
        
        
        /**
         *  Log out the ones that were not just "happy birthday!"
         */
        
        NSMutableArray *specialGreetings = [[NSMutableArray alloc] init];
        
        for (__strong NSString *message in expressionsByFrequency) {
            
            /** Remove the punctuation and make the string lowercase. */
            NSCharacterSet *punctuation = [NSCharacterSet characterSetWithCharactersInString:@"!.?, "];
            
            NSString *editedMessage = [[[message componentsSeparatedByCharactersInSet:punctuation] componentsJoinedByString:@""] lowercaseString];
            
            /** Remove "happy birthday" and @"happy bday" */
            editedMessage = [editedMessage stringByReplacingOccurrencesOfString:@"happybirthday" withString:@""];
            editedMessage = [editedMessage stringByReplacingOccurrencesOfString:@"happybday" withString:@""];
            
            /** Check if there's anything left. */
            if ([editedMessage length] > 0) {
                [specialGreetings addObject:message];
            }
        }
        
        NSLog(@"There were %lu personal messages.", specialGreetings.count);
        
        /**
         *  Log out the ones that contain "bday".
         */
        
        NSMutableArray *wishes = [[NSMutableArray alloc] init];
        
        for (NSString *wish in unsortedMessages) {
            NSString *lowercaseWish = [wish lowercaseString];
            
            if ([lowercaseWish rangeOfString:@"bday"].location != NSNotFound) {
                [wishes addObject:wish];
            }
        }
        
        NSLog(@"%lu people chose to abbreviate birthday to bday.", (unsigned long)wishes.count);
        
    }
}

/**
 *  This is probably horribly inefficient, but it achieves
 *  the state goal of counting the number of exclamation marks
 *  in a given string.
 */

- (NSInteger)numberOfExclamationMarksInString:(NSString *)string {
    
    /** A count variable */
    NSInteger count = 0;
    
    /** The characters that aren't an exclamation mark. */
    NSCharacterSet *characters = [[NSCharacterSet characterSetWithCharactersInString:@"!"] invertedSet];
    
    /** */
    NSMutableArray *temp = [[string componentsSeparatedByCharactersInSet:characters] mutableCopy];
    
    /** */
    for (NSString *substring in temp) {
        if ([substring length] > 0) {
            count += [substring length];
        }
    }
    return count;
    
}

@end
