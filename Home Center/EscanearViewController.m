//
//  EscanearViewController.m
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 31/05/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import "EscanearViewController.h"
#import "ProductoEncontradoViewController.h"
#import "CarritoViewController.h"
#import "XMLController.h"
#import "QRViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#define kSITIO_WEB "www.google.com"
#import "ayudas.h"

@interface EscanearViewController (){
    int indicador;
    int opcionXML;
    BOOL consultaWeb;
    int webV;
    int i;
}

@end

@implementation EscanearViewController
@synthesize imgScan, txtSKU, btnConsultarSKU, campoActivo, scrollView, ConexionBD, imgTitulo, ProductoEncontrado, Producto, destino, Cargando, acumulaDatos, imgCargando, vistaCargando, webView, btnVolver, ayuda2, ayuda1, request, lblScan;

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
    
    if (!ayuda1.hidden) {
        self.codeDetected = YES;
    }
    
    [self.lblScan setFont:[UIFont fontWithName:@"Miso" size:20.0]];
    [self.txtSKU setFont:[UIFont fontWithName:@"Miso" size:20.0]];
    
    ConexionBD = [[bd alloc]init];
    NSMutableArray * listaAyuda = [ConexionBD consultaAyuda];
    if (listaAyuda.count > 0) {
        ayuda1.hidden = YES;
        ayuda2.hidden = YES;
    } else {
        [ConexionBD registroAyuda:@"0" productoEncontrado:@"0" carrito:@"0" cotizaciones:@"0" mas:@"0"];
        
        
        [ayuda1 setUserInteractionEnabled:YES];
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
        [singleTap setNumberOfTapsRequired:1];
        [ayuda1 addGestureRecognizer:singleTap];
        
        ayuda2.frame = CGRectMake(ayuda2.frame.origin.x, [self.view frame].size.height - 50 - ayuda2.frame.size.height, ayuda2.frame.size.width, ayuda2.frame.size.height);
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
    @try {
        [self setupCamera];
    }
    @catch (NSException *exception) {
        
    }
    
}

-(void)singleTapping:(UIGestureRecognizer *)recognizer
{
    ayuda1.hidden = YES;
    ayuda2.hidden = YES;
    self.codeDetected = NO;
    //[ConexionBD registroAyuda:@"1" productoEncontrado:@"0" carrito:@"0" cotizaciones:@"0" mas:@"0"];
    NSMutableArray * listaAyuda = [ConexionBD consultaAyuda];
    ayudas * Ayuda = [listaAyuda objectAtIndex:0];
    [ConexionBD actualizaAyuda:@"1" productoEncontrado:Ayuda.ProductoEncontrado carrito:Ayuda.Carrito cotizaciones:Ayuda.Cotizaciones mas:Ayuda.Mas];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSLog(@"DID APPEAR");
}

-(void)viewWillAppear:(BOOL)animated{
    
    ConexionBD = [[bd alloc]init];
    
    
    NSLog(@"VIEW WILL APPEAR ESCAN");
    
    i = 0;
    
    imgTitulo.frame = CGRectMake(0, imgTitulo.frame.origin.y, 320, 35);
    
    if (self.view.subviews.count == 2 && ![[ConexionBD consultaTabControl] isEqualToString:@"inspirate"]) {
        for (int i = 1; i < [[self.view subviews] count]; i++ ) {
            [[[self.view subviews] objectAtIndex:i] removeFromSuperview];
        }
        NSLog(@"REMOVIO");
    }

    webView.hidden = YES;
    btnVolver.hidden = YES;
    webV = 0;
    [ConexionBD eliminaTabControl];
    [ConexionBD registroTabControl:@"Escanear"];
    
    Cargando.hidden = YES;
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
    
    NSMutableArray * lista = [ConexionBD consultaCarrito];
    NSLog(@"%d", [lista count]);
    [[[[[self tabBarController]tabBar]items]objectAtIndex:1]setBadgeValue:[NSString stringWithFormat:@"%d", lista.count]];
    
    
    vistaCargando.hidden = YES;
    txtSKU.text = @"";
    
    if (!ayuda1.hidden) {
        self.codeDetected = YES;
        NSLog(@"CODIGO SI");
    } else {
        NSLog(@"CODIGO NO");
        self.codeDetected = NO;
    }
    
    @try {
        if (!self.session.isRunning) {
            [self.session startRunning];
        }
    }
    @catch (NSException *exception) {
        
    }
    [super viewWillAppear:YES];
    
}

