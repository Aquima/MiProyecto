//
//  PosicionamientoController.h
//  Wake Up
//
//  Created by Jonathan Fajardo Roa on 28/03/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "bd.h"

@interface PosicionamientoController : NSObject<CLLocationManagerDelegate, NSURLConnectionDataDelegate>{
    CLLocationManager *locationManager;
}

@property(nonatomic, strong)NSMutableData * acumulaDatos;
@property(nonatomic, strong)bd * ConexionBD;

@property (nonatomic, strong) CLLocationManager *locationManager;

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

@end
