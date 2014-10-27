//
//  ProductoEncontradoViewController.m
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 1/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import "ProductoEncontradoViewController.h"
#import "EscanearViewController.h"
#import "CarritoViewController.h"
#import "XMLController.h"
#import "ayudas.h"
#import "CotizacionesViewController.h"
#import "MasViewController.h"
#import "cotizacion.h"
#import "ConsultasViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#define kSITIO_WEB "www.google.com"

@interface ProductoEncontradoViewController (){
    int validaPaso;
    NSString * productoSKU;
    NSString * productoNombre;
    NSString * productoPrecio;
    int stilo;
    
    
    NSString * productoPrecioAnterior;
    
    
    
    int indicador;
    int agregar;
    BOOL validaAgregar;
}

@end

@implementation ProductoEncontradoViewController
@synthesize txtCant, txtNombreProducto, txtPrecioProducto, txtSKUProducto, imgProducto, scrollView, ConexionBDPE, ProductoPE, acumulaDatos, btn1, btn2, btn3, btn4, lbl1, lbl2, lbl3, lbl4, btnInspirate, vistaDetalle, txtProductoRelacionado, btnVerDetalle, txtDetalleProducto, imgCargando, vistaCargando, lblPrecio1, lblPrecio2, lblPrecio3, lblPrecio4, ayuda, ayuda1, ayuda2, ayuda3, ocultarCaracteristicas, flechaAbajo, lblCant, lblPrecio, lblProdRel, webViewProductoDetalle, lblDetP, lblPD1, lblPD2, labelUltimo;

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
    
    NSLog(@"INICIA PRODUCTO ENCONTRADO");
    
    validaAgregar = NO;
    
    NSTimer * temporizador = [NSTimer scheduledTimerWithTimeInterval:2
                                                              target:self
                                                            selector:@selector(temporiza)
                                                            userInfo:nil
                                                             repeats:YES];
    
    ConexionBDPE = [[bd alloc]init];
    
    
    
    
    
    
    NSMutableArray * listaAyudas = [ConexionBDPE consultaAyuda];
    ayudas * Ayudas = [listaAyudas objectAtIndex:0];
    if ([Ayudas.ProductoEncontrado isEqualToString:@"0"]) {
        [ayuda setUserInteractionEnabled:YES];
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
        [singleTap setNumberOfTapsRequired:1];
        [ayuda addGestureRecognizer:singleTap];
    } else {
        ayuda.hidden = YES;
        ayuda1.hidden = YES;
        ayuda2.hidden = YES;
        ayuda3.hidden = YES;
    }
    
    [scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(320, 930)];
    
    NSMutableArray * arraProductoEncontrado = [ConexionBDPE consultaProducto];
    ProductoPE = [arraProductoEncontrado objectAtIndex:0];
    txtNombreProducto.text = ProductoPE.nombre;
    txtSKUProducto.text = [NSString stringWithFormat:@"SKU: %@", ProductoPE.SKU];
    
    NSNumberFormatter * formater = [[NSNumberFormatter alloc]init];
    formater.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber * number = [[NSNumber alloc]initWithInteger:ProductoPE.precio.integerValue];
    NSLog(@"PRECIO: %@", ProductoPE.precio);
    NSLog(@"PRECIO NUMBER %@", number);
    NSMutableString * preci0 = [formater stringFromNumber:number];
    NSMutableString * numeroMostrar = [preci0 stringByReplacingOccurrencesOfString:@"," withString:@"."];
    txtPrecioProducto.text = [NSString stringWithFormat:@"$ %@",numeroMostrar];
    
    productoSKU = ProductoPE.SKU;
    productoNombre = ProductoPE.nombre;
    productoPrecio = ProductoPE.precio;
    
    productoPrecioAnterior = ProductoPE.precio;
    
    NSLog(@"FICHA TECNIA %@", ProductoPE.fichaTecnica);
    NSLog(@"INSPIRATEEEEEEEEEE %@", ProductoPE.inspirate);
    if (ProductoPE.inspirate.length < 2 || [ProductoPE.inspirate isEqualToString:ProductoPE.fichaTecnica]) {
        btnInspirate.hidden = YES;
    }
    
    //FUNCION PARA MOSTRAR TEXTO FICHA TECNICA
    NSMutableString * textoDetalleProducto = [[NSMutableString alloc]init];
    NSMutableString * textoAuxAtributo = [[NSMutableString alloc]init];
    NSMutableString * textoAuxDetalle = [[NSMutableString alloc]init];
    NSMutableString * textoAux = [[NSMutableString alloc]init];

    NSLog(@"CANT LENGTH %d", ProductoPE.fichaTecnica.length);
    if (ProductoPE.fichaTecnica.length > 0 && ![ProductoPE.fichaTecnica isEqualToString:@"0"] && ![ProductoPE.fichaTecnica isEqualToString:@";"]) {
        [textoDetalleProducto appendString:@"<html><table width='100%'>"];
        @try {
            for (int i = 0; i < ProductoPE.fichaTecnica.length; i++) {
                [textoAux appendString:[ProductoPE.fichaTecnica substringWithRange:NSMakeRange(i, 1)]];

                if ([[ProductoPE.fichaTecnica substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"="]) {
                    textoAuxAtributo = [[NSMutableString alloc]init];
                    if ([[textoAux substringWithRange:NSMakeRange(0, 1)] isEqualToString:@";"])
                        [textoAuxAtributo appendString:[textoAux substringWithRange:NSMakeRange(1,textoAux.length - 2)]];
                    else
                        [textoAuxAtributo appendString:[textoAux substringToIndex:textoAux.length - 1]];
                    
                    textoAux = [[NSMutableString alloc]init];
                }
                
                if ([[ProductoPE.fichaTecnica substringWithRange:NSMakeRange(i, 2)] isEqualToString:@":;"]) {
                    textoAuxDetalle = [[NSMutableString alloc]init];
                    [textoAuxDetalle appendString:[textoAux substringToIndex:textoAux.length - 1]];
                    
                    if (stilo == 0) {
                        [textoDetalleProducto appendString:[NSString stringWithFormat:@"<tr><td style='background-color:#cecece; font-size:14px; font-family:Miso-Light; width:100px'>%@</td><td style='background-color:#cecece; font-size:14px; font-family:Miso-Light'>%@</td></tr>", textoAuxAtributo, textoAuxDetalle]];
                        stilo = 1;
                    } else if (stilo == 1){
                        [textoDetalleProducto appendString:[NSString stringWithFormat:@"<tr><td style='background-color:#fff; font-size:14px; font-family:Miso-Light; width:100px'>%@</td><td style='background-color:#fff; font-size:14px; font-family:Miso-Light'>%@</td></tr>", textoAuxAtributo, textoAuxDetalle]];
                        stilo = 0;
                    }
                    
                    textoAuxAtributo = [[NSMutableString alloc]init];
                    textoAuxDetalle = [[NSMutableString alloc]init];
                    textoAux = [[NSMutableString alloc]init];
                }
                
                if (i == ProductoPE.fichaTecnica.length) {
                    NSLog(textoAuxDetalle);
                    textoAuxDetalle = [[NSMutableString alloc]init];
                    [textoAuxDetalle appendString:[textoAux substringToIndex:textoAux.length - 1]];
                    
                    if (stilo == 0) {
                        [textoDetalleProducto appendString:[NSString stringWithFormat:@"<tr><td style='background-color:#cecece; font-size:14px; font-family:Miso-Light'; width:100px>%@</td><td style='background-color:#cecece; font-size:14px; font-family:Miso-Light'>%@</td></tr>", textoAuxAtributo, textoAuxDetalle]];
                        stilo = 1;
                    } else if (stilo == 1){
                        [textoDetalleProducto appendString:[NSString stringWithFormat:@"<tr><td style='background-color:#fff; font-size:14px; font-family:Miso-Light'; width:100px>%@</td><td style='background-color:#fff; font-size:14px; font-family:Miso-Light'>%@</td></tr>", textoAuxAtributo, textoAuxDetalle]];
                        stilo = 0;
                    }
                    
                    textoAuxAtributo = [[NSMutableString alloc]init];
                    textoAuxDetalle = [[NSMutableString alloc]init];
                    textoAux = [[NSMutableString alloc]init];
                }
            }
        }
        @catch (NSException *exception) {
            
        }
        
    } else {
        btnVerDetalle.hidden = YES;
    }
    
    txtDetalleProducto.text = textoDetalleProducto;
    [webViewProductoDetalle loadHTMLString:textoDetalleProducto baseURL:nil];
    
    
    //Cargo producto temp
    [ConexionBDPE eliminaProductoTEMP];
    [ConexionBDPE registroProductoTEMP:ProductoPE.SKU nombre:ProductoPE.nombre inspirate:ProductoPE.inspirate precio:ProductoPE.precio cant:ProductoPE.cant ficha:ProductoPE.fichaTecnica];
    
    
    NSMutableArray * listaCarrito = [ConexionBDPE consultaCarritoSKU:ProductoPE.SKU];
    if (listaCarrito.count > 0) {
        producto * PRD = [listaCarrito objectAtIndex:0];
        txtCant.text = PRD.cant;
    }
    
    
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://homecenterco.scene7.com/is/image/SodimacCO/%@?lista160", ProductoPE.SKU]];
    NSData * data = [NSData dataWithContentsOfURL:url];
    imgProducto.image = [UIImage imageWithData:data];
    
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
    
    [ConexionBDPE eliminaOpcionWS];
    [ConexionBDPE registroOpcionWS:@"buscarProductosRelacionados"];
    
    
    [ConexionBDPE eliminaProducto];
    
    NSString * token = @"aa28ffad0c2a5d9f39576f7ae53c3fef";
    NSString * ciudad = [ConexionBDPE consultaLocalizacion];
    
    BOOL conexion = [self estaConectado];
    if (conexion) {
        NSMutableString * parametros = [[NSMutableString alloc]init];
        [parametros appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"http://ws.saps.advante.cl/\"><SOAP-ENV:Body><ns1:buscarProductosRelacionados>"];
        [parametros appendFormat:[NSString stringWithFormat:@"<token>%@</token>",token]];
        [parametros appendFormat:[NSString stringWithFormat:@"<sku>%@</sku><ciudad>%@</ciudad></ns1:buscarProductosRelacionados></SOAP-ENV:Body></SOAP-ENV:Envelope>",productoSKU, [ConexionBDPE consultaLocalizacion]]];
        
        NSLog(@"PRODUCTO RELACIONADO");
        NSLog(parametros);
        
        NSURL * urlPR = [[NSURL alloc] initWithString:@"http://10.23.18.250:9080/SAPSOmnicanalWSTomcat/ConsultarProducto?wsdl"];
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:urlPR];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[parametros dataUsingEncoding:NSUTF8StringEncoding]];
        [request addValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
        NSURLConnection * conexion = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        acumulaDatos = [[NSMutableData alloc]init];
    } else {
        UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"No se ha detectado acceso a la red, conéctate a una red de datos e intenta nuevamente" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [alerta show];
    }
    
    [lblPD1 setFont:[UIFont fontWithName:@"Miso-Light" size:16.0]];
    [lblPD2 setFont:[UIFont fontWithName:@"Miso-Light" size:16.0]];
    [lblDetP setFont:[UIFont fontWithName:@"Miso" size:16.0]];
    [txtNombreProducto setFont:[UIFont fontWithName:@"Miso-Light" size:16.0]];
    [txtSKUProducto setFont:[UIFont fontWithName:@"Miso" size:16.0]];
    [txtPrecioProducto setFont:[UIFont fontWithName:@"Miso" size:23.0]];
    [txtCant setFont:[UIFont fontWithName:@"Miso" size:16.0]];
    [lblPrecio setFont:[UIFont fontWithName:@"Miso" size:12.0]];
    [lblCant setFont:[UIFont fontWithName:@"Miso" size:12.0]];
    [lblProdRel setFont:[UIFont fontWithName:@"Miso" size:16.0]];
    [labelUltimo setFont:[UIFont fontWithName:@"Miso-Light" size:13.0]];
    
}

