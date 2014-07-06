//
//  BCLAPIResponseSerializer.m
//  Bicycle
//
//  Created by Sasha Zats on 7/5/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import "BCLAPIResponseSerializer.h"

#import <Mantle/Mantle.h>

@interface BCLAPIResponseSerializer ()
@property (nonatomic, strong) NSMutableDictionary *conditionalBlocks;
@end


@implementation BCLAPIResponseSerializer

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.conditionalBlocks = [NSMutableDictionary dictionary];
    return self;
}

#pragma mark - Public

- (void)registerClass:(Class)resopnseModelClass
 withConditionalBlock:(BCLAPIResponseSerializerCondition)block {
    self.conditionalBlocks[ NSStringFromClass(resopnseModelClass) ] = [block copy];
}

#pragma mark - AFHTTPResponseSerializer

- (id)responseObjectForResponse:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error {
    id responseObject = [super responseObjectForResponse:response
                                                    data:data
                                                   error:error];
    if (!responseObject && error && *error) {
        return nil;
    }
    
    Class responseClass = nil;
    for (NSString *className in self.conditionalBlocks) {
        BCLAPIResponseSerializerCondition block = self.conditionalBlocks[className];
        if (block && block(response, responseObject)) {
            responseClass = NSClassFromString(className);
            break;
        }
    }

    if (!responseClass || ![responseClass isSubclassOfClass:[MTLModel class]]) {
        NSLog(@"No response class found");
        return responseObject;
    }
    
    id model = [MTLJSONAdapter modelOfClass:responseClass
                         fromJSONDictionary:responseObject
                                      error:error];
    if (model) {
        return model;
    }

    if (error && *error) {
        return nil;
    }
    
    return responseObject;
}

@end