- (void)setupCamera
{
    // Inicializamos la sesión de captura de video
    self.session = [[AVCaptureSession alloc] init];
    
    // Configuramos como dispositivo la cámara de video
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Configuramos como dispositivo de entrada la cámara recien inicializada
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    [self.session addInput:self.input];
    
    // Configuramos como salida la captura de metadatos (para lectura de códigos)
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.session addOutput:self.output];
    
    // Configuramos como tipos de código a detectar, todos los disponibles
    // Es posible unicamente recoger códigos de unos tipos determinados
    self.output.metadataObjectTypes = [self.output availableMetadataObjectTypes];
    
    // Inicializamos una capa de previsualización para poder ver lo que la
    // cámara de video captura
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = [self.view frame];
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Lanzamos la sesión de cámara
    [self.session startRunning];
    
    NSLog(@"STAR RUNNING");
    
}

- (BOOL)isValidUrl:(NSString *)urlString{
    NSLog(@"URL %@", urlString);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    return [NSURLConnection canHandleRequest:request];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    // Éste método se ejecuta cada vez que se detecta algún código de los
    // tipos indicados
    
    // Comprobamos que no hayamos detectado un código ya
    if (!self.codeDetected) {
        self.codeDetected = YES;
        
            // Recorremos los metadatos obtenidos
        NSLog(@"CANTIDAD OBJETOS %d",metadataObjects.count);
        if (metadataObjects.count == 1) {
            
            
            for (AVMetadataObject *metadata in metadataObjects) {
                
                NSLog(@"Tipo de codigo %@", metadata.type);
                if (![metadata.type isEqualToString:@"face"]) {
                    NSLog(@"Entro barcde");
                    @try {
                        // Recuperamos el valor textual del código de barras o QR
                        NSString *code =[(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                        
                        // Si el código no esta vacío
                        if (![code isEqualToString:@""]) {
                            
                            // Marcamos nuestro flag de detección a YES
                            self.codeDetected = YES;
                            
                            // Mostramos al usuario un alert con los datos del tipo de código y valor
                            // detectado en nuestra sesión
                            //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Código detectado" message:[NSString stringWithFormat:@"Tipo %@ \n  Codigo %@",metadata.type,code] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                            //[alert show];
                            
                            if ([metadata.type isEqualToString:@"org.iso.QRCode"]) {
                                if (self.codeDetected) {
                                    vistaCargando.hidden = NO;
                                    
                                    NSData *stringData = [code dataUsingEncoding: NSASCIIStringEncoding allowLossyConversion: YES];
                                    NSString * cleanString = [[NSString alloc] initWithData: stringData encoding: NSASCIIStringEncoding];
                                    
                                    if ([self isValidUrl:cleanString]) {
                                        NSLog(@"VALIDA: %@", cleanString);
                                        webV = 1;
                                        NSMutableURLRequest * request1 = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:cleanString]];
                                        [webView loadRequest:request1];
                                        
                                        
                                        imgTitulo.frame = CGRectMake(btnVolver.frame.size.width * 2, imgTitulo.frame.origin.y, 270, 35);
                                    } else {
                                        NSLog(@"URL NO VALIDA");
                                        vistaCargando.hidden = YES;
                                        webV = 0;
                                        self.codeDetected = NO;
                                        imgTitulo.frame = CGRectMake(0, imgTitulo.frame.origin.y, 320, 35);
                                    }
                                }
                                
                            } else {
                                if ([ConexionBD consultaLocalizacion].length != 0) {
                                    
                                    BOOL conexion = [self estaConectado];
                                    if (conexion) {
                                        consultaWeb = NO;
                                        Cargando.hidden = NO;
                                        vistaCargando.hidden = NO;
                                        self.codeDetected = YES;
                                        
                                        [ConexionBD eliminaOpcionWS];
                                        [ConexionBD eliminaProducto];
                                        [ConexionBD registroOpcionWS:@"consultarProductoCB"];
                                        [ConexionBD registroProducto:code nombre:@"" inspirate:@"" precio:@"0" cant:@"0" ficha:@""];
                                        
                                        opcionXML = 1;
                                        NSString * token = @"aa28ffad0c2a5d9f39576f7ae53c3fef";
                                        NSString * ciudad = [ConexionBD consultaLocalizacion];
                                        
                                        
                                        NSMutableString * parametros = [[NSMutableString alloc]init];
                                        [parametros appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"http://ws.saps.advante.cl/\"><SOAP-ENV:Body><ns1:consultarProductoCB>"];
                                        [parametros appendFormat:[NSString stringWithFormat:@"<token>%@</token>",token]];
                                        [parametros appendFormat:[NSString stringWithFormat:@"<cb>%@</cb>",code]];
                                        [parametros appendFormat:[NSString stringWithFormat:@"<ciudad>%@</ciudad></ns1:consultarProductoCB></SOAP-ENV:Body></SOAP-ENV:Envelope>", ciudad]];
                                        
                                        NSLog(parametros);
                                        
                                        NSURL * url = [[NSURL alloc] initWithString:@"http://10.23.18.250:9080/SAPSOmnicanalWSTomcat/ConsultarProducto?wsdl"];
                                        NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
                                        [request setHTTPMethod:@"POST"];
                                        [request setHTTPBody:[parametros dataUsingEncoding:NSUTF8StringEncoding]];
                                        [request addValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
                                        NSURLConnection * conexion = [[NSURLConnection alloc]initWithRequest:request delegate:self];
                                        acumulaDatos = [[NSMutableData alloc]init];
                                        NSLog(@"VECES %d", i);
                                        i++;
                                    } else {
                                        UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"No se ha detectado acceso a la red, conéctate a una red de datos e intenta nuevamente" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                                        [alerta show];
                                    }
                                    
                                } else {
                                    UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"No se puede establecer tu ubicación" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                                    [alerta show];
                                }
                            }
                            break;
                        }
                    }
                    @catch (NSException *exception) {
                        NSLog(@"%@", exception.reason);
                        self.codeDetected = NO;
                    }
                } else {
                    self.codeDetected = NO;
                }
            }
        } else {
            self.codeDetected = NO;
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        self.codeDetected = NO;
    }
}

-(void)temporiza{
    
    @try {
        if ([[ConexionBD consultaNotificacion] isEqualToString:@"Mis Compras"]) {
            self.tabBarController.selectedIndex = 4;
            NSLog(@"CONSULTA NOTIFICACION %@",[ConexionBD consultaNotificacion]);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Error no es MIS COMPRAS");;
    }
    
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
    
    if (webView.loading && webV == 1){
        vistaCargando.hidden = NO;
    } else {
        if (webV != 0) {
            vistaCargando.hidden = YES;
            webView.hidden = NO;
            btnVolver.hidden = NO;
            webV = 0;
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    @try {
        [self.session stopRunning];
    }
    @catch (NSException *exception) {
        
    }
    
    
    NSLog(@"WILL DISAPPEAR ESCANEAR");
    vistaCargando.hidden = YES;
    
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

- (IBAction)consultarSKU:(id)sender {
    
    if ([ConexionBD consultaLocalizacion].length != 0) {
        if (txtSKU.text.length >= 5 && txtSKU.text.length <= 11) {
            
            BOOL conexion = [self estaConectado];
            if (conexion) {
                Cargando.hidden = NO;
                [Cargando startAnimating];
                vistaCargando.hidden = NO;
                
                [ConexionBD eliminaOpcionWS];
                [ConexionBD eliminaProducto];
                [ConexionBD registroOpcionWS:@"consultarProductoSKU"];
                [ConexionBD registroProducto:txtSKU.text nombre:@"" inspirate:@"" precio:@"0" cant:@"0" ficha:@""];
                
                opcionXML = 2;
                NSString * token = @"aa28ffad0c2a5d9f39576f7ae53c3fef";
                NSString * ciudad = [ConexionBD consultaLocalizacion];
                
                NSMutableString * parametros = [[NSMutableString alloc]init];
                [parametros appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"http://ws.saps.advante.cl/\"><SOAP-ENV:Body><ns1:consultarProductoSKU>"];
                [parametros appendFormat:[NSString stringWithFormat:@"<token>%@</token>",token]];
                [parametros appendFormat:[NSString stringWithFormat:@"<sku>%@</sku>",txtSKU.text]];
                [parametros appendFormat:[NSString stringWithFormat:@"<ciudad>%@</ciudad></ns1:consultarProductoSKU></SOAP-ENV:Body></SOAP-ENV:Envelope>", ciudad]];
                
                NSLog(parametros);
                
                NSURL * url = [[NSURL alloc] initWithString:@"http://10.23.18.250:9080/SAPSOmnicanalWSTomcat/ConsultarProducto?wsdl"];
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
            
        } else {
            UIAlertView * alerta =[[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"El SKU debe ser mayor a 4 dígitos y menor a 12 dígitos" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
            [alerta show];
        }
    } else {
        UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"No se puede establecer tu ubicación" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [alerta show];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Error COnexion");
    self.codeDetected = NO;
    vistaCargando.hidden = YES;
    Cargando.hidden = YES;
    
    
    NSLog(@"Connection failed with error: %@", [error localizedDescription]);
    NSLog(@"for the URL: %@", [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"Descargando datos");
    [acumulaDatos appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"Descargo!!!");
    NSString * html = [[NSString alloc]initWithData:acumulaDatos encoding:NSUTF8StringEncoding];
    NSLog(html);
    
    [Cargando stopAnimating];
    Cargando.hidden = YES;
    vistaCargando.hidden = YES;

    if (!consultaWeb) {
        
        NSString * resultado = [[NSString alloc]initWithData:acumulaDatos encoding:NSUTF8StringEncoding];
        NSLog(resultado);
        NSLog(@"Descargo Producto");
        
        
        
        //XMLController * xmlC = [[XMLController alloc]init];
        //[xmlC loadXMLByURL:acumulaDatos opcionWS:@"consultaProductoSKU"];
        
        
        
        
        
        
        
        
        
        
        
        
        NSString * fichaTecnia;
        NSString * inspirate;
        NSString * nombre;
        NSString * precio;
        NSString * sku;
        
        for (int i = 0; i < resultado.length; i++) {
            @try {
                if ([[resultado substringWithRange:NSMakeRange(i, 14)] isEqualToString:@"<fichaTecnica>"]) {
                    NSMutableString * auxTextFichaTecnica = [[NSMutableString alloc]init];
                    for (int k = 0; ![[resultado substringWithRange:NSMakeRange(i + 14 + k, 1)]isEqualToString:@"<"]; k++) {
                        [auxTextFichaTecnica appendString:[resultado substringWithRange:NSMakeRange(i + 14 + k, 1)]];
                    }
                    fichaTecnia = auxTextFichaTecnica;
                }
                
                if ([[resultado substringWithRange:NSMakeRange(i, 11)] isEqualToString:@"<inspirate>"]) {
                    NSMutableString * auxTextInspirate = [[NSMutableString alloc]init];
                    for (int k = 0; ![[resultado substringWithRange:NSMakeRange(i + 11 + k, 1)]isEqualToString:@"<"]; k++) {
                        [auxTextInspirate appendString:[resultado substringWithRange:NSMakeRange(i + 11 + k, 1)]];
                    }
                    inspirate = auxTextInspirate;
                }
                
                if ([[resultado substringWithRange:NSMakeRange(i, 8)] isEqualToString:@"<nombre>"]) {
                    NSMutableString * auxTextNombre = [[NSMutableString alloc]init];
                    for (int k = 0; ![[resultado substringWithRange:NSMakeRange(i + 8 + k, 1)]isEqualToString:@"<"]; k++) {
                        [auxTextNombre appendString:[resultado substringWithRange:NSMakeRange(i + 8 + k, 1)]];
                    }
                    nombre = auxTextNombre;
                }
                
                if ([[resultado substringWithRange:NSMakeRange(i, 8)] isEqualToString:@"<precio>"]) {
                    NSMutableString * auxTextPrecio = [[NSMutableString alloc]init];
                    for (int k = 0; ![[resultado substringWithRange:NSMakeRange(i + 8 + k, 1)]isEqualToString:@"<"]; k++) {
                        [auxTextPrecio appendString:[resultado substringWithRange:NSMakeRange(i + 8 + k, 1)]];
                    }
                    precio = auxTextPrecio;
                }
                
                
                if ([[resultado substringWithRange:NSMakeRange(i, 5)] isEqualToString:@"<sku>"]) {
                    NSMutableString * auxTextSKU = [[NSMutableString alloc]init];
                    for (int k = 0; ![[resultado substringWithRange:NSMakeRange(i + 5 + k, 1)]isEqualToString:@"<"]; k++) {
                        [auxTextSKU appendString:[resultado substringWithRange:NSMakeRange(i + 5 + k, 1)]];
                    }
                    sku = auxTextSKU;
                }
            }
            @catch (NSException *exception) {
                //NSLog(@"Error");
            }
        }
        
        [ConexionBD actualizaProducto:sku nombre:nombre inspirate:inspirate precio:precio cant:@"0" ficha:fichaTecnia];
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        NSMutableArray * listaProducto = [ConexionBD consultaProducto];
        Producto = [listaProducto objectAtIndex:0];
        
        if (![Producto.nombre isEqualToString:@"(null)"]) {
            if (![Producto.nombre isEqualToString:@"-1"] && ![Producto.precio isEqualToString:@"-1"]) {
                [ConexionBD eliminaTabControl];
                [ConexionBD registroTabControl:@"Escanear"];
                txtSKU.text = @"";
                destino = [self.storyboard instantiateViewControllerWithIdentifier:@"viewProductoEncontrado"];
                
                [self addChildViewController:destino];
                [self.view addSubview:destino.view];
                [destino didMoveToParentViewController:self];
            } else {
                txtSKU.text = @"";
                
                UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"Producto no disponible" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                [alerta show];
            }
        } else {
            UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"Tenemos problemas al procesar tu solicitud, intenta nuevamente" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
            [alerta show];
        }
    } else {
        
        
        [webView loadHTMLString:html baseURL:[NSURL URLWithString:@""]];
        webView.hidden = NO;
        btnVolver.hidden = NO;
        
    }
}

-(void)viewDidLayoutSubviews{
    if (self.view.subviews.count == 1) {
        //self.codeDetected = NO;
        
        if (!ayuda1.hidden) {
            self.codeDetected = YES;
            NSLog(@"CODIGO SI");
        } else {
            NSLog(@"CODIGO NO");
            self.codeDetected = NO;
        }
        NSLog(@"ESTABA DETECTADO, AHORA NO DETECTADO");
    }
    NSLog(@"SUB VIEWS");
}

- (IBAction)volverQR:(id)sender {
    btnVolver.hidden = YES;
    webView.hidden = YES;
    self.codeDetected = NO;
    imgTitulo.frame = CGRectMake(0, imgTitulo.frame.origin.y, 320, 35);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
