//
//  EditarCorreoViewController.m
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 2/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import "EditarCorreoViewController.h"
#import "MasViewController.h"
#import "CarritoViewController.h"
#import "ActivarCuentaViewController.h"
#import "usuario.h"
#import "XMLController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#define kSITIO_WEB "www.google.com"

#import "tabBViewController.h"

@interface EditarCorreoViewController (){
    int indicador;
}

@end

@implementation EditarCorreoViewController
@synthesize txtCorreo, campoActivo, scrollView, ConexionBD, acumulaDatos, btnVolver, webView, vistaCargando, imgCargando, listaUsuario, Usuario, btnEnviar, lblTitulo, btnTC, imgTitulo;

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
    
    imgTitulo.frame = CGRectMake(0, imgTitulo.frame.origin.y, 320, 35);
    
    ConexionBD = [[bd alloc]init];
    
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
    
    [[self scrollView] setContentSize:[[self view] frame].size];
    
    //Notificaciones del teclado
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(apareceElTeclado:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(desapareceElTeclado:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //Detección de toques en el scroll view
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewPulsado)];
    [tapRecognizer setCancelsTouchesInView:NO];
    [[self scrollView] addGestureRecognizer:tapRecognizer];
    
    NSTimer * temporizador = [NSTimer scheduledTimerWithTimeInterval:2
                                                              target:self
                                                            selector:@selector(temporiza)
                                                            userInfo:nil
                                                             repeats:YES];
    
    [lblTitulo setFont:[UIFont fontWithName:@"Miso" size:16.0]];
    [btnEnviar.titleLabel setFont:[UIFont fontWithName:@"Miso" size:16.0]];
    [btnTC.titleLabel setFont:[UIFont fontWithName:@"Miso" size:13.0]];
    [txtCorreo setFont:[UIFont fontWithName:@"Miso" size:16.0]];
}

-(void)viewWillAppear:(BOOL)animated{
    
    listaUsuario = [ConexionBD consultaUsuario];
    if (listaUsuario.count > 0) {
        Usuario = [listaUsuario objectAtIndex:0];
        txtCorreo.text = Usuario.Correo;
        NSLog(@"USUARIO ID: %@", Usuario.ID);
    }
    
    [super viewWillAppear:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    NSString * tabOpcion = [ConexionBD consultaTabControl];
    if ([tabOpcion isEqualToString:@"Mas"]) {
        MasViewController * destino = [self.storyboard instantiateViewControllerWithIdentifier:@"viewMas"];
        [self addChildViewController:destino];
        [self.view addSubview:destino.view];
        [destino didMoveToParentViewController:self];
    }
    
    if ([tabOpcion isEqualToString:@"Carrito"]) {
        CarritoViewController * destino = [self.storyboard instantiateViewControllerWithIdentifier:@"viewCarrito"];
        [self addChildViewController:destino];
        [self.view addSubview:destino.view];
        [destino didMoveToParentViewController:self];
    }
    
    [super viewWillDisappear:YES];
}

#pragma mark - Métodos de UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setCampoActivo:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setCampoActivo:nil];
}

#pragma mark - Notificaciones del teclado
- (void) apareceElTeclado:(NSNotification *)laNotificacion
{
    NSDictionary *infoNotificacion = [laNotificacion userInfo];
    CGSize tamanioTeclado = [[infoNotificacion objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height, 0);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [scrollView setContentInset:edgeInsets];
    [scrollView setScrollIndicatorInsets:edgeInsets];
    [scrollView scrollRectToVisible:[self campoActivo].frame animated:YES];
}

- (void) desapareceElTeclado:(NSNotification *)laNotificacion
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    [scrollView setContentInset:edgeInsets];
    [scrollView setScrollIndicatorInsets:edgeInsets];
    [UIView commitAnimations];
}

