//
//  GMSMapView_BetterXcodeIntegration.h
//  Bicycle
//
//  Created by Sasha Zats on 7/5/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

IB_DESIGNABLE @interface GMSMapView (BetterXcodeIntegration)

@property(nonatomic, weak) IBOutlet id<GMSMapViewDelegate> delegate;
@property(nonatomic, copy) IBOutlet GMSCameraPosition *camera;
@property(nonatomic, readonly) IBOutlet GMSProjection *projection;
@property(nonatomic, assign, getter=isMyLocationEnabled) IBInspectable BOOL myLocationEnabled;
@property(nonatomic, strong, readonly) IBOutlet GMSUISettings *settings;

@end
