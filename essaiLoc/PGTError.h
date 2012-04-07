//
//  PGTError.h
//  essaiLoc
//
//  Created by Pierre Gilot on 28/03/12.
//  Copyright (c) 2012 Joyent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGTError : NSObject
@property (nonatomic, assign) NSNumber* code;
@property (nonatomic, assign) NSString* message;
@end
