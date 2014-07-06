//
//  BCLAPIClient.h
//  Bicycle
//
//  Created by Sasha Zats on 7/5/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import <AFNetworking/AFHTTPSessionManager.h>

#import "BCLAPIClientProtocol.h"

@interface BCLAPIClient : AFHTTPSessionManager <BCLAPIClientProtocol>

@end
