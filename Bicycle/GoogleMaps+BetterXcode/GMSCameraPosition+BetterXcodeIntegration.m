//
//  GMSMapView_BetterXcodeIntegration.h
//  Bicycle
//
//  Created by Sasha Zats on 7/5/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import "GMSCameraPosition+BetterXcodeIntegration.h"

@implementation GMSCameraPosition (BetterXcodeIntegration)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (!self) {
        return nil;
    }
  
    [self setValue:[aDecoder decodeObjectForKey:@"zoom"]
            forKey:@"zoom"];
    [self setValue:[aDecoder decodeObjectForKey:@"viewingAngle"]
            forKey:@"viewingAngle"];
    [self setValue:[aDecoder decodeObjectForKey:@"bearing"]
            forKey:@"bearing"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeFloat:self.zoom
                 forKey:@"zoom"];
    [aCoder encodeDouble:self.viewingAngle
                  forKey:@"viewingAngle"];
    [aCoder encodeDouble:self.bearing
                 forKey:@"bearing"];
}

#pragma clang diagnostic pop

@end
