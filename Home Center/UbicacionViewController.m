//
//  UbicacionViewController.m
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 28/07/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import "UbicacionViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#define kSITIO_WEB "www.google.com"

@interface UbicacionViewController (){
    int indicador;
}

@end

@implementation UbicacionViewController
@synthesize webView, vistaCargando, imgCargando;

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
    
    NSTimer * temporizador = [NSTimer scheduledTimerWithTimeInterval:2
                                                              target:self
                                                            selector:@selector(temporiza)
                                                            userInfo:nil
                                                             repeats:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    BOOL conexion = [self estaConectado];
    if (conexion) {
        NSMutableURLRequest * request1 = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"https://movil.homecenter.co/SptiHomeCenterMovil/catalogo/selecTienda.jsp"]];
        [webView loadRequest:request1];
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
    
    if (webView.loading){
        vistaCargando.hidden = NO;
    } else {
        vistaCargando.hidden = YES;
    }
    
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
