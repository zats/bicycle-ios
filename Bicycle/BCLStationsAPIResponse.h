//
//  BCLStationsAPIResponse.h
//  Bicycle
//
//  Created by Sasha Zats on 7/6/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import "BCLAPIResponse.h"

@interface BCLStationsAPIResponse : BCLAPIResponse

@property (nonatomic) NSDate *lastUpdate;

@property (nonatomic, copy, readonly) NSArray *stations;

@end
