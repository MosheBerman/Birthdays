//
//  LZPost.h
//  Birthdays
//
//  Created by Moshe Berman on 10/24/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LZUser;

@interface LZPost : NSObject

@property (nonatomic, strong) NSString *facebookID;
@property (nonatomic, strong) LZUser *user;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *createdTime;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) BOOL userLikes;
@property (nonatomic, strong) NSString *application;

+ (LZPost *)commentWithDictionary:(NSDictionary *)dictionary;


@end
