//
//  MKMapViewZoomLevel.h
//  EffnApp
//
//  Created by Rich DAlfonso on 7/15/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end
