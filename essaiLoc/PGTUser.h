//
//  PGTUser.h
//  essaiLoc
//
//  Created by Pierre Gilot on 16/03/12.
//  Copyright (c) 2012 Joyent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

#define kUserIDKey @"user_id"
#define kUserPwdKey @"user_password"

@interface PGTUser : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSDate * createdAt;


@end
