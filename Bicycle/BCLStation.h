//
//  BCLStation.h
//  Bicycle
//
//  Created by Sasha Zats on 7/5/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import "BCLModel.h"

@import CoreLocation;

@interface BCLStation : BCLModel

@property (nonatomic, copy, readonly) NSString *stationId;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D location;
@property (nonatomic, readonly) NSUInteger capacity;
@property (nonatomic, readonly) NSUInteger availableBicycles;
@property (nonatomic, readonly) NSUInteger availableDocks;

@end
