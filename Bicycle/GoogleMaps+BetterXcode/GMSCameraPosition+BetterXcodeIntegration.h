//
//  GMSMapView_BetterXcodeIntegration.h
//  Bicycle
//
//  Created by Sasha Zats on 7/5/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface GMSCameraPosition (BetterXcodeIntegration) <NSCoding>

@property(nonatomic, readonly) IBInspectable CLLocationCoordinate2D target;
@property(nonatomic, readonly) IBInspectable float zoom;
@property(nonatomic, readonly) IBInspectable CLLocationDirection bearing;
@property(nonatomic, readonly) IBInspectable double viewingAngle;

@end
