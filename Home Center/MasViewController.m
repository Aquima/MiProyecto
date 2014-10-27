//
//  MasViewController.m
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 2/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import "MasViewController.h"
#import "EditarCorreoViewController.h"
#import "ayudas.h"
#import "VideoViewController.h"
#import "PedidosViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#define kSITIO_WEB "www.google.com"

@interface MasViewController ()

@end

@implementation MasViewController
@synthesize ConexionBD, webView, btnVolver, ayuda, ayuda2, ayuda1, ayuda3, ayuda4, lblOpciones, btnEditarCorre, btnMisCompras, btnVerTC, btnVerVideo, acumulaDatos, imgTitulo, ayuda5;

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
    
    NSMutableArray * listaAyudas = [ConexionBD consultaAyuda];
    ayudas * Ayudas = [listaAyudas objectAtIndex:0];
    if ([Ayudas.Mas isEqualToString:@"0"]) {
        [ayuda setUserInteractionEnabled:YES];
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
        [singleTap setNumberOfTapsRequired:1];
        [ayuda addGestureRecognizer:singleTap];
    } else {
        ayuda.hidden = YES;
        ayuda1.hidden = YES;
        ayuda2.hidden = YES;
        ayuda3.hidden = YES;
        ayuda4.hidden = YES;
        ayuda5.hidden = YES;
    }
    
    [btnVerVideo.titleLabel setFont:[UIFont fontWithName:@"Miso" size:16.0]];
    [btnMisCompras.titleLabel setFont:[UIFont fontWithName:@"Miso" size:16.0]];
    [btnEditarCorre.titleLabel setFont:[UIFont fontWithName:@"Miso" size:16.0]];
    [btnVerTC.titleLabel setFont:[UIFont fontWithName:@"Miso" size:16.0]];
    [lblOpciones setFont:[UIFont fontWithName:@"Miso" size:16.0]];
    
    /*NSString * rutaUrl = @"http://10.23.18.250:9080/docs/terminos.pdf";
    NSLog(rutaUrl);
    NSURL * url = [[NSURL alloc] initWithString:rutaUrl];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
    [webView loadRequest:request];*/
}

-(void)singleTapping:(UIGestureRecognizer *)recognizer
{
    ayuda.hidden = YES;
    ayuda1.hidden = YES;
    ayuda2.hidden = YES;
    ayuda3.hidden = YES;
    ayuda4.hidden = YES;
    ayuda5.hidden = YES;
    NSMutableArray * listaAyudas = [ConexionBD consultaAyuda];
    ayudas * Ayudas = [listaAyudas objectAtIndex:0];
    [ConexionBD actualizaAyuda:Ayudas.Menu productoEncontrado:Ayudas.ProductoEncontrado carrito:Ayudas.Carrito cotizaciones:Ayudas.Cotizaciones mas:@"1"];
}

-(void)viewWillAppear:(BOOL)animated{
    imgTitulo.frame = CGRectMake(0, imgTitulo.frame.origin.y, 320, 35);
    
    if (self.view.subviews.count == 16) {
        for (int i = 15; i < [[self.view subviews] count]; i++ ) {
            [[[self.view subviews] objectAtIndex:i] removeFromSuperview];
        }
        NSLog(@"REMOVIO EN VENTANA MAS");
    }
    
    BOOL conexion = [self estaConectado];
    if (conexion) {
        NSString * rutaUrl = @"http://10.23.18.250:9080/docs/terminos.pdf";
        NSLog(rutaUrl);
        NSURL * url = [[NSURL alloc] initWithString:rutaUrl];
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
        [webView loadRequest:request];
    } else {
        UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"No se ha detectado acceso a la red, conéctate a una red de datos e intenta nuevamente" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [alerta show];
    }
    
    webView.hidden = YES;
    btnVolver.hidden = YES;
    NSMutableArray * lista = [ConexionBD consultaCarrito];
    NSLog(@"%d", [lista count]);
    [[[[[self tabBarController]tabBar]items]objectAtIndex:1]setBadgeValue:[NSString stringWithFormat:@"%d", lista.count]];
    
    @try {
        if ([[ConexionBD consultaNotificacion] isEqualToString:@"Mis Compras"]) {
            [ConexionBD eliminaNotificacion];
            PedidosViewController * destino = [self.storyboard instantiateViewControllerWithIdentifier:@"viewPedidos"];
            [self addChildViewController:destino];
            [self.view addSubview:destino.view];
            [destino didMoveToParentViewController:self];
        }
    }
    @catch (NSException *exception) {
        
    }
    
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)editarCorreo:(id)sender {
    NSString * opcionTab = [ConexionBD consultaTabControl];
    if (![opcionTab isEqualToString:@"Carrito"]) {
        [ConexionBD eliminaTabControl];
        [ConexionBD registroTabControl:@"Mas"];
    }
    EditarCorreoViewController * destino = [self.storyboard instantiateViewControllerWithIdentifier:@"viewEditarCorreo"];
    [self addChildViewController:destino];
    [self.view addSubview:destino.view];
    [destino didMoveToParentViewController:self];
}
- (IBAction)irVideo:(id)sender {
    [ConexionBD eliminaVideo];
    [ConexionBD registroVideo:@"2"];
    VideoViewController * destino = [self.storyboard instantiateViewControllerWithIdentifier:@"viewVideo"];
    destino.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:destino animated:YES completion:NULL];
}

- (IBAction)irTerminosCondiciones:(id)sender {
    webView.hidden = NO;
    btnVolver.hidden = NO;
    imgTitulo.frame = CGRectMake(btnVolver.frame.size.width * 2, imgTitulo.frame.origin.y, 270, 35);
}

- (IBAction)volverTerminosCondiciones:(id)sender {
    webView.hidden = YES;
    btnVolver.hidden = YES;
    imgTitulo.frame = CGRectMake(0, imgTitulo.frame.origin.y, 320, 35);
}

- (IBAction)btnMisCompras:(id)sender {
    PedidosViewController * destino = [self.storyboard instantiateViewControllerWithIdentifier:@"viewPedidos"];
    [self addChildViewController:destino];
    [self.view addSubview:destino.view];
    [destino didMoveToParentViewController:self];
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

- (IBAction)encuesta:(id)sender {
    BOOL conexion = [self estaConectado];
    if (conexion) {
        NSMutableString * parametros = [[NSMutableString alloc]init];
        [parametros appendFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.saps.advante.cl/\"><soapenv:Header/><soapenv:Body><ws:GetParametros><token>aa28ffad0c2a5d9f39576f7ae53c3fef</token><Parametro>Encuesta</Parametro></ws:GetParametros></soapenv:Body></soapenv:Envelope>"];
        
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
                        if ([[resultado substringWithRange:NSMakeRange(i + 8 + k, 1)]isEqualToString:@"&"]) {
                            k = k + 4;
                        }

                        NSLog(@"AUX TEXT: %@", auxText);
                    }
                    
                    NSLog(@"ENCUESTA %@", auxText);
                    
                    NSURL * url = [NSURL URLWithString:auxText];
                    [[UIApplication sharedApplication] openURL:url];
                    
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