#pragma mark - Métodos de acción adicionales
- (void) scrollViewPulsado
{
    [[self view] endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)enviarTC:(id)sender {
    if (txtCorreo.text.length > 0) {
        
        BOOL conexion = [self estaConectado];
        if (conexion) {
            BOOL stricterFilter = YES;
            NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
            NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
            NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
            
            if ([emailTest evaluateWithObject:txtCorreo.text]) {
                vistaCargando.hidden = NO;
                
                [ConexionBD eliminaOpcionWS];
                [ConexionBD registroOpcionWS:@"EditarDatos"];
                
                if (listaUsuario.count > 0 && ([Usuario.Estado isEqualToString:@"1"] || [Usuario.Estado isEqualToString:@"2"] )) {
                    
                    NSString * token = @"aa28ffad0c2a5d9f39576f7ae53c3fef";
                    
                    NSMutableString * parametros = [[NSMutableString alloc]init];
                    [parametros appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"http://ws.saps.advante.cl/\"><SOAP-ENV:Body><ns1:cambiarCorreo>"];
                    [parametros appendFormat:[NSString stringWithFormat:@"<token>%@</token>",token]];
                    [parametros appendFormat:[NSString stringWithFormat:@"<email>%@</email>", txtCorreo.text]];
                    [parametros appendFormat:@"<idUsuario>%@</idUsuario></ns1:cambiarCorreo></SOAP-ENV:Body></SOAP-ENV:Envelope>", Usuario.ID];
                    
                    NSLog(parametros);
                    
                    NSURL * url = [[NSURL alloc] initWithString:@"http://10.23.18.250:9080/SAPSOmnicanalWSTomcat/AdministrarUsuarios?wsdl"];
                    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
                    [request setHTTPMethod:@"POST"];
                    [request setHTTPBody:[parametros dataUsingEncoding:NSUTF8StringEncoding]];
                    [request addValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
                    NSURLConnection * conexion = [[NSURLConnection alloc]initWithRequest:request delegate:self];
                    acumulaDatos = [[NSMutableData alloc]init];
                } else {
                    //NSString * token = @"aa28ffad0c2a5d9f39576f7ae53c3fef";
                    
                    NSMutableString * parametros = [[NSMutableString alloc]init];
                    [parametros appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"http://ws.saps.advante.cl/\"><SOAP-ENV:Body><ns1:registrarUsuario>"];
                    [parametros appendFormat:[NSString stringWithFormat:@"<tokenSeguridad>aa28ffad0c2a5d9f39576f7ae53c3fef</tokenSeguridad><email>%@</email>",txtCorreo.text]];
                    [parametros appendFormat:[NSString stringWithFormat:@"<token>%@</token><plataforma>iOS</plataforma></ns1:registrarUsuario></SOAP-ENV:Body></SOAP-ENV:Envelope>", [ConexionBD consultaToken]]];
                    //[parametros appendFormat:@"<push_token>%@</push_token></ns1:registrarUsuario></SOAP-ENV:Body></SOAP-ENV:Envelope>", [ConexionBD consultaToken]];
                    NSLog(parametros);
                    
                    NSURL * url = [[NSURL alloc] initWithString:@"http://10.23.18.250:9080/SAPSOmnicanalWSTomcat/AdministrarUsuarios?wsdl"];
                    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
                    [request setHTTPMethod:@"POST"];
                    [request setHTTPBody:[parametros dataUsingEncoding:NSUTF8StringEncoding]];
                    [request addValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
                    NSURLConnection * conexion = [[NSURLConnection alloc]initWithRequest:request delegate:self];
                    acumulaDatos = [[NSMutableData alloc]init];
                }
            } else {
                UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"Verifique el correo electrónico" delegate:self cancelButtonTitle:@"Verificar" otherButtonTitles:nil, nil];
                [alerta show];
            }
        } else {
            UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"No se ha detectado acceso a la red, conéctate a una red de datos e intenta nuevamente" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
            [alerta show];
        }
    } else {
        UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"Verifique el correo electrónico" delegate:self cancelButtonTitle:@"Verificar" otherButtonTitles:nil, nil];
        [alerta show];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Error");
    vistaCargando.hidden = YES;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [acumulaDatos appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    vistaCargando.hidden = YES;
    
    NSString * resultado = [[NSString alloc]initWithData:acumulaDatos encoding:NSUTF8StringEncoding];
    NSLog(@"RESULTADO REGISTRO USUARIO %@", resultado);
    
    int validaError = 0;
    NSMutableString * auxTextError = [[NSMutableString alloc]init];
    @try {
        
        for (int i = 0; i < resultado.length; i++) {
            if ([[resultado substringWithRange:NSMakeRange(i, 5)] isEqualToString:@"ERROR"]) {
                
                for (int k = 0; ![[resultado substringWithRange:NSMakeRange(i + k, 1)]isEqualToString:@"<"]; k++) {
                    [auxTextError appendString:[resultado substringWithRange:NSMakeRange(i + k, 1)]];
                }
                
                validaError = 1;
                break;
            }
        }
        
        
    }
    @catch (NSException *exception) {
        
    }
    
    int validaRegistro = 0;
    
    if (resultado.length != 0 && ![resultado isEqualToString:@"(null)"]) {
        
        if (validaError == 1) {
            UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:auxTextError delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
            [alerta show];
        } else {
            NSMutableString * auxText = [[NSMutableString alloc]init];
            for (int i = 0; i < resultado.length; i++) {
                @try {
                    if ([[resultado substringWithRange:NSMakeRange(i, 8)] isEqualToString:@"<return>"]) {
                        
                        NSLog(@"ENTRO");
                        
                        for (int k = 0; ![[resultado substringWithRange:NSMakeRange(i + 8 + k, 1)]isEqualToString:@"<"]; k++) {
                            [auxText appendString:[resultado substringWithRange:NSMakeRange(i + 8 + k, 1)]];
                            NSLog(@"AUX TEXT: %@", auxText);
                        }
                        
                        NSLog(@"MENSAJE RETURN %@", auxText);
                        if ([auxText isEqualToString:@"Usuario ya registrado en Android"] || [auxText isEqualToString:@"Usuario ya registrado en iOS"]) {
                            validaRegistro = 1;
                            UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:auxText delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                            [alerta show];
                        }
                        
                        break;
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"Error");
                }
            }
            
            if (validaRegistro == 0) {
                NSMutableArray * listaUsuario = [ConexionBD consultaUsuario];
                usuario * Usuario;
                if (listaUsuario.count > 0) {
                    Usuario = [listaUsuario objectAtIndex:0];
                    [ConexionBD actualizaUsuario:txtCorreo.text estado:Usuario.Estado idUsuario:Usuario.ID];
                } else {
                    [ConexionBD registroUsuario:txtCorreo.text estado:@"0" idUsuario:@""];
                }
                //[ConexionBD eliminaUsuario];
                //[ConexionBD registroUsuario:txtCorreo.text estado:@"0" idUsuario:@""];
                XMLController * xmlC = [[XMLController alloc]init];
                [xmlC loadXMLByURL:acumulaDatos opcionWS:@"EditarDatos"];
                listaUsuario = [ConexionBD consultaUsuario];
                Usuario = [listaUsuario objectAtIndex:0];
                NSLog(@"USUARIO ID: %@", Usuario.ID);
                if (![Usuario.ID isEqualToString:@""]) {
                    ActivarCuentaViewController * destino = [self.storyboard instantiateViewControllerWithIdentifier:@"viewActivarCuenta"];
                    [self addChildViewController:destino];
                    [self.view addSubview:destino.view];
                    [destino didMoveToParentViewController:self];
                } else {
                    [ConexionBD eliminaUsuario];
                    UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"Error al registrar" delegate:self cancelButtonTitle:@"Verificar" otherButtonTitles:nil, nil];
                    [alerta show];
                }
            }
        }
    } else {
        vistaCargando.hidden = YES;
        [ConexionBD eliminaUsuario];
        UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"Error al registrar" delegate:self cancelButtonTitle:@"Verificar" otherButtonTitles:nil, nil];
        [alerta show];
    }
    
}

- (IBAction)voverTC:(id)sender {
    btnVolver.hidden = YES;
    webView.hidden = YES;
    imgTitulo.frame = CGRectMake(0, imgTitulo.frame.origin.y, 320, 35);
}

- (IBAction)TC:(id)sender {
    btnVolver.hidden = NO;
    webView.hidden = NO;
    imgTitulo.frame = CGRectMake(btnVolver.frame.size.width * 2, imgTitulo.frame.origin.y, 270, 35);
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
