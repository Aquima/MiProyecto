//
//  ViewController.m
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 20/05/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import "ViewController.h"
#import "tabBViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#define kSITIO_WEB "www.google.com"

@interface ViewController (){
    int valida;
    int indicador;
    NSString * latitud;
    NSString * longitud;
    NSMutableString * ciudad;
    int indicadorAux;
    int validaWS;
}

@end

@implementation ViewController
@synthesize imgCargando, acumulaDatos, posicionamientoController, ConexionBD, acumulaDatosWS;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ConexionBD = [[bd alloc]init];
    
    posicionamientoController = [[PosicionamientoController alloc] init];
    [posicionamientoController.locationManager startUpdatingLocation];
    
    NSTimer * temporizador = [NSTimer scheduledTimerWithTimeInterval:2
                                                              target:self
                                                            selector:@selector(temporiza)
                                                            userInfo:nil
                                                             repeats:YES];
}

-(void)temporiza{
    
    indicador++;
    
    if (indicador == 1) {
        imgCargando.image = [UIImage imageNamed:@"cargador01.png"];
    }
    
    if (indicador == 2) {
        imgCargando.image = [UIImage imageNamed:@"cargador02.png"];
    }
    
    if (indicador == 3) {
        imgCargando.image = [UIImage imageNamed:@"cargador03.png"];
        indicador = 0;
    }
    
    latitud = [NSString stringWithFormat:@"%f", posicionamientoController.locationManager.location.coordinate.latitude];
    longitud = [NSString stringWithFormat:@"%f", posicionamientoController.locationManager.location.coordinate.longitude];
    
    NSLog(@"Latitud %@", latitud);
    NSLog(@"Longitud %@", longitud);
    
    if (![latitud isEqualToString:@"0.000000"] && valida == 0 && indicador == 0) {
        BOOL conexion = [self estaConectado];
        if (conexion) {
            valida++;
            NSLog(@"Latitud %@", latitud);
            NSLog(@"Longitud %@", longitud);
            NSMutableString * parametros = [[NSMutableString alloc]init];
            NSURL * url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&sensor=true",latitud, longitud]];
            NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
            [request setHTTPMethod:@"GET"];
            [request setHTTPBody:[parametros dataUsingEncoding:NSUTF8StringEncoding]];
            [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
            NSURLConnection * conexion = [[NSURLConnection alloc]initWithRequest:request delegate:self];
            acumulaDatos = [[NSMutableData alloc]init];

            NSMutableString * parametrosWS = [[NSMutableString alloc]init];
            [parametrosWS appendFormat:[NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.saps.advante.cl/\"><soapenv:Header/><soapenv:Body><ws:Localizacion><token>aa28ffad0c2a5d9f39576f7ae53c3fef</token><Lat>%@</Lat><Lon>%@</Lon></ws:Localizacion></soapenv:Body></soapenv:Envelope>", latitud, longitud]];
            
            NSLog(@"Datos de envio WS");
            NSLog(parametrosWS);
            
            NSURL * urlWS = [[NSURL alloc] initWithString:@"http://10.23.18.250:9080/SAPSOmnicanalWSTomcat/ParametrosGenerales?wsdl"];
            NSMutableURLRequest * requestWS = [[NSMutableURLRequest alloc]initWithURL:urlWS];
            [requestWS setHTTPMethod:@"POST"];
            [requestWS setHTTPBody:[parametrosWS dataUsingEncoding:NSUTF8StringEncoding]];
            [requestWS addValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
            NSURLConnection * conexionWS = [[NSURLConnection alloc]initWithRequest:requestWS delegate:self];
            acumulaDatosWS = [[NSMutableData alloc]init];
        } else {
            UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"No se ha detectado acceso a la red, conéctate a una red de datos e intenta nuevamente" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
            [alerta show];
        }
    }
    
    if (valida == 0 && indicadorAux >= 9 && validaWS == 1) {
        valida++;
        [ConexionBD eliminaLocalizacion];
        [ConexionBD registroLocalizacion:@"bogota"];
        [ConexionBD eliminaVEscanear];
        [ConexionBD registroVEscanear:@"0"];
        [posicionamientoController.locationManager stopUpdatingLocation];
        tabBViewController * destino = [self.storyboard instantiateViewControllerWithIdentifier:@"vieTabController"];
        destino.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:destino animated:YES completion:NULL];
    }
    
    indicadorAux++;
}

-(BOOL) estaConectado {
    
    SCNetworkReachabilityRef referencia = SCNetworkReachabilityCreateWithName (kCFAllocatorDefault, kSITIO_WEB);
    
    SCNetworkReachabilityFlags resultado;
    SCNetworkReachabilityGetFlags ( referencia, &resultado );
    
    CFRelease(referencia);
    
    if (resultado & kSCNetworkReachabilityFlagsReachable) {
        
        return TRUE;
    }
    
    return FALSE;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    valida = 0;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    @try {
        [acumulaDatos appendData:data];
    }
    @catch (NSException *exception) {
        NSLog(@"Error en la acumulación de datos");
    }
    
    @try {
        [acumulaDatosWS appendData:data];
    }
    @catch (NSException *exception) {
        NSLog(@"Error en la acumulación de datos WS");
    }
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString * resultado = [[NSString alloc]initWithData:acumulaDatos encoding:NSUTF8StringEncoding];
    if([resultado length] > 1){
        NSError *jsonParsingError = nil;
		NSArray * dato = [NSJSONSerialization JSONObjectWithData:acumulaDatos options:0 error:&jsonParsingError];
        
		NSString * status = [dato valueForKey:@"status"];
		if (!jsonParsingError && [status isEqualToString:@"OK"]) {
			NSArray* datoCiudad = [dato valueForKey:@"results"];
			for (NSArray * obj in datoCiudad) {
                NSArray * AuxObj = [obj valueForKey:@"address_components"];
                for (NSArray * componente in AuxObj) {
                    
                    
                    NSString *str = [componente valueForKey:@"long_name"];
                    NSString * str1 = [str uppercaseString];
                    NSData * data = [str1 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                    ciudad = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];//[componente valueForKey:@"long_name"];
                    
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
        [posicionamientoController.locationManager stopUpdatingLocation];
        tabBViewController * destino = [self.storyboard instantiateViewControllerWithIdentifier:@"vieTabController"];
        destino.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:destino animated:YES completion:NULL];
        NSLog(ciudad);
        
        
        
        NSString * resultadoWS = [[NSString alloc]initWithData:acumulaDatosWS encoding:NSUTF8StringEncoding];
        if([resultadoWS length] > 1){
            NSMutableString * auxTextWS = [[NSMutableString alloc]init];
            for (int i = 0; i < resultado.length; i++) {
                @try {
                    if ([[resultado substringWithRange:NSMakeRange(i, 8)] isEqualToString:@"<return>"]) {
                        for (int k = 0; ![[resultado substringWithRange:NSMakeRange(i + 8 + k, 1)]isEqualToString:@"<"]; k++) {
                            [auxTextWS appendString:[resultado substringWithRange:NSMakeRange(i + 8 + k, 1)]];
                        }
                        if ([auxTextWS isEqualToString:@"OK"]) {
                            validaWS = 1;
                        } else {
                            UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:auxTextWS delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                        //    [alerta show];
                        }
                        break;
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"Error");
                }
            }
            
            
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        UIApplication * application = [UIApplication sharedApplication];
        [application performSelector:@selector(suspend)];
        exit(0);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
