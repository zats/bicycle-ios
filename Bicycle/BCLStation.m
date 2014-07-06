//
//  BCLStation.m
//  Bicycle
//
//  Created by Sasha Zats on 7/5/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import "BCLStation.h"

#import <Mantle/Mantle.h>

@interface BCLStation () <MTLJSONSerializing>

@property (nonatomic, copy, readwrite) NSString *stationId;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *address;
@property (nonatomic, readwrite) NSUInteger capacity;
@property (nonatomic, readwrite) NSUInteger availableBicycles;
@property (nonatomic, readwrite) NSUInteger availableDocks;
@property (nonatomic, readwrite) CLLocationCoordinate2D location;

@end

@implementation BCLStation

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
         SQTypedKeyPath(BCLStation, stationId): @"id",
         SQTypedKeyPath(BCLStation, name): @"name",
         SQTypedKeyPath(BCLStation, address): @"address",
         SQTypedKeyPath(BCLStation, capacity): @"capacity",
         SQTypedKeyPath(BCLStation, availableBicycles): @"availableBicycles",
         SQTypedKeyPath(BCLStation, availableDocks): @"availableDocks",
         SQTypedKeyPath(BCLStation, location): @"location"
    };
}

+ (NSValueTransformer *)locationJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSArray *coordinates) {
        if ([coordinates count] != 2) {
            return nil;
        }
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([coordinates[0] doubleValue],
                                                                     [coordinates[1] doubleValue]);
        if (!CLLocationCoordinate2DIsValid(location)) {
            return nil;
        }
        return [NSValue value:&location
                 withObjCType:@encode(CLLocationCoordinate2D)];
    } reverseBlock:^id(NSValue *locationValue) {
        CLLocationCoordinate2D location = kCLLocationCoordinate2DInvalid;
        [locationValue getValue:&location];
        if (CLLocationCoordinate2DIsValid(location)) {
            return @[ @(location.latitude), @(location.longitude) ];
        }
        return nil;
    }];
}

@end
