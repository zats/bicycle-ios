//
//  Mantle+Reusability.m
//  Bicycle
//
//  Created by Sasha Zats on 7/6/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import "Mantle+Reusability.h"

#import "MTLModel.h"
#import <objc/runtime.h>

static inline NSString *MTLIdentifierForClassValue(Class classRef, id value) {
    return [NSString stringWithFormat:@"%@_%@", classRef, value];
}

@interface MTLStorage ()
@property (nonatomic, strong) NSMutableDictionary *storage;
@end

@implementation MTLStorage

+ (instancetype)defaultStorage {
    static MTLStorage *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MTLStorage alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.storage = [NSMutableDictionary dictionary];
    return self;
}

- (id)objectForClass:(Class)classRef uniqueIdentifier:(id)identifier {
    if (!classRef || !identifier) {
        return nil;
    }
    return self.storage[MTLIdentifierForClassValue(classRef, identifier)];
}

- (void)setObject:(id)object forClass:(Class)classRef uniqueIdentifier:(id)identifier {
    if (!classRef || !identifier) {
        return;
    } else if (!object) {
        [self removeObjectForClass:classRef uniqueIdentifier:identifier];
    } else {
        self.storage[MTLIdentifierForClassValue(classRef, identifier)] = object;
    }
}

- (void)removeObject:(id)object {
    if (![object conformsToProtocol:@protocol(MTLUniquing)]) {
        return;
    }
    NSString *uniqueIdentifierName = [[object class] uniquiePropertyName];
    id uniqueIdentifier = [object valueForKey:uniqueIdentifierName];
    [self removeObjectForClass:[object class] uniqueIdentifier:uniqueIdentifier];
}

- (void)removeObjectForClass:(Class)classRef uniqueIdentifier:(id)uniqueIdentifier {
    [self.storage removeObjectForKey:MTLIdentifierForClassValue(classRef, uniqueIdentifier)];
}

- (void)removeAllObjects {
    [self.storage removeAllObjects];
}

@end

@interface MTLModel (ReusabilityInternal)

- (instancetype)zts_initWithDictionary:(NSDictionary *)dictionary
                                 error:(NSError **)error __attribute__((objc_method_family(init)));

@end

@implementation MTLModel (Reusability)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = @selector(initWithDictionary:error:);
        SEL swizzledSelector = @selector(zts_initWithDictionary:error:);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(class,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (instancetype)zts_initWithDictionary:(NSDictionary *)dictionary
                                 error:(NSError **)error {
    if (![self conformsToProtocol:@protocol(MTLUniquing)]) {
        return [self zts_initWithDictionary:dictionary
                                      error:error];
    }

    NSString *property = [(id<MTLUniquing>)[self class] uniquiePropertyName];
    id value = dictionary[property];
    id existentInstance = [[MTLStorage defaultStorage] objectForClass:[self class]
                                                     uniqueIdentifier:value];
    if (!existentInstance) {
        self = [self zts_initWithDictionary:dictionary error:error];
        [[MTLStorage defaultStorage] setObject:self
                                      forClass:[self class]
                              uniqueIdentifier:value];
        return self;
    }
    
    self = existentInstance;
    id newInstnace = [[[self class] alloc] zts_initWithDictionary:dictionary error:error];
    [self mergeValuesForKeysFromModel:newInstnace];

    return self;
}

@end

