//
//  Objection+BetterObjectiveC.m
//  Bicycle
//
//  Created by Sasha Zats on 7/6/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import "Objection+BetterObjectiveC.h"

@implementation JSObjectionModule (BetterObjectiveC)

- (void)bindClass:(Class)classRef
       usingBlock:(id (^)(JSObjectionInjector *))block {
    [self bindBlock:block toClass:classRef];
}

- (void)bindClass:(Class)classRef
          inScope:(JSObjectionScope)scope
       usingBlock:(id (^)(JSObjectionInjector *))block {
    [self bindBlock:block toClass:classRef inScope:scope];
}

- (void)bindProtocol:(Protocol *)protocol usingBlock:(id (^)(JSObjectionInjector *))block {
    [self bindBlock:block toProtocol:protocol];
}

- (void)bindProtocol:(Protocol *)protocol
             inScope:(JSObjectionScope)scope
          usingBlock:(id (^)(JSObjectionInjector *))block {
    [self bindBlock:block toProtocol:protocol inScope:scope];
}

@end

@implementation JSObjection (BetterObjectiveC)

+ (JSObjectionInjector *)createInjectorWithModule:(JSObjectionModule *)module {
    return [self createInjector:module];
}

@end

@implementation JSObjectionInjector (BetterObjectiveC)

- (id)objectForEntity:(id)classOrProtocol {
    return [self getObject:classOrProtocol];
}

- (id)objectForEntity:(id)classOrProtocol arguments:(id)argument, ... {
    va_list va_arguments;
    va_start(va_arguments, argument);
    id object = [self getObject:classOrProtocol arguments:va_arguments];
    va_end(va_arguments);
    return object;
}

@end

