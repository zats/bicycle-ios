//
//  BCLStationAPIResponse.h
//  Bicycle
//
//  Created by Sasha Zats on 7/5/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import "MTLModel.h"

@interface BCLStationAPIResponse : MTLModel

@property (nonatomic, copy, readonly) NSArray *stations;

@end
