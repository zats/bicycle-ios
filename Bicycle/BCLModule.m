//
//  BCLModule.m
//  Bicycle
//
//  Created by Sasha Zats on 7/6/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import "BCLModule.h"

#import "BCLAPIClient.h"
#import "BCLAPIResponseSerializer.h"
#import "BCLStationsMonitoringService.h"
#import <CoreLocation/CLLocationManager.h>

@implementation BCLModule

- (void)configure {
    [self bindProtocol:@protocol(BCLAPIClientProtocol) inScope:JSObjectionScopeSingleton usingBlock:^id(JSObjectionInjector *injector) {
        NSURL *URL = [NSURL URLWithString:@"https://bicycle.parseapp.com"];
        NSURLSessionConfiguration *configuraiton = [NSURLSessionConfiguration defaultSessionConfiguration];
        BCLAPIClient *apiClient = [[BCLAPIClient alloc] initWithBaseURL:URL
                                                   sessionConfiguration:configuraiton];
        return apiClient;
    }];
    
    [self bindClass:[BCLStationsMonitoringService class] inScope:JSObjectionScopeSingleton];
    
    [self bindClass:[BCLAPIResponseSerializer class]
         toProtocol:@protocol(BCLAPIResponseSerializerProtocol)];
    
    [self bindClass:[CLLocationManager class] inScope:JSObjectionScopeSingleton];
}

@end
