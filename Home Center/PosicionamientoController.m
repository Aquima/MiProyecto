//
//  PosicionamientoController.m
//  Wake Up
//
//  Created by Jonathan Fajardo Roa on 28/03/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import "PosicionamientoController.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation PosicionamientoController
@synthesize locationManager, acumulaDatos, ConexionBD;

- (id) init {
    self = [super init];
    if (self != nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
        [self.locationManager startUpdatingLocation];
    }
    return self;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"iOSLocation: %@", [locations lastObject]);
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    NSLog(@"Location: %@", [newLocation description]);
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", [error description]);
    
    //NSLog([self getIPAddress]);
    
    UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"Es necesario que la aplicacion conozca tu ubicacion para darte los mejores precios" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
    [alerta show];
}

- (NSString *)getIPAddress {
    
    NSString *address = @"error address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    
    /*NSMutableString * parametros = [[NSMutableString alloc]init];
    NSURL * url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.telize.com/geoip/%@",@""]];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[parametros dataUsingEncoding:NSUTF8StringEncoding]];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    NSURLConnection * conexion = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    acumulaDatos = [[NSMutableData alloc]init];*/
    
    return address;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [acumulaDatos appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString * resultado = [[NSString alloc]initWithData:acumulaDatos encoding:NSUTF8StringEncoding];
    NSLog(resultado);
    NSMutableString * ciudad;
    
    /*if([resultado length] > 1){
        NSError *jsonParsingError = nil;
		NSArray * dato = [NSJSONSerialization JSONObjectWithData:acumulaDatos options:0 error:&jsonParsingError];
        
		NSString * status = [dato valueForKey:@"status"];
		if (!jsonParsingError && [status isEqualToString:@"OK"]) {
			NSArray* datoCiudad = [dato valueForKey:@"results"];
			for (NSArray * obj in datoCiudad) {
                NSArray * AuxObj = [obj valueForKey:@"address_components"];
                for (NSArray * componente in AuxObj) {
                    ciudad = [componente valueForKey:@"long_name"];
                    NSArray * tp = [componente valueForKey:@"types"];
                    NSString * tipo = [tp objectAtIndex:0];
                    if ([tipo isEqualToString:@"locality"]) {
                        break;
                    }
                }
                break;
			}
		}
        
        
        [ConexionBD eliminaLocalizacion];
        [ConexionBD registroLocalizacion:ciudad];
        [ConexionBD eliminaVEscanear];
        [ConexionBD registroVEscanear:@"0"];
    }*/
}

@end
