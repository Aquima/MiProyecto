//
//  InspirateViewController.m
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 1/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import "InspirateViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#define kSITIO_WEB "www.google.com"

@interface InspirateViewController ()

@end

@implementation InspirateViewController
@synthesize webView, ConexionBD, Producto;

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
    
    BOOL conexion = [self estaConectado];
    if (conexion) {
        ConexionBD = [[bd alloc]init];
        NSMutableArray * arrayProducto = [ConexionBD consultaProductoTEMP];
        NSLog(@"CANTIDAD DE PRODUCTOS %d" , arrayProducto.count);
        Producto = [arrayProducto objectAtIndex:0];
        NSString * rutaUrl = Producto.inspirate;
        NSLog(@"INSPIRATE %@", Producto.inspirate);
        NSURL * url = [[NSURL alloc] initWithString:rutaUrl];
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        [webView loadRequest:request];
    } else {
        UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"No se ha detectado acceso a la red, conéctate a una red de datos e intenta nuevamente" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [alerta show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cerrar:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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

@end
