//
//  ActivarCuentaViewController.m
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 2/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import "ActivarCuentaViewController.h"
#import "usuario.h"
#import "MasViewController.h"
#import "CarritoViewController.h"
#import "XMLController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#define kSITIO_WEB "www.google.com"
#import "EditarCorreoViewController.h"

@interface ActivarCuentaViewController (){
    int indicador;
}

@end

@implementation ActivarCuentaViewController
@synthesize scrollView, ConexionBD, acumulaDatos, vistaCargando, imgCargando, listaUsuario, Usuario, webView1, webView2, webView3, lblTitulo, btnActivar, btnReenviar;

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
    
    [[self scrollView] setContentSize:[[self view] frame].size];
    
    NSTimer * temporizador = [NSTimer scheduledTimerWithTimeInterval:2
                                                              target:self
                                                            selector:@selector(temporiza)
                                                            userInfo:nil
                                                             repeats:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    listaUsuario = [ConexionBD consultaUsuario];
    Usuario = [listaUsuario objectAtIndex:0];
    
    NSMutableString * strT1 = [[NSMutableString alloc]init];
    [strT1 appendString:@"<html><body><label style='color:#FF0000; font-size:14px; font-family:Miso-Light;'>1.</label><label style='color:#858585; font-size:14px; font-family:Miso-Light'> Hemos enviado un correo a "];
    [strT1 appendString:Usuario.Correo];
    [strT1 appendString:@", revisa tu correo electrónico y sigue las instrucciones. Si no ves el correo electrónico, revisa otros lugares donde podría estar, como tus carpetas de correo no deseado, sociales u otras.</laber></body></html>"];

    //lblT1.text = strT1;
    [webView1 loadHTMLString:strT1 baseURL:nil];
    
    NSMutableString * strT2 = [[NSMutableString alloc]init];
    [strT2 appendString:@"<html><body><label style='color:#FF0000; font-size:14px; font-family:Miso-Light'>2. </label><label style='color:#858585; font-size:14px; font-family:Miso-Light'>Ya recibí el correo y seguí las instrucciones enviadas.</br>Presiona el siguiente botón para continuar.</laber></body></html>"];
    
    //lblT1.text = strT1;
    [webView2 loadHTMLString:strT2 baseURL:nil];
    
    NSMutableString * strT3 = [[NSMutableString alloc]init];
    [strT3 appendString:@"<html><body><label style='color:#FF0000; font-size:14px; font-family:Miso-Light'>3. </label><label style='color:#858585; font-size:14px; font-family:Miso-Light'>No he recibido el correo</laber></body></html>"];
    
    //lblT1.text = strT1;
    [webView3 loadHTMLString:strT3 baseURL:nil];
    
    [self.lblTitulo setFont:[UIFont fontWithName:@"Miso-Bold" size:20.0]];
    [btnReenviar.titleLabel setFont:[UIFont fontWithName:@"Miso" size:13.0]];
    [btnActivar.titleLabel setFont:[UIFont fontWithName:@"Miso" size:13.0]];
    
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)activadoCuenta:(id)sender {
    //if (txtCorreo.text.length > 0) {
        BOOL conexion = [self estaConectado];
        if (conexion) {
            vistaCargando.hidden = NO;
            
            [ConexionBD eliminaOpcionWS];
            [ConexionBD registroOpcionWS:@"ActivaCuenta"];
            
            NSString * token = @"aa28ffad0c2a5d9f39576f7ae53c3fef";
            
            
            NSMutableString * parametros = [[NSMutableString alloc]init];
            [parametros appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"http://ws.saps.advante.cl/\"><SOAP-ENV:Body><ns1:isActivo>"];
            [parametros appendFormat:[NSString stringWithFormat:@"<token>%@</token>",token]];
            [parametros appendFormat:[NSString stringWithFormat:@"<idUsuario>%@</idUsuario></ns1:isActivo></SOAP-ENV:Body></SOAP-ENV:Envelope>", Usuario.ID]];
            
            NSLog(parametros);
            
            NSURL * url = [[NSURL alloc] initWithString:@"http://10.23.18.250:9080/SAPSOmnicanalWSTomcat/AdministrarUsuarios?wsdl"];
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
    /*} else {
        UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"Verifique el correo electrónico" delegate:self cancelButtonTitle:@"Verificar" otherButtonTitles:nil, nil];
        [alerta show];
    }*/
}
- (IBAction)reenviarCorreo:(id)sender {
    
    EditarCorreoViewController * destino = [self.storyboard instantiateViewControllerWithIdentifier:@"viewEditarCorreo"];
    [self addChildViewController:destino];
    [self.view addSubview:destino.view];
    [destino didMoveToParentViewController:self];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Error");
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [acumulaDatos appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSString * resultado = [[NSString alloc]initWithData:acumulaDatos encoding:NSUTF8StringEncoding];
    NSLog(@"RESULTADO ACTIVA CUENTA %@",resultado);
    XMLController * xmlC = [[XMLController alloc]init];
    
    NSString * opcionWS = [ConexionBD consultaOpcionWS];
    if ([opcionWS isEqualToString:@"ActivaCuenta"]) {
        [xmlC loadXMLByURL:acumulaDatos opcionWS:@"ActivarUsuario"];
        NSMutableArray * listaUsuario = [ConexionBD consultaUsuario];
        usuario * Usuario = [listaUsuario objectAtIndex:0];
        
        if ([Usuario.Estado isEqualToString:@"1"]) {
            NSString * tabOpcion = [ConexionBD consultaTabControl];
            if ([tabOpcion isEqualToString:@"Mas"]) {
                MasViewController * destino = [self.storyboard instantiateViewControllerWithIdentifier:@"viewMas"];
                [self addChildViewController:destino];
                [self.view addSubview:destino.view];
                [destino didMoveToParentViewController:self];
            }
            
            if ([tabOpcion isEqualToString:@"Carrito"]) {
                CarritoViewController * destino = [self.storyboard instantiateViewControllerWithIdentifier:@"viewCarrito"];
                
                [ConexionBD eliminaNotificacion];
                [ConexionBD registroNotificacion:@"SI"];
                
                [self addChildViewController:destino];
                [self.view addSubview:destino.view];
                [destino didMoveToParentViewController:self];
            }
        } else {
            UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"Para activar tu cuenta revisa tu correo electrónico y sigue las instrucciones" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
            [alerta show];
        }
    }
    
    vistaCargando.hidden = YES;
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
