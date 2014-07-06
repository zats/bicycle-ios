//
//  BCLStationAPIResponse.m
//  Bicycle
//
//  Created by Sasha Zats on 7/5/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import "BCLStationAPIResponse.h"

#import "BCLStation.h"
#import <Mantle/Mantle.h>

@interface BCLStationAPIResponse () <MTLJSONSerializing>
@property (nonatomic, copy, readwrite) NSArray *stations;
@end

@implementation BCLStationAPIResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"stations" : @"response"
    };
}

+ (NSValueTransformer *)stationsJSONTransformer {
    return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:[BCLStation class]];
}

@end
