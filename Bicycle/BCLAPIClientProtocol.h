//
//  BCLAPIClientProtocol.h
//  Bicycle
//
//  Created by Sasha Zats on 7/5/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BCLStationAPIResponse;

typedef void(^BCLAPIClientProtocolStationsCompletionHandler)(NSURLSessionDataTask *task, BCLStationAPIResponse *response, NSError *error);

@protocol BCLAPIClientProtocol <NSObject>

- (NSURLSessionDataTask *)stationsWithCompeltionHandler:(BCLAPIClientProtocolStationsCompletionHandler)completionHandler;

@end