-(void)singleTapping:(UIGestureRecognizer *)recognizer
{
    ayuda.hidden = YES;
    ayuda1.hidden = YES;
    ayuda2.hidden = YES;
    ayuda3.hidden = YES;
    NSMutableArray * listaAyudas = [ConexionBDPE consultaAyuda];
    ayudas * Ayudas = [listaAyudas objectAtIndex:0];
    [ConexionBDPE actualizaAyuda:Ayudas.Menu productoEncontrado:@"1" carrito:Ayudas.Carrito cotizaciones:Ayudas.Cotizaciones mas:Ayudas.Mas];
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
    NSLog(@"Error al descargar producto relacionado");
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [acumulaDatos appendData:data];
    NSLog(@"Descargando Producto relacionado");
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString * resultado = [[NSString alloc]initWithData:acumulaDatos encoding:NSUTF8StringEncoding];
    NSLog(resultado);
    
    XMLController * xmlC = [[XMLController alloc]init];
    
    NSMutableArray * listaProducto = [ConexionBDPE consultaProducto];
    
    NSString * opcionWS = [ConexionBDPE consultaOpcionWS];
    
    if ([opcionWS isEqualToString:@"buscarProductosRelacionados"]) {
        [xmlC loadXMLByURL:acumulaDatos opcionWS:@"consultaProductosRelacionados"];
        listaProducto = [ConexionBDPE consultaProducto];
        NSLog(@"CANT PR %d", listaProducto.count);
        txtProductoRelacionado.hidden = YES;
        flechaAbajo.hidden = YES;
        for (int i = 0; i < listaProducto.count; i++) {
            
            producto * Producto = [listaProducto objectAtIndex:i];
            NSLog(Producto.SKU);
            
            if (![Producto.SKU isEqualToString:@"0.0"]) {
                txtProductoRelacionado.hidden = NO;
                flechaAbajo.hidden = NO;
                NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://homecenterco.scene7.com/is/image/SodimacCO/%@?lista160", Producto.SKU]];
                NSData * data = [NSData dataWithContentsOfURL:url];
                if (i == 0) {
                    btn1.hidden = NO;
                    lbl1.hidden = NO;
                    lblPrecio1.hidden = NO;
                    [btn1 setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                    lbl1.text = Producto.nombre;
                    
                    NSNumberFormatter * formater = [[NSNumberFormatter alloc]init];
                    formater.numberStyle = NSNumberFormatterDecimalStyle;
                    NSNumber * number = [[NSNumber alloc]initWithInteger:Producto.precio.integerValue];
                    NSMutableString * preci0 = [formater stringFromNumber:number];
                    NSMutableString * numeroMostrar = [preci0 stringByReplacingOccurrencesOfString:@"," withString:@"."];
                    lblPrecio1.text = [NSString stringWithFormat:@"$ %@",numeroMostrar];
                    
                    btn1.frame = CGRectMake([self.view frame].size.width / 2 - (btn1.frame.size.width / 2), btn1.frame.origin.y, btn1.frame.size.width, btn1.frame.size.height);
                    lbl1.frame = CGRectMake([self.view frame].size.width / 2 - (lbl1.frame.size.width / 2), lbl1.frame.origin.y, lbl1.frame.size.width, lbl1.frame.size.height);
                    lblPrecio1.frame = CGRectMake([self.view frame].size.width / 2 - (lblPrecio1.frame.size.width / 2), lblPrecio1.frame.origin.y, lblPrecio1.frame.size.width, lblPrecio1.frame.size.height);
                    
                    labelUltimo.frame = CGRectMake(labelUltimo.frame.origin.x, lblPrecio1.frame.origin.y + lblPrecio1.frame.size.height + 5, labelUltimo.frame.size.width, labelUltimo.frame.size.height);
                }
                
                if (i == 1) {
                    btn2.hidden = NO;
                    lbl2.hidden = NO;
                    lblPrecio2.hidden = NO;
                    [btn2 setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                    lbl2.text = Producto.nombre;
                    
                    NSNumberFormatter * formater = [[NSNumberFormatter alloc]init];
                    formater.numberStyle = NSNumberFormatterDecimalStyle;
                    NSNumber * number = [[NSNumber alloc]initWithInteger:Producto.precio.integerValue];
                    NSMutableString * preci0 = [formater stringFromNumber:number];
                    NSMutableString * numeroMostrar = [preci0 stringByReplacingOccurrencesOfString:@"," withString:@"."];
                    lblPrecio2.text = [NSString stringWithFormat:@"$ %@",numeroMostrar];
                    
                    btn1.frame = CGRectMake([self.view frame].size.width / 2 - (btn1.frame.size.width / 2) - btn1.frame.size.width, btn1.frame.origin.y, btn1.frame.size.width, btn1.frame.size.height);
                    lbl1.frame = CGRectMake([self.view frame].size.width / 2 - (lbl1.frame.size.width / 2) - lbl1.frame.size.width, lbl1.frame.origin.y, lbl1.frame.size.width, lbl1.frame.size.height);
                    lblPrecio1.frame = CGRectMake([self.view frame].size.width / 2 - (lblPrecio1.frame.size.width / 2) - lblPrecio1.frame.size.width, lblPrecio1.frame.origin.y, lblPrecio1.frame.size.width, lblPrecio1.frame.size.height);
                    btn2.frame = CGRectMake([self.view frame].size.width / 2 - (btn2.frame.size.width / 2) + btn2.frame.size.width, btn2.frame.origin.y, btn2.frame.size.width, btn2.frame.size.height);
                    lbl2.frame = CGRectMake([self.view frame].size.width / 2 - (lbl2.frame.size.width / 2) + lbl2.frame.size.width, lbl2.frame.origin.y, lbl2.frame.size.width, lbl2.frame.size.height);
                    lblPrecio2.frame = CGRectMake([self.view frame].size.width / 2 - (lblPrecio2.frame.size.width / 2) + lblPrecio2.frame.size.width, lblPrecio2.frame.origin.y, lblPrecio2.frame.size.width, lblPrecio2.frame.size.height);
                }
                
                if (i == 2) {
                    btn3.hidden = NO;
                    lbl3.hidden = NO;
                    lblPrecio3.hidden = NO;
                    [btn3 setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                    lbl3.text = Producto.nombre;
                    
                    NSNumberFormatter * formater = [[NSNumberFormatter alloc]init];
                    formater.numberStyle = NSNumberFormatterDecimalStyle;
                    NSNumber * number = [[NSNumber alloc]initWithInteger:Producto.precio.integerValue];
                    NSMutableString * preci0 = [formater stringFromNumber:number];
                    NSMutableString * numeroMostrar = [preci0 stringByReplacingOccurrencesOfString:@"," withString:@"."];
                    lblPrecio3.text = [NSString stringWithFormat:@"$ %@",numeroMostrar];
                    
                    btn1.frame = CGRectMake([self.view frame].size.width / 2 - (btn1.frame.size.width / 2) - btn1.frame.size.width*2, btn1.frame.origin.y, btn1.frame.size.width, btn1.frame.size.height);
                    lbl1.frame = CGRectMake([self.view frame].size.width / 2 - (lbl1.frame.size.width / 2) - lbl1.frame.size.width*2, lbl1.frame.origin.y, lbl1.frame.size.width, lbl1.frame.size.height);
                    lblPrecio1.frame = CGRectMake([self.view frame].size.width / 2 - (lblPrecio1.frame.size.width / 2) - lblPrecio1.frame.size.width*2, lblPrecio1.frame.origin.y, lblPrecio1.frame.size.width, lblPrecio1.frame.size.height);
                    btn2.frame = CGRectMake([self.view frame].size.width / 2 - (btn2.frame.size.width / 2), btn2.frame.origin.y, btn2.frame.size.width, btn2.frame.size.height);
                    lbl2.frame = CGRectMake([self.view frame].size.width / 2 - (lbl2.frame.size.width / 2), lbl2.frame.origin.y, lbl2.frame.size.width, lbl2.frame.size.height);
                    lblPrecio2.frame = CGRectMake([self.view frame].size.width / 2 - (lblPrecio2.frame.size.width / 2), lblPrecio2.frame.origin.y, lblPrecio2.frame.size.width, lblPrecio2.frame.size.height);
                    btn3.frame = CGRectMake([self.view frame].size.width / 2 - (btn3.frame.size.width / 2) + btn3.frame.size.width*2, btn3.frame.origin.y, btn3.frame.size.width, btn3.frame.size.height);
                    lbl3.frame = CGRectMake([self.view frame].size.width / 2 - (lbl3.frame.size.width / 2) + btn3.frame.size.width*2, lbl3.frame.origin.y, lbl3.frame.size.width, lbl3.frame.size.height);
                    lblPrecio3.frame = CGRectMake([self.view frame].size.width / 2 - (lblPrecio3.frame.size.width / 2) + lblPrecio3.frame.size.width*2, lblPrecio3.frame.origin.y, lblPrecio3.frame.size.width, lblPrecio3.frame.size.height);
                }
                
                if (i == 3) {
                    btn4.hidden = NO;
                    lbl4.hidden = NO;
                    lblPrecio4.hidden = NO;
                    [btn4 setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                    lbl4.text = Producto.nombre;
                    
                    NSNumberFormatter * formater = [[NSNumberFormatter alloc]init];
                    formater.numberStyle = NSNumberFormatterDecimalStyle;
                    NSNumber * number = [[NSNumber alloc]initWithInteger:Producto.precio.integerValue];
                    NSMutableString * preci0 = [formater stringFromNumber:number];
                    NSMutableString * numeroMostrar = [preci0 stringByReplacingOccurrencesOfString:@"," withString:@"."];
                    lblPrecio4.text = [NSString stringWithFormat:@"$ %@",numeroMostrar];
                    
                    btn1.frame = CGRectMake([self.view frame].size.width / 2 - (btn1.frame.size.width / 2) - btn1.frame.size.width*2, btn1.frame.origin.y, btn1.frame.size.width, btn1.frame.size.height);
                    lbl1.frame = CGRectMake([self.view frame].size.width / 2 - (lbl1.frame.size.width / 2) - lbl1.frame.size.width*2, lbl1.frame.origin.y, lbl1.frame.size.width, lbl1.frame.size.height);
                    lblPrecio1.frame = CGRectMake([self.view frame].size.width / 2 - (lblPrecio1.frame.size.width / 2) - lblPrecio1.frame.size.width*2, lblPrecio1.frame.origin.y, lblPrecio1.frame.size.width, lblPrecio1.frame.size.height);
                    btn2.frame = CGRectMake([self.view frame].size.width / 2 - (btn2.frame.size.width / 2) - btn2.frame.size.width/2 - 11.5, btn2.frame.origin.y, btn2.frame.size.width, btn2.frame.size.height);
                    lbl2.frame = CGRectMake([self.view frame].size.width / 2 - (lbl2.frame.size.width / 2) - lbl2.frame.size.width/2 - 11.5, lbl2.frame.origin.y, lbl2.frame.size.width, lbl2.frame.size.height);
                    lblPrecio2.frame = CGRectMake([self.view frame].size.width / 2 - (lblPrecio2.frame.size.width / 2) - lblPrecio2.frame.size.width/2 - 11.5, lblPrecio2.frame.origin.y, lblPrecio2.frame.size.width, lblPrecio2.frame.size.height);
                    btn3.frame = CGRectMake([self.view frame].size.width / 2 - (btn3.frame.size.width / 2) + btn3.frame.size.width*2, btn3.frame.origin.y, btn3.frame.size.width, btn3.frame.size.height);
                    lbl3.frame = CGRectMake([self.view frame].size.width / 2 - (lbl3.frame.size.width / 2) + btn3.frame.size.width*2, lbl3.frame.origin.y, lbl3.frame.size.width, lbl3.frame.size.height);
                    lblPrecio3.frame = CGRectMake([self.view frame].size.width / 2 - (lblPrecio3.frame.size.width / 2) + lblPrecio3.frame.size.width*2, lblPrecio3.frame.origin.y, lblPrecio3.frame.size.width, lblPrecio3.frame.size.height);
                    btn4.frame = CGRectMake([self.view frame].size.width / 2 - (btn4.frame.size.width / 2) + btn4.frame.size.width/2 + 11.5, btn4.frame.origin.y, btn4.frame.size.width, btn4.frame.size.height);
                    lbl4.frame = CGRectMake([self.view frame].size.width / 2 - (lbl4.frame.size.width / 2) + lbl4.frame.size.width/2 + 11.5, lbl4.frame.origin.y, lbl4.frame.size.width, lbl4.frame.size.height);
                    lblPrecio4.frame = CGRectMake([self.view frame].size.width / 2 - (lblPrecio4.frame.size.width / 2) + lblPrecio4.frame.size.width/2 + 11.5, lblPrecio4.frame.origin.y, lblPrecio4.frame.size.width, lblPrecio4.frame.size.height);
                }
                
                [lbl1 setFont:[UIFont fontWithName:@"Miso" size:12.0]];
                [lbl2 setFont:[UIFont fontWithName:@"Miso" size:12.0]];
                [lbl3 setFont:[UIFont fontWithName:@"Miso" size:12.0]];
                [lbl4 setFont:[UIFont fontWithName:@"Miso" size:12.0]];
                [btn1 setFont:[UIFont fontWithName:@"Miso" size:12.0]];
                [btn2 setFont:[UIFont fontWithName:@"Miso" size:12.0]];
                [btn3 setFont:[UIFont fontWithName:@"Miso" size:12.0]];
                [btn4 setFont:[UIFont fontWithName:@"Miso" size:12.0]];
            }
        }
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
        
        [ConexionBDPE actualizaProducto:sku nombre:nombre inspirate:inspirate precio:precio cant:@"0" ficha:fichaTecnia];
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        NSMutableArray * arraProductoEncontrado = [ConexionBDPE consultaProducto];
        ProductoPE = [arraProductoEncontrado objectAtIndex:0];
        
        productoSKU = ProductoPE.SKU;
        productoNombre = ProductoPE.nombre;
        productoPrecio = ProductoPE.precio;
        
        txtNombreProducto.text = ProductoPE.nombre;
        txtSKUProducto.text = [NSString stringWithFormat:@"SKU: %@", ProductoPE.SKU];
        NSNumberFormatter * formater = [[NSNumberFormatter alloc]init];
        formater.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber * number = [[NSNumber alloc]initWithInteger:ProductoPE.precio.integerValue];
        NSLog(@"PRECIO: %@", ProductoPE.precio);
        NSLog(@"PRECIO NUMBER %@", number);
        NSMutableString * preci0 = [formater stringFromNumber:number];
        NSMutableString * numeroMostrar = [preci0 stringByReplacingOccurrencesOfString:@"," withString:@"."];
        txtPrecioProducto.text = [NSString stringWithFormat:@"$ %@",numeroMostrar];
        
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://homecenterco.scene7.com/is/image/SodimacCO/%@?lista160", ProductoPE.SKU]];
        NSData * data = [NSData dataWithContentsOfURL:url];
        imgProducto.image = [UIImage imageWithData:data];
        
        
        
        
        
        if (ProductoPE.inspirate.length == 0 || [ProductoPE.inspirate isEqualToString:ProductoPE.fichaTecnica]) {
            btnInspirate.hidden = YES;
        }
        
        //FUNCION PARA MOSTRAR TEXTO FICHA TECNICA
        NSMutableString * textoDetalleProducto = [[NSMutableString alloc]init];
        NSMutableString * textoAuxAtributo = [[NSMutableString alloc]init];
        NSMutableString * textoAuxDetalle = [[NSMutableString alloc]init];
        NSMutableString * textoAux = [[NSMutableString alloc]init];
        NSLog(@"CANT LENGTH %d", ProductoPE.fichaTecnica.length);
        if (ProductoPE.fichaTecnica.length > 0 && ![ProductoPE.fichaTecnica isEqualToString:@"0"] && ![ProductoPE.fichaTecnica isEqualToString:@";"]) {
            [textoDetalleProducto appendString:@"<html><table>"];
            @try {
                for (int i = 0; i < ProductoPE.fichaTecnica.length; i++) {
                    [textoAux appendString:[ProductoPE.fichaTecnica substringWithRange:NSMakeRange(i, 1)]];
                    
                    if ([[ProductoPE.fichaTecnica substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"="]) {
                        textoAuxAtributo = [[NSMutableString alloc]init];
                        if ([[textoAux substringWithRange:NSMakeRange(0, 1)] isEqualToString:@";"])
                            [textoAuxAtributo appendString:[textoAux substringWithRange:NSMakeRange(1,textoAux.length - 2)]];
                        else
                            [textoAuxAtributo appendString:[textoAux substringToIndex:textoAux.length - 1]];
                        textoAux = [[NSMutableString alloc]init];
                    }
                    
                    if ([[ProductoPE.fichaTecnica substringWithRange:NSMakeRange(i, 2)] isEqualToString:@":;"]) {
                        textoAuxDetalle = [[NSMutableString alloc]init];
                        [textoAuxDetalle appendString:[textoAux substringToIndex:textoAux.length - 1]];
                        
                        if (stilo == 0) {
                            [textoDetalleProducto appendString:[NSString stringWithFormat:@"<tr><td style='background-color:#cecece; font-size:14px; font-family:Miso-Light; width:100px'>%@</td><td style='background-color:#cecece; font-size:14px; font-family:Miso-Light'>%@</td></tr>", textoAuxAtributo, textoAuxDetalle]];
                            stilo = 1;
                        } else if (stilo == 1){
                            [textoDetalleProducto appendString:[NSString stringWithFormat:@"<tr><td style='background-color:#fff; font-size:14px; font-family:Miso-Light'; width:100px>%@</td><td style='background-color:#fff; font-size:14px; font-family:Miso-Light'>%@</td></tr>", textoAuxAtributo, textoAuxDetalle]];
                            stilo = 0;
                        }
                        
                        textoAuxAtributo = [[NSMutableString alloc]init];
                        textoAuxDetalle = [[NSMutableString alloc]init];
                        textoAux = [[NSMutableString alloc]init];
                    }
                    
                    if (i == ProductoPE.fichaTecnica.length) {
                        NSLog(textoAuxDetalle);
                        textoAuxDetalle = [[NSMutableString alloc]init];
                        [textoAuxDetalle appendString:[textoAux substringToIndex:textoAux.length - 1]];
                        
                        if (stilo == 0) {
                            [textoDetalleProducto appendString:[NSString stringWithFormat:@"<tr><td style='background-color:#cecece; font-size:14px; font-family:Miso-Light'; width:100px>%@</td><td style='background-color:#cecece; font-size:14px; font-family:Miso-Light'>%@</td></tr>", textoAuxAtributo, textoAuxDetalle]];
                            stilo = 1;
                        } else if (stilo == 1){
                            [textoDetalleProducto appendString:[NSString stringWithFormat:@"<tr><td style='background-color:#fff; font-size:14px; font-family:Miso-Light'; width:100px>%@</td><td style='background-color:#fff; font-size:14px; font-family:Miso-Light'>%@</td></tr>", textoAuxAtributo, textoAuxDetalle]];
                            stilo = 0;
                        }
                        
                        textoAuxAtributo = [[NSMutableString alloc]init];
                        textoAuxDetalle = [[NSMutableString alloc]init];
                        textoAux = [[NSMutableString alloc]init];
                    }
                }
            }
            @catch (NSException *exception) {
                
            }
            
        } else {
            btnVerDetalle.hidden = YES;
        }
        
        txtDetalleProducto.text = textoDetalleProducto;
        [webViewProductoDetalle loadHTMLString:textoDetalleProducto baseURL:nil];
        
        NSMutableArray * listaCarrito = [ConexionBDPE consultaCarritoSKU:ProductoPE.SKU];
        if (listaCarrito.count > 0) {
            producto * PRD = [listaCarrito objectAtIndex:0];
            txtCant.text = PRD.cant;
        } else {
            txtCant.text = @"1";
        }
        
        
        
        
        
        [ConexionBDPE eliminaOpcionWS];
        [ConexionBDPE registroOpcionWS:@"buscarProductosRelacionados"];
        
        
        NSString * token = @"aa28ffad0c2a5d9f39576f7ae53c3fef";
        NSString * ciudad = [ConexionBDPE consultaLocalizacion];
        
        BOOL conexion = [self estaConectado];
        if (conexion) {
            NSMutableString * parametros = [[NSMutableString alloc]init];
            [parametros appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"http://ws.saps.advante.cl/\"><SOAP-ENV:Body><ns1:buscarProductosRelacionados>"];
            [parametros appendFormat:[NSString stringWithFormat:@"<token>%@</token>",token]];
            [parametros appendFormat:[NSString stringWithFormat:@"<sku>%@</sku><ciudad>%@</ciudad></ns1:buscarProductosRelacionados></SOAP-ENV:Body></SOAP-ENV:Envelope>",productoSKU, [ConexionBDPE consultaLocalizacion]]];
            
            NSLog(@"PRODUCTO RELACIONADO");
            NSLog(parametros);
            
            NSURL * urlPR = [[NSURL alloc] initWithString:@"http://10.23.18.250:9080/SAPSOmnicanalWSTomcat/ConsultarProducto?wsdl"];
            NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:urlPR];
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
    
    vistaCargando.hidden = YES;

}

-(void)consultaSKU:(NSString *)SKU{
    NSLog(SKU);
    
    BOOL conexion = [self estaConectado];
    if (conexion) {
    
        txtProductoRelacionado.hidden = YES;
        flechaAbajo.hidden = YES;
        btn1.hidden = YES;
        btn2.hidden = YES;
        btn3.hidden = YES;
        btn4.hidden = YES;
        lbl1.hidden = YES;
        lbl2.hidden = YES;
        lbl3.hidden = YES;
        lbl4.hidden = YES;
        lblPrecio1.hidden = YES;
        lblPrecio2.hidden = YES;
        lblPrecio3.hidden = YES;
        lblPrecio4.hidden = YES;
        
        [ConexionBDPE eliminaOpcionWS];
        [ConexionBDPE eliminaProducto];
        [ConexionBDPE registroOpcionWS:@"consultarProductoSKU"];
        [ConexionBDPE registroProducto:SKU nombre:@"" inspirate:@"" precio:@"0" cant:@"0" ficha:@""];
        
        
        NSString * token = @"aa28ffad0c2a5d9f39576f7ae53c3fef";
        NSString * ciudad = [ConexionBDPE consultaLocalizacion];
    
    
        NSMutableString * parametros = [[NSMutableString alloc]init];
        [parametros appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"http://ws.saps.advante.cl/\"><SOAP-ENV:Body><ns1:consultarProductoSKU>"];
        [parametros appendFormat:[NSString stringWithFormat:@"<token>%@</token>",token]];
        [parametros appendFormat:[NSString stringWithFormat:@"<sku>%@</sku>",SKU]];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    vistaCargando.hidden = YES;
    
    [ConexionBDPE eliminaTabControl];
    [ConexionBDPE registroTabControl:@"inspirate"];
    
    /*if (validaPaso == 0) {
        NSString * tabSeleccionado = [ConexionBDPE consultaTabControl];
        if ([tabSeleccionado isEqualToString:@"Escanear"]) {
            EscanearViewController * destinoEscaneo = [self.storyboard instantiateViewControllerWithIdentifier:@"viewEscaneo"];
            [self addChildViewController:destinoEscaneo];
            [self.view addSubview:destinoEscaneo.view];
            [destinoEscaneo didMoveToParentViewController:self];
        }
        
        if ([tabSeleccionado isEqualToString:@"Carrito"]) {
            CarritoViewController * destinoEscaneo = [self.storyboard instantiateViewControllerWithIdentifier:@"viewCarrito"];
            [self addChildViewController:destinoEscaneo];
            [self.view addSubview:destinoEscaneo.view];
            [destinoEscaneo didMoveToParentViewController:self];
        }
    }*/
    
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
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height + 220, 0);
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

- (IBAction)verDetalleProducto:(id)sender {
    vistaDetalle.hidden = NO;
    NSLog(@"CLICK VER DETALLE");
    ocultarCaracteristicas.hidden = NO;
}

- (IBAction)agregrarCotizador:(id)sender {
    scrollView.contentOffset = CGPointMake(0, 0);
    
    if (txtCant.text.integerValue >= 0 && txtCant.text.integerValue <= 9999 && txtCant.text.length > 0) {
        NSLog(@"Entro");
        validaAgregar = YES;
        vistaCargando.hidden = NO;
        imgCargando.hidden = NO;
        agregar = 1;
        
    } else {
        UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"Tope máximo por unidades 9999 por cotización, mínimo 1" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [alerta show];
    }
}

- (IBAction)inspirate:(id)sender {
    validaPaso = 1;
}

- (IBAction)PR1:(id)sender {
    imgProducto.image = [UIImage imageNamed:@"no_imagen.png"];
    scrollView.contentOffset = CGPointMake(0, 0);
    vistaCargando.hidden = NO;
    vistaDetalle.hidden = YES;
    ocultarCaracteristicas.hidden = YES;
    NSMutableArray * listaProducto = [ConexionBDPE consultaProducto];
    producto * P = [listaProducto objectAtIndex:0];
    [self consultaSKU:P.SKU];
}

- (IBAction)PR2:(id)sender {
    imgProducto.image = [UIImage imageNamed:@"no_imagen.png"];
    scrollView.contentOffset = CGPointMake(0, 0);
    vistaCargando.hidden = NO;
    vistaDetalle.hidden = YES;
    ocultarCaracteristicas.hidden = YES;
    NSMutableArray * listaProducto = [ConexionBDPE consultaProducto];
    producto * P = [listaProducto objectAtIndex:1];
    [self consultaSKU:P.SKU];
}

- (IBAction)PR3:(id)sender {
    imgProducto.image = [UIImage imageNamed:@"no_imagen.png"];
    scrollView.contentOffset = CGPointMake(0, 0);
    vistaCargando.hidden = NO;
    ocultarCaracteristicas.hidden = YES;
    vistaDetalle.hidden = YES;
    NSMutableArray * listaProducto = [ConexionBDPE consultaProducto];
    producto * P = [listaProducto objectAtIndex:2];
    [self consultaSKU:P.SKU];
}

- (IBAction)PR4:(id)sender {
    imgProducto.image = [UIImage imageNamed:@"no_imagen.png"];
    scrollView.contentOffset = CGPointMake(0, 0);
    vistaCargando.hidden = NO;
    ocultarCaracteristicas.hidden = YES;
    vistaDetalle.hidden = YES;
    NSMutableArray * listaProducto = [ConexionBDPE consultaProducto];
    producto * P = [listaProducto objectAtIndex:3];
    [self consultaSKU:P.SKU];
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
    
    if (agregar == 2) {
        validaAgregar = NO;
        agregar = 1;
        
        
        //Items en el carrito
        NSMutableArray * productosCarrito = [ConexionBDPE consultaCarrito];
        
        NSMutableArray * listaCarrito = [ConexionBDPE consultaCarritoSKU:ProductoPE.SKU];
        if ([listaCarrito count] == 0) {
            if (productosCarrito.count < 99) {
                if (txtCant.text.intValue != 0) {
                    if (productosCarrito.count > 0) {
                        double sumaCarrito = 0;
                        for (int i = 0; i < productosCarrito.count; i++) {
                            producto * p = [productosCarrito objectAtIndex:i];
                            sumaCarrito = sumaCarrito + p.precio.doubleValue * p.cant.intValue;
                        }
                        if ((sumaCarrito + ProductoPE.precio.doubleValue * txtCant.text.intValue) <= 99999999 && (ProductoPE.precio.doubleValue * txtCant.text.integerValue) <= 99999999) {
                            [ConexionBDPE registroCarrito:ProductoPE.SKU nombre:ProductoPE.nombre precio:ProductoPE.precio cant:txtCant.text precioNuevo:ProductoPE.precio];
                        } else {
                            UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"El monto máximo por cotización es de $99.999.999" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                            [alerta show];
                        }
                    } else {
                        if ((ProductoPE.precio.doubleValue * txtCant.text.integerValue) <= 99999999) {
                            [ConexionBDPE registroCarrito:ProductoPE.SKU nombre:ProductoPE.nombre precio:ProductoPE.precio cant:txtCant.text precioNuevo:ProductoPE.precio];
                        } else {
                            UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"El monto máximo por cotización es de $99.999.999" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                            [alerta show];
                        }
                    }
                }
            } else {
                UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"No se pueden agregar más productos al carro, se permiten máximo 99 ítems por cotización" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                [alerta show];
            }
        } else {
            producto * pdto = [listaCarrito objectAtIndex:0];
            
            if (productosCarrito.count < 99) {
                if (txtCant.text.intValue != 0) {
                    double sumaCarrito = 0;
                    for (int i = 0; i < productosCarrito.count; i++) {
                        producto * p = [productosCarrito objectAtIndex:i];
                        if (![pdto.SKU isEqualToString:p.SKU]) {
                            sumaCarrito = sumaCarrito + p.precio.doubleValue * p.cant.intValue;
                        }
                    }
                    if ((sumaCarrito + ProductoPE.precio.doubleValue * txtCant.text.intValue) <= 99999999 && (ProductoPE.precio.doubleValue * txtCant.text.integerValue) <= 99999999) {
                        [ConexionBDPE actualizarCarrito:ProductoPE.SKU nombre:ProductoPE.nombre precio:pdto.precio cant:txtCant.text precioNuevo:ProductoPE.precio];
                    } else {
                        UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"El monto máximo por cotización es de $99.999.999" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                        [alerta show];
                    }
                } else {
                    [ConexionBDPE eliminaCarrito:pdto.SKU];
                }
            } else {
                UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"No se pueden agregar más productos al carro, se permiten máximo 99 ítems por cotización" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                [alerta show];
            }
            
        }
        
        NSMutableArray * lista = [ConexionBDPE consultaCarrito];
        [[[[[self tabBarController]tabBar]items]objectAtIndex:1]setBadgeValue:[NSString stringWithFormat:@"%d", lista.count]];
        
        NSString * OpcionTabControl = [ConexionBDPE consultaTabControl];
        if ([OpcionTabControl isEqualToString:@"Escanear"]) {
            validaPaso = 1;
            EscanearViewController * destinoEscaneo = [self.storyboard instantiateViewControllerWithIdentifier:@"viewEscaneo"];
            destinoEscaneo.codeDetected = NO;
            [self.view removeFromSuperview];
            [destinoEscaneo didMoveToParentViewController:self];
            vistaCargando.hidden = YES;
        }
        
        if ([OpcionTabControl isEqualToString:@"Carrito"]) {
            validaPaso = 1;
            CarritoViewController * destinoCarrito = [self.storyboard instantiateViewControllerWithIdentifier:@"viewCarrito"];
            [self.view removeFromSuperview];
            [destinoCarrito didMoveToParentViewController:self];
            vistaCargando.hidden = YES;
        }
        
        if ([OpcionTabControl isEqualToString:@"Consultas"]) {
            validaPaso = 1;
            ConsultasViewController * destinoConsultas = [self.storyboard instantiateViewControllerWithIdentifier:@"consultasVC"];
            [self.view removeFromSuperview];
            [destinoConsultas didMoveToParentViewController:self];
            vistaCargando.hidden = YES;
        }
    }
    
    if (validaAgregar) {
        agregar++;
    }
    
}


- (IBAction)btnOcultarDetalle:(id)sender {
    vistaDetalle.hidden = YES;
    NSLog(@"OCULTAR DETALLE");
    ocultarCaracteristicas.hidden = YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
