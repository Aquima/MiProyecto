//
//  CarritoViewController.m
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 2/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import "CarritoViewController.h"
#import "ProductoEncontradoViewController.h"
#import "ResumenCotizacionViewController.h"
#import "cotizacion.h"
#import "usuario.h"
#import "EditarCorreoViewController.h"
#import "MasViewController.h"
#import "ActivarCuentaViewController.h"
#import "XMLController.h"
#import "ayudas.h"
#import <SystemConfiguration/SystemConfiguration.h>
#define kSITIO_WEB "www.google.com"

@interface CarritoViewController (){
    double subTotal;
    double Total;
    double IVA;
    double Ahorro;
    float posicionX;
    float posicionY;
    UIButton * btnEliminar;
    int indicador;
    BOOL cambioPrecio;
    int indicadorCarrito;
    int validaIMG;
}

@end

@implementation CarritoViewController
@synthesize txtAhorro, txtIVA, txtSubTotal, txtTotal, btnGeneraCotizacion, listaCarrito, tabla, ConexionBD, Producto, imgFoto, iconoCarrito, imgMensaje, Cargando, acumulaDatos, imgCargando, vistaCargando, ayuda, ayuda1, formater, number, preci0, numeroMostrar, listaDatosIMG, lblTotal, lblVerificaPrecios, activoGC, validaGC;

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
    
    ConexionBD =[[bd alloc]init];
    
    NSTimer * temporizador = [NSTimer scheduledTimerWithTimeInterval:2
                                                              target:self
                                                            selector:@selector(temporiza)
                                                            userInfo:nil
                                                             repeats:YES];
    validaGC = 0;
}

