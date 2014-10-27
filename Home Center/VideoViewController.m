//
//  VideoViewController.m
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 3/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import "VideoViewController.h"
#import "ViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#define kSITIO_WEB "www.google.com"

@interface VideoViewController ()

@end

@implementation VideoViewController
@synthesize webView, ConexionBD, acumulaDatos;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ConexionBD = [[bd alloc]init];
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortrait;
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

-(void)viewDidAppear:(BOOL)animated{
    
    if ([[ConexionBD consultaVideo] isEqualToString:@"1"]) {
        NSLog(@"VIDEO 1");
        ViewController * destino = [self.storyboard instantiateViewControllerWithIdentifier:@"viewCargando"];
        destino.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:destino animated:YES completion:NULL];
    } else {
        BOOL conexion = [self estaConectado];
        if (conexion) {
            NSMutableString * parametros = [[NSMutableString alloc]init];
            //[parametros appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"http://ws.saps.advante.cl/\"><SOAP-ENV:Body><ns1:ParametrosGenerales><Parametro>VideoTutorial</Parametro></ns1:ParametrosGenerales></SOAP-ENV:Body></SOAP-ENV:Envelope>"];
            [parametros appendFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.saps.advante.cl/\"><soapenv:Header/><soapenv:Body><ws:GetParametros><token>aa28ffad0c2a5d9f39576f7ae53c3fef</token><Parametro>VideoTutorial</Parametro></ws:GetParametros></soapenv:Body></soapenv:Envelope>"];
            
            NSLog(@"Datos de envio");
            NSLog(parametros);
            
            NSURL * url = [[NSURL alloc] initWithString:@"http://10.23.18.250:9080/SAPSOmnicanalWSTomcat/ParametrosGenerales?wsdl"];
            NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[parametros dataUsingEncoding:NSUTF8StringEncoding]];
            [request addValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
            NSURLConnection * conexion = [[NSURLConnection alloc]initWithRequest:request delegate:self];
            acumulaDatos = [[NSMutableData alloc]init];
        } else {
            UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"No se ha detectado acceso a la red, conéctate a una red de datos e intenta nuevamente" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
            [alerta show];
        }
    }
    
    [super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saltarVideo:(id)sender {
    if ([ConexionBD consultaVideo].length == 0) {
        [ConexionBD registroVideo:@"1"];
        ViewController * destino = [self.storyboard instantiateViewControllerWithIdentifier:@"viewCargando"];
        destino.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:destino animated:YES completion:NULL];
    } else {
        [ConexionBD eliminaVideo];
        [ConexionBD registroVideo:@"1"];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Error de conexión");
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"Descargando datos");
    [acumulaDatos appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString * resultado = [[NSString alloc]initWithData:acumulaDatos encoding:NSUTF8StringEncoding];
    NSLog(@"Datos recibidos");
    NSLog(resultado);
    if([resultado length] > 1){
        NSMutableString * auxText = [[NSMutableString alloc]init];
        for (int i = 0; i < resultado.length; i++) {
            @try {
                if ([[resultado substringWithRange:NSMakeRange(i, 8)] isEqualToString:@"<return>"]) {
                    
                    NSLog(@"ENTRO");
                    
                    for (int k = 0; ![[resultado substringWithRange:NSMakeRange(i + 8 + k, 1)]isEqualToString:@"<"]; k++) {
                        [auxText appendString:[resultado substringWithRange:NSMakeRange(i + 8 + k, 1)]];
                        NSLog(@"AUX TEXT: %@", auxText);
                    }
                    
                    NSLog(@"VIDEO %@", auxText);
                    
                    //NSURL * url = [[NSURL alloc] initWithString:@"https://www.youtube.com/embed/7BMcfzRF6VQ?rel=0"];
                    NSURL * url = [[NSURL alloc] initWithString:auxText];
                    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
                    [request setHTTPMethod:@"POST"];
                    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
                    [webView loadRequest:request];
                    
                    break;
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Error");
            }
        }
        
        
    }
}

@end
