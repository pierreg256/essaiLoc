//
//  PGTCache.m
//  essaiLoc
//
//  Created by Pierre Gilot on 16/03/12.
//  Copyright (c) 2012 Joyent. All rights reserved.
//

#import "PGTCache.h"
#import "PGTUser.h"
#import "PGTMove.h"
#import "DDLog.h"

@implementation PGTCache

- (NSManagedObject *)findInstanceOfEntity:(NSEntityDescription *)entity
                  withPrimaryKeyAttribute:(NSString *)primaryKeyAttribute
                                    value:(id)primaryKeyValue
                   inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSLog(@"entity: %@, key: %@, value:%@, context:%@", entity, primaryKeyAttribute, primaryKeyValue, managedObjectContext);
    return nil;
}


- (NSArray*)fetchRequestsForResourcePath:(NSString*)resourcePath
{
  DDLog(@"resource: %@", resourcePath);
  if (([resourcePath isEqualToString:@"/users/"]) || ([resourcePath isEqualToString:@"/users"])) {
    return [NSArray arrayWithObject:[PGTUser fetchRequest]];
  } else {
    if (([resourcePath hasSuffix:@"/moves"]) && ([resourcePath hasPrefix:@"/users/"])) {
      NSString* userid = [[resourcePath substringWithRange:NSMakeRange(7, [resourcePath length]-13)] stringByReplacingURLEncoding];
      NSFetchRequest* fetch = [PGTMove fetchRequest];
      fetch.predicate = [NSPredicate predicateWithFormat:@"(user_id = %@)", userid];
      //DDLog(@"fetch: %@", fetch);
      return [NSArray arrayWithObject:fetch];
    }
    if ([resourcePath hasPrefix:@"/users/"]) {
      NSString* email = [[resourcePath substringFromIndex:7] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      NSFetchRequest* fetchRequest = [PGTUser fetchRequest];
      fetchRequest.predicate = [NSPredicate predicateWithFormat:@"email == %@", email];
      
      return [NSArray arrayWithObject:fetchRequest];
    }
  }
  
  return nil;
                                                       
}

-(BOOL)shouldDeleteOrphanedObject:(NSManagedObject *)managedObject
{
  return true;
}

@end
