//
//  BCLMapViewController.m
//  Bicycle
//
//  Created by Sasha Zats on 7/5/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import "BCLMapViewController.h"

#import "BCLAnnotation.h"
#import "BCLStation.h"
#import "BCLStationsMonitoringService.h"
#import "MKCoordinateRegion+String.h"

#import <GoogleMaps/GoogleMaps.h>
#import <Masonry/Masonry.h>
#import <MapKit/MapKit.h>

@interface BCLMapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) BCLStationsMonitoringService *stationsMonitoringService;
@property (nonatomic, copy) NSArray *markers;

@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation BCLMapViewController

objection_requires_sel(@selector(stationsMonitoringService), @selector(locationManager));

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[JSObjection defaultInjector] injectDependencies:self];
    
    [self _setupVisualEffects];
    [self _setMapDefaults];
    
    [self.locationManager requestWhenInUseAuthorization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Private

- (void)_setupVisualEffects {
    UIBlurEffect *blurVisualEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurVisualEffect];
    [self.view insertSubview:effectView belowSubview:self.searchTextField];
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.searchTextField).with.insets(UIEdgeInsetsMake(0, -10, 0, -10));
    }];
}

- (void)_setMapDefaults {
    [self _setDefaultMapView];
    [self _subscribeForStationChanges];
}

- (void)_setDefaultMapView {
    NSURL *serviceRegionsFileURL = [[NSBundle mainBundle] URLForResource:@"ServiceRegions" withExtension:@"plist"];
    NSDictionary *serviceRegions = [NSDictionary dictionaryWithContentsOfURL:serviceRegionsFileURL];
    NSDictionary *telAviv = [serviceRegions[@"Cities"] firstObject];
    NSString *regionString = telAviv[@"Coordinate region"];
    MKCoordinateRegion region = BCLCoordinateRegionFromString(regionString);
    self.mapView.region = region;
}

- (void)_subscribeForStationChanges {

    // Convert station data into markers
    RAC(self, markers) = [[RACObserve(self.stationsMonitoringService, stations) skip:1] map:^id(NSArray *stations) {
        NSMutableArray *results = [NSMutableArray array];
        for (BCLStation *station in stations) {
            BCLAnnotation *annotation = [[BCLAnnotation alloc] init];
            annotation.title = [NSString stringWithFormat:@"b%tu d%tu %@",station.availableBicycles, station.availableDocks, station.name];
            annotation.subtitle = station.address;
            annotation.coordinate = station.location;
            annotation.station = station;
            [results addObject:annotation];
        }
        return results;
    }];
    
    @weakify(self);
    [[RACObserve(self, markers) skip:1] subscribeNext:^(NSArray *markers) {
        @strongify(self);
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        [self.mapView addAnnotations:markers];
    }];
}

- (UIColor *)_colorForStation:(BCLStation *)station {
    CGFloat ratio = (float)station.availableBicycles / (float)station.capacity;
    if (ratio > 0.5) {
        return [UIColor colorWithRed:0.477 green:0.745 blue:0.327 alpha:1.000];
    } else if (ratio > 0.2) {
        return [UIColor colorWithRed:0.925 green:0.716 blue:0.072 alpha:1.000];
    }
    return [UIColor colorWithRed:0.768 green:0.000 blue:0.031 alpha:1.000];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *const BCLStationAnnotationIdentifier = @"BCLStationAnnotationIdentifier";
    MKPinAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:BCLStationAnnotationIdentifier];
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:BCLStationAnnotationIdentifier];
        annotationView.canShowCallout = YES;
    } else {
        annotationView.annotation = annotation;
    }
//    if ([annotation isKindOfClass:[BCLAnnotation class]]) {
//        annotationView.tintColor = [self _colorForStation:((BCLAnnotation *)annotation).station];
//    }
    return annotationView;
}

@end
