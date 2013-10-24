//
//  LZComment.h
//  Lyze
//
//  Created by Moshe Berman on 7/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LZUser;

@interface LZComment: NSObject

@property (nonatomic, strong) NSString *facebookID;
@property (nonatomic, strong) LZUser *user;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *createdTime;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) BOOL userLikes;

+ (LZComment *)commentWithDictionary:(NSDictionary *)dictionary;

@end
