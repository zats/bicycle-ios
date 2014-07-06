//
//  BCLAPIClient.m
//  Bicycle
//
//  Created by Sasha Zats on 7/5/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import "BCLAPIClient.h"

#import "BCLStationAPIResponse.h"
#import "BCLAPIResponseSerializerProtocol.h"
#import "Objection+BetterObjectiveC.h"
#import <AFNetworking/AFNetworking.h>

@interface BCLAPIClient ()

@property (nonatomic, strong) id<BCLAPIResponseSerializerProtocol> responseSerializer;

@end

@implementation BCLAPIClient

objection_requires_sel(@selector(responseSerializer));

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (!self) {
        return nil;
    }
    
    [[JSObjection defaultInjector] injectDependencies:self];

    [self _configureDefaults];

    [self _registerResponseClasses];

    return self;
}

#pragma mark - Public

- (NSURLSessionDataTask *)allStations {
    [self GET:@"/api/1/stations" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    return nil;
}

#pragma mark - Private

- (void)_configureDefaults {
    [self.requestSerializer setValue:@"application/json"
                  forHTTPHeaderField:@"Accept"];
}

- (void)_registerResponseClasses {
    [(id<BCLAPIResponseSerializerProtocol>)self.responseSerializer registerClass:[BCLStationAPIResponse class] withConditionalBlock:^BOOL(NSHTTPURLResponse *response, id data) {
        return [[response.URL path] isEqualToString:@"/api/1/stations"];
    }];
}

@end
