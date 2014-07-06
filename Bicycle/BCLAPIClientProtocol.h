//
//  BCLAPIClientProtocol.h
//  Bicycle
//
//  Created by Sasha Zats on 7/5/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BCLAPIClientProtocol <NSObject>

- (NSURLSessionDataTask *)allStations;

@end