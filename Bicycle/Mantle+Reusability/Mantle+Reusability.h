//
//  Mantle+Reusability.h
//  Bicycle
//
//  Created by Sasha Zats on 7/6/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import "MTLModel.h"

@interface MTLStorage : NSObject

+ (instancetype)defaultStorage;

- (id)objectForClass:(Class)classRef uniqueIdentifier:(id)uniqueIdentifier;

- (void)setObject:(id)object forClass:(Class)classRef uniqueIdentifier:(id)uniqueIdentifier;

- (void)removeObjectForClass:(Class)classRef uniqueIdentifier:(id)uniqueIdentifier;

- (void)removeObject:(id)object;

- (void)removeAllObjects;

@end

@interface MTLModel (Reusability)
@end

@protocol MTLUniquing <NSObject>
+ (NSString *)uniquiePropertyName;
@end
