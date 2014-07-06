//
//  Objection+BetterObjectiveC.h
//  Bicycle
//
//  Created by Sasha Zats on 7/6/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import <Objection/Objection.h>

@interface JSObjectionModule (BetterObjectiveC)

- (void)bindClass:(Class)classRef
       usingBlock:(id (^)(JSObjectionInjector *))block;

- (void)bindClass:(Class)classRef
          inScope:(JSObjectionScope)scope
       usingBlock:(id (^)(JSObjectionInjector *))block;

- (void)bindProtocol:(Protocol *)protocol
          usingBlock:(id (^)(JSObjectionInjector *))block;

- (void)bindProtocol:(Protocol *)protocol
             inScope:(JSObjectionScope)scope
          usingBlock:(id (^)(JSObjectionInjector *))block;

@end

@interface JSObjection (BetterObjectiveC)

+ (JSObjectionInjector *)createInjectorWithModule:(JSObjectionModule *)module;

@end

@interface JSObjectionInjector (BetterObjectiveC)

- (id)objectForEntity:(id)classOrProtocol;
- (id)objectForEntity:(id)classOrProtocol arguments:(id)argument, ... NS_REQUIRES_NIL_TERMINATION;

@end