-(void)singleTapping:(UIGestureRecognizer *)recognizer
{
    ayuda.hidden = YES;
    ayuda1.hidden = YES;
    NSMutableArray * listaAyudas = [ConexionBD consultaAyuda];
    ayudas * Ayudas = [listaAyudas objectAtIndex:0];
    [ConexionBD actualizaAyuda:Ayudas.Menu productoEncontrado:Ayudas.ProductoEncontrado carrito:@"1" cotizaciones:Ayudas.Cotizaciones mas:Ayudas.Mas];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    NSLog(@"BARCODE: %@", [ConexionBD consultaTabControl]);
    if (self.view.subviews.count == 11 && ![[ConexionBD consultaTabControl] isEqualToString:@"Barcode"]) {
        for (int i = 10; i < [[self.view subviews] count]; i++ ) {
            [[[self.view subviews] objectAtIndex:i] removeFromSuperview];
        }
        NSLog(@"REMOVIO");
    } /*else {
        [ConexionBD eliminaTabControl];
        [ConexionBD registroTabControl:@"ResumenCotizacion"];
    }*/
    
    indicadorCarrito = 0;
    
    cambioPrecio = NO;
    
    Cargando.hidden = YES;
    vistaCargando.hidden = YES;
    
    ConexionBD =[[bd alloc]init];
    
    listaCarrito = [ConexionBD consultaCarrito];
    
    
    iconoCarrito.badgeValue = [NSString stringWithFormat:@"%d",listaCarrito.count];
    Total = 0;
    subTotal = 0;
    IVA = 0;
    NSMutableArray * listaAyudas = [ConexionBD consultaAyuda];
    ayudas * Ayudas = [listaAyudas objectAtIndex:0];
    ayuda1.hidden = YES;
    ayuda.hidden = YES;
    for (int i = 0; i < [listaCarrito count]; i++) {
        imgMensaje.hidden = YES;
        producto * prod = [listaCarrito objectAtIndex:i];
        NSLog(@"CANTIDAD %@", prod.cant);
        
        Total = Total + (prod.precioNuevo.doubleValue * prod.cant.doubleValue);
        IVA = Total * 16 / 100;
        subTotal = Total - IVA;
        
        NSString * textoBoton = [ConexionBD consultaBoton];
        if (![textoBoton isEqualToString:@"1"]) {
            btnGeneraCotizacion.titleLabel.text = @"GENERAR COTIZACIÓN";
            [ConexionBD eliminaCotizacionTemp];
        }
        
        if ([Ayudas.Carrito isEqualToString:@"0"]) {
            [ayuda setUserInteractionEnabled:YES];
            UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
            [singleTap setNumberOfTapsRequired:1];
            [ayuda addGestureRecognizer:singleTap];
            ayuda.hidden = NO;
            ayuda1.hidden = NO;
        } else {
            ayuda.hidden = YES;
            ayuda1.hidden = YES;
        }
        
        //CONEXION ENVIA DATOS DE CARRITO WS____________________________________________________________________________///////
        @try {
            NSString * ValidaWS = [ConexionBD consultaValidaWS];
            if ([ValidaWS isEqualToString:@"0"] || [ValidaWS isEqualToString:@""]){
                [ConexionBD eliminaValidaWS];
                [ConexionBD registroValidaWS:@"1"];
                
                [ConexionBD eliminaOpcionWS];
                [ConexionBD registroOpcionWS:@"carritoWS"];
                
                NSMutableArray * listaUsuario = [ConexionBD consultaUsuario];
                usuario * Usuario = [listaUsuario objectAtIndex:0];
                
                NSString * token = @"aa28ffad0c2a5d9f39576f7ae53c3fef";
                NSString * ciudad = [ConexionBD consultaLocalizacion];
                
                NSMutableString * parametros = [[NSMutableString alloc]init];
                [parametros appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"http://ws.saps.advante.cl/\"><SOAP-ENV:Body><ns1:NuevoCarrito>"];
                [parametros appendFormat:[NSString stringWithFormat:@"<token>%@</token>",token]];
                [parametros appendFormat:[NSString stringWithFormat:@"<Correo>%@</Correo></ns1:NuevoCarrito></SOAP-ENV:Body></SOAP-ENV:Envelope>",Usuario.Correo]];
                
                NSLog(parametros);
                
                NSURL * url = [[NSURL alloc] initWithString:@"http://10.23.18.250:9080/SAPSOmnicanalWSTomcat/AdministrarCotizaciones?wsdl"];
                
                NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
                [request setHTTPMethod:@"POST"];
                [request setHTTPBody:[parametros dataUsingEncoding:NSUTF8StringEncoding]];
                [request addValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
                NSURLConnection * conexion = [[NSURLConnection alloc]initWithRequest:request delegate:self];
                acumulaDatos = [[NSMutableData alloc]init];
            }
        }
        @catch (NSException *exception) {
            
        }
    }
    
    formater = [[NSNumberFormatter alloc]init];
    formater.numberStyle = NSNumberFormatterDecimalStyle;
    number = [[NSNumber alloc]initWithDouble:Total];
    preci0 = [formater stringFromNumber:number];
    numeroMostrar = [preci0 stringByReplacingOccurrencesOfString:@"," withString:@"."];
    txtTotal.text = numeroMostrar;
    
    number = [[NSNumber alloc]initWithDouble:IVA];
    preci0 = [formater stringFromNumber:number];
    numeroMostrar = [preci0 stringByReplacingOccurrencesOfString:@"," withString:@"."];
    txtIVA.text = numeroMostrar;
    
    number = [[NSNumber alloc]initWithDouble:subTotal];
    preci0 = [formater stringFromNumber:number];
    numeroMostrar = [preci0 stringByReplacingOccurrencesOfString:@"," withString:@"."];
    txtSubTotal.text = numeroMostrar;
    
    [tabla reloadData];
    
    cambioPrecio = NO;
    
    @try {
        activoGC = [[NSMutableString alloc]init];
        [activoGC appendString:[ConexionBD consultaNotificacion]];
    }
    @catch (NSException *exception) {
        
    }
    
    validaGC++;
    if (validaGC == 2) {
        if ([activoGC isEqualToString:@"SI"]) {
            NSLog(@"ACTIVO SIIIIIIIIIIIIIIIIIIIIIIII %@", activoGC);
            validaIMG = 0;
            //activoGC = [[NSMutableString alloc]init];
            [ConexionBD eliminaNotificacion];
            validaGC = 0;
            
            BOOL conexion = [self estaConectado];
            if (conexion) {
                NSMutableArray * listaUsuario = [ConexionBD consultaUsuario];
                if (listaUsuario.count > 0) {
                    usuario * Usuario = [listaUsuario objectAtIndex:0];
                    NSLog(@"USUARIO ID: %@", Usuario.ID);
                    if ([Usuario.Estado isEqualToString:@"1"]) {
                        
                        vistaCargando.hidden = NO;
                        Cargando.hidden = NO;
                        [Cargando startAnimating];
                        
                        //CONSULTAMOS LOS PRECIOS ACTUALIZADOS DE CADA PRODUCTO
                        [ConexionBD eliminaOpcionWS];
                        [ConexionBD registroOpcionWS:@"consultarProductoSKUCotizar"];
                        
                        producto * prod = [listaCarrito objectAtIndex:0];
                        [ConexionBD eliminaProducto];
                        [ConexionBD registroProducto:prod.SKU nombre:@"" inspirate:@"" precio:@"0" cant:@"0" ficha:@""];
                        
                        
                        NSString * token = @"aa28ffad0c2a5d9f39576f7ae53c3fef";
                        NSString * ciudad = [ConexionBD consultaLocalizacion];
                        
                        NSMutableString * parametros = [[NSMutableString alloc]init];
                        [parametros appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"http://ws.saps.advante.cl/\"><SOAP-ENV:Body><ns1:consultarProductoSKU>"];
                        [parametros appendFormat:[NSString stringWithFormat:@"<token>%@</token>",token]];
                        [parametros appendFormat:[NSString stringWithFormat:@"<sku>%@</sku>",prod.SKU]];
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
                        [ConexionBD eliminaTabControl];
                        [ConexionBD registroTabControl:@"Carrito"];
                        ActivarCuentaViewController * destino = [self.storyboard instantiateViewControllerWithIdentifier:@"viewActivarCuenta"];
                        [self addChildViewController:destino];
                        [self.view addSubview:destino.view];
                        [destino didMoveToParentViewController:self];
                    }
                } else {
                    [ConexionBD eliminaTabControl];
                    [ConexionBD registroTabControl:@"Carrito"];
                    EditarCorreoViewController * destino = [self.storyboard instantiateViewControllerWithIdentifier:@"viewEditarCorreo"];
                    [self addChildViewController:destino];
                    [self.view addSubview:destino.view];
                    [destino didMoveToParentViewController:self];
                }
            } else {
                UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"No se ha detectado acceso a la red, conéctate a una red de datos e intenta nuevamente" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                [alerta show];
            }
        } else
            validaGC = 0;
    }
    
    if (listaCarrito.count == 0) {
        imgMensaje.hidden = NO;
    } else if (validaIMG == 0 && ![activoGC isEqualToString:@"SI"]) {
        listaDatosIMG = [[NSMutableArray alloc]init];
        Producto = [listaCarrito objectAtIndex:0];
        NSMutableString * parametros = [[NSMutableString alloc]init];
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://homecenterco.scene7.com/is/image/SodimacCO/%@?lista160", Producto.SKU]];
        NSLog(Producto.SKU);
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
        [request setHTTPMethod:@"GET"];
        [request setHTTPBody:[parametros dataUsingEncoding:NSUTF8StringEncoding]];
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        NSURLConnection * conexion = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        acumulaDatos = [[NSMutableData alloc]init];
        validaIMG = 1;
    }
    
    NSLog(@"VIEW WILL APPEAR CARRITO");
    
    [lblVerificaPrecios setFont:[UIFont fontWithName:@"Miso" size:12.0]];
    [lblTotal setFont:[UIFont fontWithName:@"Miso" size:24.0]];
    [txtTotal setFont:[UIFont fontWithName:@"Miso" size:24.0]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)generaCotizacion:(id)sender {
    
    if (imgMensaje.hidden == YES) {
        BOOL conexion = [self estaConectado];
        if (conexion) {
            NSMutableArray * listaUsuario = [ConexionBD consultaUsuario];
            if (listaUsuario.count > 0) {
                usuario * Usuario = [listaUsuario objectAtIndex:0];
                NSLog(@"USUARIO ID: %@", Usuario.ID);
                if ([Usuario.Estado isEqualToString:@"1"]) {
                    
                    vistaCargando.hidden = NO;
                    Cargando.hidden = NO;
                    [Cargando startAnimating];
                    
                    //CONSULTAMOS LOS PRECIOS ACTUALIZADOS DE CADA PRODUCTO
                    [ConexionBD eliminaOpcionWS];
                    [ConexionBD registroOpcionWS:@"consultarProductoSKUCotizar"];
                    
                    producto * prod = [listaCarrito objectAtIndex:0];
                    [ConexionBD eliminaProducto];
                    [ConexionBD registroProducto:prod.SKU nombre:prod.nombre inspirate:prod.inspirate precio:prod.precio cant:@"0" ficha:prod.fichaTecnica];
                    
                    
                    NSString * token = @"aa28ffad0c2a5d9f39576f7ae53c3fef";
                    NSString * ciudad = [ConexionBD consultaLocalizacion];
                    
                    NSMutableString * parametros = [[NSMutableString alloc]init];
                    [parametros appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"http://ws.saps.advante.cl/\"><SOAP-ENV:Body><ns1:consultarProductoSKU>"];
                    [parametros appendFormat:[NSString stringWithFormat:@"<token>%@</token>",token]];
                    [parametros appendFormat:[NSString stringWithFormat:@"<sku>%@</sku>",prod.SKU]];
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
                    [ConexionBD eliminaTabControl];
                    [ConexionBD registroTabControl:@"Carrito"];
                    ActivarCuentaViewController * destino = [self.storyboard instantiateViewControllerWithIdentifier:@"viewActivarCuenta"];
                    [self addChildViewController:destino];
                    [self.view addSubview:destino.view];
                    [destino didMoveToParentViewController:self];
                }
            } else {
                [ConexionBD eliminaTabControl];
                [ConexionBD registroTabControl:@"Carrito"];
                EditarCorreoViewController * destino = [self.storyboard instantiateViewControllerWithIdentifier:@"viewEditarCorreo"];
                [self addChildViewController:destino];
                [self.view addSubview:destino.view];
                [destino didMoveToParentViewController:self];
            }
        } else {
            UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"No se ha detectado acceso a la red, conéctate a una red de datos e intenta nuevamente" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
            [alerta show];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listaCarrito count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"celda";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    Producto = [listaCarrito objectAtIndex:indexPath.row];
    
    NSNumberFormatter * formater = [[NSNumberFormatter alloc]init];
    formater.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber * number = [[NSNumber alloc]initWithDouble:Producto.precio.doubleValue];
    NSMutableString * preci0 = [formater stringFromNumber:number];
    NSString * numeroMostrar = [preci0 stringByReplacingOccurrencesOfString:@"," withString:@"."];
    
    NSNumberFormatter * formater1 = [[NSNumberFormatter alloc]init];
    formater1.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber * number1 = [[NSNumber alloc]initWithDouble:Producto.precioNuevo.doubleValue];
    NSMutableString * preci1 = [formater1 stringFromNumber:number1];
    NSString * numeroMostrar1 = [preci1 stringByReplacingOccurrencesOfString:@"," withString:@"."];
    
    imgFoto = (UIImageView *)[cell viewWithTag:100];
    
    
    if (listaDatosIMG.count == listaCarrito.count) {
        imgFoto.image = [UIImage imageWithData:[listaDatosIMG objectAtIndex:indexPath.row]];
    }
    
	UILabel * lblNombre = (UILabel*)[cell viewWithTag:200];
    lblNombre.text = Producto.nombre;
    
    UILabel * lblSKU = (UILabel*)[cell viewWithTag:800];
    lblSKU.text = [NSString stringWithFormat:@"SKU %@", Producto.SKU];
    
    UILabel * lblCantidad = (UILabel*)[cell viewWithTag:300];
    lblCantidad.text = Producto.cant;
    
    
    
    UILabel * lblPrecio = (UILabel*)[cell viewWithTag:400];
    //UILabel * lblPrecioTXT = (UILabel*)[cell viewWithTag:401];
    UILabel * lblPrecioNuevo = (UILabel*)[cell viewWithTag:450];
    UILabel * lblPrecioNuevoTXT = (UILabel*)[cell viewWithTag:451];
    
    //Producto.precioNuevo = @"10000000";
    if (![Producto.precio isEqualToString:Producto.precioNuevo]) {
        lblPrecio.text = [NSString stringWithFormat:@"Nuevo $%@", numeroMostrar1];
        lblPrecioNuevo.hidden = NO;
        lblPrecioNuevo.text = [NSString stringWithFormat:@"Anterior $%@", numeroMostrar];
        lblPrecioNuevoTXT.hidden = NO;
    } else {
        lblPrecio.text = [NSString stringWithFormat:@"$ %@", numeroMostrar1];
        lblPrecioNuevo.hidden = YES;
        lblPrecioNuevoTXT.hidden = YES;
    }
    
    [lblSKU setFont:[UIFont fontWithName:@"Miso" size:15.0]];
    [lblNombre setFont:[UIFont fontWithName:@"Miso-Light" size:16.0]];
    [lblCantidad setFont:[UIFont fontWithName:@"Miso" size:12.0]];
    [lblPrecio setFont:[UIFont fontWithName:@"Miso" size:19.0]];
    [lblPrecioNuevo setFont:[UIFont fontWithName:@"Miso" size:19.0]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Producto = [listaCarrito objectAtIndex:indexPath.row];
        [ConexionBD eliminaCarrito:Producto.SKU];
        [listaCarrito removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        listaCarrito = [ConexionBD consultaCarrito];
        NSMutableArray * listaCart = [ConexionBD consultaCarrito];
        iconoCarrito.badgeValue = [NSString stringWithFormat:@"%d",listaCart.count];
        Total = 0;
        IVA = 0;
        subTotal = 0;
        for (int i = 0; i < [listaCarrito count]; i++) {
            imgMensaje.hidden = YES;
            producto * prod = [listaCarrito objectAtIndex:i];
            
            Total = Total + (prod.precio.doubleValue * prod.cant.doubleValue);
            IVA = Total * 16 / 100;
            subTotal = Total - IVA;
        }
        
        NSNumberFormatter * formater = [[NSNumberFormatter alloc]init];
        formater.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber * number = [[NSNumber alloc]initWithDouble:Total];
        NSMutableString * preci0 = [formater stringFromNumber:number];
        NSMutableString * numeroMostrar = [preci0 stringByReplacingOccurrencesOfString:@"," withString:@"."];
        txtTotal.text = numeroMostrar;
        
        number = [[NSNumber alloc]initWithDouble:IVA];
        preci0 = [formater stringFromNumber:number];
        numeroMostrar = [preci0 stringByReplacingOccurrencesOfString:@"," withString:@"."];
        txtIVA.text = numeroMostrar;
        
        number = [[NSNumber alloc]initWithDouble:subTotal];
        preci0 = [formater stringFromNumber:number];
        numeroMostrar = [preci0 stringByReplacingOccurrencesOfString:@"," withString:@"."];
        txtSubTotal.text = numeroMostrar;
        
        if (listaCarrito.count == 0) {
            imgMensaje.hidden = NO;
            
            [ConexionBD eliminaCotizacionTemp];
            
            //CONEXION ENVIA DATOS DE CARRITO WS____________________________________________________________________________///////
            @try {
                NSString * ValidaWS = [ConexionBD consultaValidaWS];
                if ([ValidaWS isEqualToString:@"1"]){
                    [ConexionBD eliminaValidaWS];
                    [ConexionBD registroValidaWS:@"0"];
                    
                    [ConexionBD eliminaOpcionWS];
                    [ConexionBD registroOpcionWS:@"carritoWS"];
                    
                    NSMutableArray * listaUsuario = [ConexionBD consultaUsuario];
                    usuario * Usuario = [listaUsuario objectAtIndex:0];
                    
                    NSString * token = @"aa28ffad0c2a5d9f39576f7ae53c3fef";
                    NSString * ciudad = [ConexionBD consultaLocalizacion];
                    
                    NSMutableString * parametros = [[NSMutableString alloc]init];
                    [parametros appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"http://ws.saps.advante.cl/\"><SOAP-ENV:Body><ns1:BorrarCarrito>"];
                    [parametros appendFormat:[NSString stringWithFormat:@"<token>%@</token>",token]];
                    [parametros appendFormat:[NSString stringWithFormat:@"<Correo>%@</Correo></ns1:BorrarCarrito></SOAP-ENV:Body></SOAP-ENV:Envelope>",Usuario.Correo]];
                    
                    NSLog(parametros);
                    
                    NSURL * url = [[NSURL alloc] initWithString:@"http://10.23.18.250:9080/SAPSOmnicanalWSTomcat/AdministrarCotizaciones?wsdl"];
                    
                    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
                    [request setHTTPMethod:@"POST"];
                    [request setHTTPBody:[parametros dataUsingEncoding:NSUTF8StringEncoding]];
                    [request addValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
                    NSURLConnection * conexion = [[NSURLConnection alloc]initWithRequest:request delegate:self];
                    acumulaDatos = [[NSMutableData alloc]init];
                }
            } @catch (NSException *exception) {
                
            }
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Borrar";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL conexion = [self estaConectado];
    if (conexion) {
        NSLog(@"%d", indexPath.row);
        [ConexionBD eliminaOpcionWS];
        [ConexionBD eliminaProducto];
        [ConexionBD registroOpcionWS:@"consultarProductoSKU"];
        producto * prod = [listaCarrito objectAtIndex:indexPath.row];
        [ConexionBD registroProducto:prod.SKU nombre:@"" inspirate:@"" precio:prod.precio cant:@"0" ficha:@""];
        
        
        NSString * token = @"aa28ffad0c2a5d9f39576f7ae53c3fef";
        NSString * ciudad = [ConexionBD consultaLocalizacion];
        
        NSMutableString * parametros = [[NSMutableString alloc]init];
        [parametros appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"http://ws.saps.advante.cl/\"><SOAP-ENV:Body><ns1:consultarProductoSKU>"];
        [parametros appendFormat:[NSString stringWithFormat:@"<token>%@</token>",token]];
        [parametros appendFormat:[NSString stringWithFormat:@"<sku>%@</sku>",prod.SKU]];
        [parametros appendFormat:[NSString stringWithFormat:@"<ciudad>%@</ciudad></ns1:consultarProductoSKU></SOAP-ENV:Body></SOAP-ENV:Envelope>", ciudad]];
        
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
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Error");
    vistaCargando.hidden = YES;
    validaIMG = 0;
    Cargando.hidden = YES;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"Descargando producto");
    [acumulaDatos appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    if (validaIMG == 1) {
        NSLog(@"Entro");
        [listaDatosIMG addObject:acumulaDatos];
        if (listaCarrito.count == listaDatosIMG.count) {
            validaIMG = 0;
            [tabla reloadData];
            NSLog(@"Entro1");
            vistaCargando.hidden = YES;
        } else {
            NSLog(@"INDEX %d", listaDatosIMG.count);
            Producto = [listaCarrito objectAtIndex:listaDatosIMG.count];
            NSMutableString * parametros = [[NSMutableString alloc]init];
            NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://homecenterco.scene7.com/is/image/SodimacCO/%@?lista160", Producto.SKU]];
            NSLog(Producto.SKU);
            NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
            [request setHTTPMethod:@"GET"];
            [request setHTTPBody:[parametros dataUsingEncoding:NSUTF8StringEncoding]];
            [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
            NSURLConnection * conexion = [[NSURLConnection alloc]initWithRequest:request delegate:self];
            acumulaDatos = [[NSMutableData alloc]init];
        }
    } else{
    
        
        NSString * resultado = [[NSString alloc]initWithData:acumulaDatos encoding:NSUTF8StringEncoding];
        NSLog(resultado);
        NSLog(@"Descargo!!!!!!!!!!!");
        XMLController * xmlC = [[XMLController alloc]init];
        
        NSString * opcionWS = [ConexionBD consultaOpcionWS];
        
        if ([opcionWS isEqualToString:@"consultarProductoSKUCotizar"]) {
            [xmlC loadXMLByURL:acumulaDatos opcionWS:@"consultaProductoSKU"];
            if (indicadorCarrito < listaCarrito.count) {
                NSMutableArray * LPROD = [ConexionBD consultaProducto];
                producto * PROD = [LPROD objectAtIndex:0];
                producto * PCAR = [listaCarrito objectAtIndex:indicadorCarrito];
                
                if (![PROD.precio isEqualToString:@"-1"] && ![PCAR.precio isEqualToString:@"-1"] && ![PROD.precio isEqualToString:@""]) {
                    
                    if (![PROD.precio isEqualToString:PCAR.precio]) {
                        cambioPrecio = YES;
                        NSLog(@"DIFERENTE %@ y %@", PROD.precio, PCAR.precio);
                        [ConexionBD actualizarCarrito:PCAR.SKU nombre:PROD.nombre precio:PCAR.precio cant:PCAR.cant precioNuevo:PROD.precio];
                        [tabla reloadData];
                    }
                    indicadorCarrito++;
                    
                    if (indicadorCarrito < listaCarrito.count) {
                        producto * prod = [listaCarrito objectAtIndex:indicadorCarrito];
                        [ConexionBD eliminaProducto];
                        [ConexionBD registroProducto:prod.SKU nombre:@"" inspirate:@"" precio:@"0" cant:@"0" ficha:@""];
                        
                        
                        NSString * token = @"aa28ffad0c2a5d9f39576f7ae53c3fef";
                        NSString * ciudad = [ConexionBD consultaLocalizacion];
                        
                        NSMutableString * parametros = [[NSMutableString alloc]init];
                        [parametros appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"http://ws.saps.advante.cl/\"><SOAP-ENV:Body><ns1:consultarProductoSKU>"];
                        [parametros appendFormat:[NSString stringWithFormat:@"<token>%@</token>",token]];
                        [parametros appendFormat:[NSString stringWithFormat:@"<sku>%@</sku>",prod.SKU]];
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
                        
                        NSLog(@"ENTRO POR ELSE 1");
                        
                        if (cambioPrecio) {
                            UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"Los precios de los productos fueron actualizados, ¿desea continuar con la cotización?" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                            [alerta show];
                        } else {
                            
                            //CONSULTAMOS EL ID DEL USUARIO ACTUALIZADO-------------------------------------------------
                            
                            NSMutableArray * listaUsuario = [ConexionBD consultaUsuario];
                            
                            usuario * Usuario = [listaUsuario objectAtIndex:0];
                            NSLog(@"USUARIO ID ACTUAL: %@", Usuario.ID);
                            
                            //CONSULTAMOS LOS PRECIOS ACTUALIZADOS DE CADA PRODUCTO
                            [ConexionBD eliminaOpcionWS];
                            [ConexionBD registroOpcionWS:@"validaUsuarioID"];
                            
                            NSString * token = @"aa28ffad0c2a5d9f39576f7ae53c3fef";
                            
                            NSMutableString * parametros = [[NSMutableString alloc]init];
                            [parametros appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"http://ws.saps.advante.cl/\"><SOAP-ENV:Body><ns1:retornaIdUsuario>"];
                            [parametros appendFormat:[NSString stringWithFormat:@"<token>%@</token>",token]];
                            [parametros appendFormat:[NSString stringWithFormat:@"<correo>%@</correo></ns1:retornaIdUsuario></SOAP-ENV:Body></SOAP-ENV:Envelope>",Usuario.Correo]];
                            //[parametros appendFormat:[NSString stringWithFormat:@"<idUsuario>%@</idUsuario></ns1:retornaIdUsuario></SOAP-ENV:Body></SOAP-ENV:Envelope>", Usuario.ID]];
                            
                            NSLog(parametros);
                            
                            NSURL * url = [[NSURL alloc] initWithString:@"http://10.23.18.250:9080/SAPSOmnicanalWSTomcat/AdministrarUsuarios?wsdl"];
                            NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
                            [request setHTTPMethod:@"POST"];
                            [request setHTTPBody:[parametros dataUsingEncoding:NSUTF8StringEncoding]];
                            [request addValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
                            NSURLConnection * conexion = [[NSURLConnection alloc]initWithRequest:request delegate:self];
                            acumulaDatos = [[NSMutableData alloc]init];
                        }
                    }
                } else {
                    vistaCargando.hidden = YES;
                    indicadorCarrito = 0;
                    cambioPrecio = NO;
                    UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"Los servicios no están disponibles, intente nuevamente" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                    [alerta show];
                }
                
                
            } else {

                //CONSULTAMOS EL ID DEL USUARIO ACTUALIZADO-------------------------------------------------
                
                NSMutableArray * listaUsuario = [ConexionBD consultaUsuario];
                
                usuario * Usuario = [listaUsuario objectAtIndex:0];
                NSLog(@"USUARIO ID ACTUAL: %@", Usuario.ID);
                
                //CONSULTAMOS LOS PRECIOS ACTUALIZADOS DE CADA PRODUCTO
                [ConexionBD eliminaOpcionWS];
                [ConexionBD registroOpcionWS:@"validaUsuarioID"];
                
                NSString * token = @"aa28ffad0c2a5d9f39576f7ae53c3fef";
                
                NSMutableString * parametros = [[NSMutableString alloc]init];
                [parametros appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"http://ws.saps.advante.cl/\"><SOAP-ENV:Body><ns1:retornaIdUsuario>"];
                [parametros appendFormat:[NSString stringWithFormat:@"<token>%@</token>",token]];
                [parametros appendFormat:[NSString stringWithFormat:@"<correo>%@</correo></ns1:retornaIdUsuario></SOAP-ENV:Body></SOAP-ENV:Envelope>",Usuario.Correo]];
                //[parametros appendFormat:[NSString stringWithFormat:@"<idUsuario>%@</idUsuario></ns1:retornaIdUsuario></SOAP-ENV:Body></SOAP-ENV:Envelope>", Usuario.ID]];
                
                NSLog(parametros);
                
                NSURL * url = [[NSURL alloc] initWithString:@"http://10.23.18.250:9080/SAPSOmnicanalWSTomcat/AdministrarUsuarios?wsdl"];
                NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
                [request setHTTPMethod:@"POST"];
                [request setHTTPBody:[parametros dataUsingEncoding:NSUTF8StringEncoding]];
                [request addValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
                NSURLConnection * conexion = [[NSURLConnection alloc]initWithRequest:request delegate:self];
                acumulaDatos = [[NSMutableData alloc]init];
                
            }
        }
        
        if ([opcionWS isEqualToString:@"validaUsuarioID"]) {
            //TOMAMOS EL ID USUARIO QUE RETORNO EL SERVICIO
            
            NSMutableArray * listaUsuarioAux = [ConexionBD consultaUsuario];
            usuario * UsuarioAux = [listaUsuarioAux objectAtIndex:0];
            
            if([resultado length] > 1){
                NSMutableString * auxText = [[NSMutableString alloc]init];
                for (int i = 0; i < resultado.length; i++) {
                    @try {
                        if ([[resultado substringWithRange:NSMakeRange(i, 8)] isEqualToString:@"<return>"]) {
                            
                            NSLog(@"ENTRO");
                            
                            for (int k = 0; ![[resultado substringWithRange:NSMakeRange(i + 8 + k, 1)]isEqualToString:@"<"]; k++) {
                                [auxText appendString:[resultado substringWithRange:NSMakeRange(i + 8 + k, 1)]];
                                
                            }
                            
                            if (![auxText isEqualToString:@"0"] && ![auxText isEqualToString:@"-1"]) {
                                [ConexionBD actualizaUsuario:UsuarioAux.Correo estado:UsuarioAux.Estado idUsuario:auxText];
                            }
                            NSLog(@"ID USUARIO NUEVO %@", auxText);
                            
                            
                            break;
                        }
                    }
                    @catch (NSException *exception) {
                        NSLog(@"Error");
                    }
                }
                
                
            }
            
            //SE ENVIA A GENERAR LA COTIZACIÓN
            
            NSMutableArray * listaUsuario = [ConexionBD consultaUsuario];
            usuario * Usuario = [listaUsuario objectAtIndex:0];
            
            
            [ConexionBD eliminaOpcionWS];
            [ConexionBD registroOpcionWS:@"guardarCotizacion"];
            
            
            
            NSMutableString * productos = [[NSMutableString alloc]init];
            
            for (int i = 0; i < listaCarrito.count; i++) {
                producto * prod = [listaCarrito objectAtIndex:i];
                [productos appendString:@"<prods>"];
                [productos appendString:@"<sku>"];
                [productos appendString:prod.SKU];
                [productos appendString:@"</sku>"];
                [productos appendString:@"<cantidad>"];
                [productos appendString:prod.cant];
                [productos appendString:@"</cantidad>"];
                [productos appendString:@"</prods>"];
            }
            
            NSMutableString * idCotizacion = [[NSMutableString alloc]init];
            NSMutableArray * listaCotizacionTemp = [ConexionBD consultaCotizacionTemp];
            
            if (listaCotizacionTemp.count > 0) {
                cotizacion * CotizacionTemp = [listaCotizacionTemp objectAtIndex:0];
                idCotizacion = CotizacionTemp.ID;
                NSLog(@"ID COTIZACION %@", idCotizacion);
            } else {
                idCotizacion = @"";
            }
            
            
            NSString * token = @"aa28ffad0c2a5d9f39576f7ae53c3fef";
            NSString * ciudad = [ConexionBD consultaLocalizacion];
            
            NSMutableString * parametros = [[NSMutableString alloc]init];
            [parametros appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"http://ws.saps.advante.cl/\"><SOAP-ENV:Body><ns1:guardarCotizacion>"];
            [parametros appendFormat:[NSString stringWithFormat:@"<token>%@</token>",token]];
            [parametros appendFormat:[NSString stringWithFormat:@"<idUsuario>%@</idUsuario>",Usuario.ID]];
            [parametros appendFormat:[NSString stringWithFormat:@"<idCotizacion>%@</idCotizacion>",idCotizacion]];
            [parametros appendFormat:[NSString stringWithFormat:@"%@",productos]];
            [parametros appendFormat:[NSString stringWithFormat:@"<ciudad>%@</ciudad>", ciudad]];
            [parametros appendFormat:[NSString stringWithFormat:@"<mailUsuario>%@</mailUsuario></ns1:guardarCotizacion></SOAP-ENV:Body></SOAP-ENV:Envelope>",Usuario.Correo]];
            
            NSLog(parametros);
            
            NSURL * url = [[NSURL alloc] initWithString:@"http://10.23.18.250:9080/SAPSOmnicanalWSTomcat/AdministrarCotizaciones?wsdl"];
            
            NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[parametros dataUsingEncoding:NSUTF8StringEncoding]];
            [request addValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
            NSURLConnection * conexion = [[NSURLConnection alloc]initWithRequest:request delegate:self];
            acumulaDatos = [[NSMutableData alloc]init];
        }
        
        if ([opcionWS isEqualToString:@"consultarProductoSKU"]) {
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
                    [ConexionBD registroTabControl:@"Carrito"];
                    
                    Cargando.hidden = YES;
                    vistaCargando.hidden = YES;
                    
                    
                    ProductoEncontradoViewController * destino = [self.storyboard instantiateViewControllerWithIdentifier:@"viewProductoEncontrado"];
                    [self addChildViewController:destino];
                    [self.view addSubview:destino.view];
                    [destino didMoveToParentViewController:self];
                } else {
                    
                    UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"Producto no disponible" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                    [alerta show];
                }
            } else {
                UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"Tenemos problemas al procesar tu solicitud, intenta nuevamente" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                [alerta show];
            }
        }
        
        if ([opcionWS isEqualToString:@"guardarCotizacion"]) {
            [xmlC loadXMLByURL:acumulaDatos opcionWS:@"guardarCotizacion"];
            NSMutableArray * listaCart = [ConexionBD consultaCarrito];
            NSMutableArray * listaCotizacion = [ConexionBD consultaCotizacionTemp];
            
            if (listaCotizacion.count > 0) {
                cotizacion * Cotizacion = [listaCotizacion objectAtIndex:0];
                
                [ConexionBD actualizarCotizacion:Cotizacion.ID fecha:Cotizacion.Fecha precio:Cotizacion.Precio items:[NSString stringWithFormat:@"%d", [listaCart count]] subTotal:Cotizacion.SubTotal ahorro:Cotizacion.Ahorro iva:Cotizacion.IVA nombre:Cotizacion.Nombre];
                
                [ConexionBD eliminaCotizacionTemp];
                [ConexionBD registroCotizacionTemp:Cotizacion.ID fecha:Cotizacion.Fecha precio:Cotizacion.Precio items:[NSString stringWithFormat:@"%d", listaCart.count] subTotal:Cotizacion.SubTotal ahorro:Cotizacion.Ahorro iva:Cotizacion.IVA nombre:Cotizacion.Nombre];
                
                [ConexionBD eliminaCotizacionDetalle:Cotizacion.ID];
                for (int i = 0; i < [listaCart count]; i++) {
                    producto * prod = [listaCart objectAtIndex:i];
                    [ConexionBD registroCotizacionDetalle:Cotizacion.ID sku:prod.SKU nombre:prod.nombre precio:prod.precioNuevo cant:prod.cant];
                }
                
                iconoCarrito.badgeValue = @"0";
                
                [ConexionBD eliminaBoton];
                [ConexionBD eliminaTabControl];
                [ConexionBD registroTabControl:@"ResumenCotizacion"];
                
                Cargando.hidden = YES;
                vistaCargando.hidden = YES;
                
                ResumenCotizacionViewController * destino = [self.storyboard instantiateViewControllerWithIdentifier:@"viewResumenCotizacion"];
                [self addChildViewController:destino];
                [self.view addSubview:destino.view];
                [destino didMoveToParentViewController:self];
            } else {
                Cargando.hidden = YES;
                vistaCargando.hidden = YES;
                UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"No se pudo guardar su cotización intente nuevamente" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                [alerta show];
            }
        }
        [tabla reloadData];
        
        if ([opcionWS isEqualToString:@"carritoWS"]) {
            NSString * resultado = [[NSString alloc]initWithData:acumulaDatos encoding:NSUTF8StringEncoding];
            if([resultado length] > 1){
                NSMutableString * auxTextWS = [[NSMutableString alloc]init];
                for (int i = 0; i < resultado.length; i++) {
                    @try {
                        if ([[resultado substringWithRange:NSMakeRange(i, 8)] isEqualToString:@"<return>"]) {
                            for (int k = 0; ![[resultado substringWithRange:NSMakeRange(i + 8 + k, 1)]isEqualToString:@"<"]; k++) {
                                [auxTextWS appendString:[resultado substringWithRange:NSMakeRange(i + 8 + k, 1)]];
                            }
                            NSLog(@"Resultado de carritoWS %@",auxTextWS);
                            NSString * ValidaWS = [ConexionBD consultaValidaWS];
                            if ([ValidaWS isEqualToString:@""]){
                                [ConexionBD registroValidaWS:@"1"];
                            } else {
                                [ConexionBD eliminaValidaWS];
                                [ConexionBD registroValidaWS:@"1"];
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
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        cambioPrecio = NO;
        Cargando.hidden = YES;
        vistaCargando.hidden = YES;
        listaCarrito = [ConexionBD consultaCarrito];
        [tabla reloadData];
    }
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

-(void)viewDidLayoutSubviews{
    if (self.view.subviews.count == 10) {
        [self viewWillAppear:YES];
        NSLog(@"PRUEBA PRUEBA");
    }
    
        NSLog(@"CANTIDAD SUB VIEWS CARRITOOOOOOOO: %d",self.view.subviews.count);
    
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
