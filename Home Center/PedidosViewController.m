//
//  PedidosViewController.m
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 5/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import "PedidosViewController.h"
#import "XMLController.h"
#import "usuario.h"
#import "cotizacion.h"
#import "producto.h"
#import "VistaPreviaPedidosViewController.h"
#import "MasViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#define kSITIO_WEB "www.google.com"

@interface PedidosViewController (){
    int indicador;
    int cantidadP;
}

@end

@implementation PedidosViewController
@synthesize listaPedidos, Pedido, acumulaDatos, tabla, ConexionBD, imgCargando, vistaCargando, listaCodigo, listaEstado, listaFecha, listaPrecio, listaProductoPrecio, textoResultado, listaCantidad, listaNombre, listaSKU, listaPrecioVistaPrevia, lblTitulo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ConexionBD = [[bd alloc]init];
    //listaPedidos = [[NSMutableArray alloc]init];
    
    NSString * CORREO;
    usuario * Usuario = [[usuario alloc]init];
    NSMutableArray * listaUsuario = [ConexionBD consultaUsuario];
    if (listaUsuario.count > 0) {
     Usuario = [listaUsuario objectAtIndex:0];
     CORREO = Usuario.Correo;
     } else {
     CORREO = @"";
     }
    
    //CORREO = @"ruben.flores00@gmail.com";
    
    BOOL conexion = [self estaConectado];
    if (conexion) {
        vistaCargando.hidden = NO;
        NSMutableString * parametros = [[NSMutableString alloc]init];
        [parametros appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"http://ws.saps.advante.cl/\"><SOAP-ENV:Body><ns1:misCompras>"];
        [parametros appendString:[NSString stringWithFormat:@"<token>aa28ffad0c2a5d9f39576f7ae53c3fef</token><email>%@</email></ns1:misCompras></SOAP-ENV:Body></SOAP-ENV:Envelope>", CORREO]];
        
    //    NSLog(parametros);
        
        NSURL * url = [[NSURL alloc] initWithString:@"http://10.23.18.250:9080/SAPSOmnicanalWSTomcat/AdministrarCotizaciones?wsdl"];
        
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
    
    
    
    NSTimer * temporizador = [NSTimer scheduledTimerWithTimeInterval:2
                                                              target:self
                                                            selector:@selector(temporiza)
                                                            userInfo:nil
                                                             repeats:YES];
    
    [lblTitulo setFont:[UIFont fontWithName:@"Miso" size:16.0]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    UIApplication * app = [UIApplication sharedApplication];
    app.applicationIconBadgeNumber = 0;
    
    if (self.view.subviews.count == 5 && [[ConexionBD consultaTabControl] isEqualToString:@"vistaPreviaPedidos"]) {
        for (int i = 4; i < [[self.view subviews] count]; i++ ) {
            [[[self.view subviews] objectAtIndex:i] removeFromSuperview];
        }
        NSLog(@"REMOVIO");
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listaEstado count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"celda";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    //Pedido = [listaPedidos objectAtIndex:indexPath.row];
    
    @try {
        NSNumberFormatter * formater = [[NSNumberFormatter alloc]init];
        formater.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber * number = [[NSNumber alloc]initWithDouble:[NSString stringWithFormat:@"%@", [listaPrecio objectAtIndex:indexPath.row]].doubleValue];
        NSString * preci0 = [formater stringFromNumber:number];
        NSString * numeroMostrar = [preci0 stringByReplacingOccurrencesOfString:@"," withString:@"."];
        
        UILabel * lblNombre = (UILabel*)[cell viewWithTag:200];
        lblNombre.text = [NSString stringWithFormat:@"MI PEDIDO %@", [listaCodigo objectAtIndex:indexPath.row]];
        UILabel * lblFecha = (UILabel*)[cell viewWithTag:300];
        NSString * strFecha = [[listaFecha objectAtIndex:indexPath.row] substringToIndex:10];
        lblFecha.text = strFecha;
        UILabel * lblEstado = (UILabel*)[cell viewWithTag:400];
        lblEstado.text = [listaEstado objectAtIndex:indexPath.row];
        
        UILabel * lblPrecio = (UILabel *)[cell viewWithTag:500];
        lblPrecio.text = [NSString stringWithFormat:@"$ %@", numeroMostrar];
        
        [lblNombre setFont:[UIFont fontWithName:@"Miso" size:16.0]];
        [lblFecha setFont:[UIFont fontWithName:@"Miso" size:12.0]];
        [lblEstado setFont:[UIFont fontWithName:@"Miso" size:12.0]];
        [lblPrecio setFont:[UIFont fontWithName:@"Miso" size:23.0]];
    }
    @catch (NSException *exception) {
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VistaPreviaPedidosViewController * destino = [self.storyboard instantiateViewControllerWithIdentifier:@"viewVistaPreviaPedidos"];
    
    vistaCargando.hidden = NO;
    
    [ConexionBD eliminaTabControl];
    [ConexionBD registroTabControl:@"vistaPreviaPedidos"];
    
    NSLog(textoResultado);
    
    
    listaCantidad = [[NSMutableArray alloc]init];
    listaSKU = [[NSMutableArray alloc]init];
    listaNombre = [[NSMutableArray alloc]init];
    listaPrecioVistaPrevia = [[NSMutableArray alloc]init];
    NSMutableString * auxTextCODIGO = [[NSMutableString alloc]init];
    
    for (int i = 0; i < textoResultado.length; i++) {
        @try {
            if ([[textoResultado substringWithRange:NSMakeRange(i, 18)] isEqualToString:@"<notaPedidoCodigo>"]) {
                
                for (int k = 0; ![[textoResultado substringWithRange:NSMakeRange(i + 18 + k, 1)]isEqualToString:@"<"]; k++) {
                    [auxTextCODIGO appendString:[textoResultado substringWithRange:NSMakeRange(i + 18 + k, 1)]];
                }
            }
            
            if ([[textoResultado substringWithRange:NSMakeRange(i, 10)] isEqualToString:@"<cantidad>"]) {
                NSMutableString * auxTextCANTIDAD = [[NSMutableString alloc]init];
                for (int k = 0; ![[textoResultado substringWithRange:NSMakeRange(i + 10 + k, 1)]isEqualToString:@"<"]; k++) {
                    [auxTextCANTIDAD appendString:[textoResultado substringWithRange:NSMakeRange(i + 10 + k, 1)]];
                }
                cantidadP = auxTextCANTIDAD.intValue;
                [listaCantidad addObject:auxTextCANTIDAD];
            }
            
            if ([[textoResultado substringWithRange:NSMakeRange(i, 19)] isEqualToString:@"</cantidad><nombre>"]) {
                NSMutableString * auxTextNOMBRE = [[NSMutableString alloc]init];
                for (int k = 0; ![[textoResultado substringWithRange:NSMakeRange(i + 19 + k, 1)]isEqualToString:@"<"]; k++) {
                    [auxTextNOMBRE appendString:[textoResultado substringWithRange:NSMakeRange(i + 19 + k, 1)]];
                }
                [listaNombre addObject:auxTextNOMBRE];
            }
            
            if ([[textoResultado substringWithRange:NSMakeRange(i, 8)] isEqualToString:@"<precio>"]) {
                NSMutableString * auxTextPRECIO = [[NSMutableString alloc]init];
                for (int k = 0; ![[textoResultado substringWithRange:NSMakeRange(i + 8 + k, 1)]isEqualToString:@"<"]; k++) {
                    [auxTextPRECIO appendString:[textoResultado substringWithRange:NSMakeRange(i + 8 + k, 1)]];
                }
                double precioCant = cantidadP * auxTextPRECIO.doubleValue;
                [listaPrecioVistaPrevia addObject:[NSString stringWithFormat:@"%f", precioCant]];
            }
            
            if ([[textoResultado substringWithRange:NSMakeRange(i, 5)] isEqualToString:@"<sku>"]) {
                NSMutableString * auxTextSKU = [[NSMutableString alloc]init];
                for (int k = 0; ![[textoResultado substringWithRange:NSMakeRange(i + 5 + k, 1)]isEqualToString:@"<"]; k++) {
                    [auxTextSKU appendString:[textoResultado substringWithRange:NSMakeRange(i + 5 + k, 1)]];
                }
                [listaSKU addObject:auxTextSKU];
            }
            
            if ([[textoResultado substringWithRange:NSMakeRange(i, 21)] isEqualToString:@"</productos></return>"]) {
                if ([auxTextCODIGO isEqualToString:[listaCodigo objectAtIndex:indexPath.row]]) {
                    
                    destino.listaNombre = listaNombre;
                    destino.listaCantidad = listaCantidad;
                    destino.listaPrecio = listaPrecioVistaPrevia;
                    destino.listaSKU = listaSKU;
                    break;
                } else {
                    listaCantidad = [[NSMutableArray alloc]init];
                    listaSKU = [[NSMutableArray alloc]init];
                    listaNombre = [[NSMutableArray alloc]init];
                    listaPrecioVistaPrevia = [[NSMutableArray alloc]init];
                    auxTextCODIGO = [[NSMutableString alloc]init];
                }
            }
            
            
        }
        @catch (NSException *exception) {
            //NSLog(@"Error");
        }
    }
    
    vistaCargando.hidden = YES;
    
    [self addChildViewController:destino];
    [self.view addSubview:destino.view];
    [destino didMoveToParentViewController:self];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Error");
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"Descargando pedidos");
    [acumulaDatos appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString * resultado = [[NSString alloc]initWithData:acumulaDatos encoding:NSUTF8StringEncoding];
    NSLog(resultado);
    
    textoResultado = [[NSMutableString alloc]init];
    [textoResultado appendString:resultado];
    
    NSLog(@"Descargo pedidos");
    
    listaCodigo = [[NSMutableArray alloc]init];
    listaFecha = [[NSMutableArray alloc]init];
    listaPrecio = [[NSMutableArray alloc]init];
    listaEstado = [[NSMutableArray alloc]init];
    listaProductoPrecio = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < resultado.length; i++) {
        @try {
            if ([[resultado substringWithRange:NSMakeRange(i, 14)] isEqualToString:@"<estadoCodigo>"]) {
                NSMutableString * auxTextESTADO = [[NSMutableString alloc]init];
                for (int k = 0; ![[resultado substringWithRange:NSMakeRange(i + 14 + k, 1)]isEqualToString:@"<"]; k++) {
                    [auxTextESTADO appendString:[resultado substringWithRange:NSMakeRange(i + 14 + k, 1)]];
                }
                NSLog(@"Estado PEDIDO: %@", auxTextESTADO);
                [listaEstado addObject:auxTextESTADO];
            }
            
            if ([[resultado substringWithRange:NSMakeRange(i, 14)] isEqualToString:@"<idCotizacion>"]) {
                NSMutableString * auxTextCOTIZACION = [[NSMutableString alloc]init];
                for (int k = 0; ![[resultado substringWithRange:NSMakeRange(i + 14 + k, 1)]isEqualToString:@"<"]; k++) {
                    [auxTextCOTIZACION appendString:[resultado substringWithRange:NSMakeRange(i + 14 + k, 1)]];
                }
                
                NSMutableArray * listaCotizacion = [ConexionBD consultaCotizacion:auxTextCOTIZACION];
                if (listaCotizacion.count > 0) {
                    [ConexionBD eliminarCotizacion:auxTextCOTIZACION];
                    [ConexionBD eliminaCotizacionDetalle:auxTextCOTIZACION];
                }
            }
            
            if ([[resultado substringWithRange:NSMakeRange(i, 18)] isEqualToString:@"<notaPedidoCodigo>"]) {
                NSMutableString * auxTextCODIGO = [[NSMutableString alloc]init];
                for (int k = 0; ![[resultado substringWithRange:NSMakeRange(i + 18 + k, 1)]isEqualToString:@"<"]; k++) {
                    [auxTextCODIGO appendString:[resultado substringWithRange:NSMakeRange(i + 18 + k, 1)]];
                }
                [listaCodigo addObject:auxTextCODIGO];
            }
            
            if ([[resultado substringWithRange:NSMakeRange(i, 25)] isEqualToString:@"<notaPedidoFechaCreacion>"]) {
                NSMutableString * auxTextFECHA = [[NSMutableString alloc]init];
                for (int k = 0; ![[resultado substringWithRange:NSMakeRange(i + 25 + k, 1)]isEqualToString:@"<"]; k++) {
                    [auxTextFECHA appendString:[resultado substringWithRange:NSMakeRange(i + 25 + k, 1)]];
                }
                [listaFecha addObject:auxTextFECHA];
            }
            
            
            if ([[resultado substringWithRange:NSMakeRange(i, 10)] isEqualToString:@"<cantidad>"]) {
                NSMutableString * auxTextCANTIDAD = [[NSMutableString alloc]init];
                for (int k = 0; ![[resultado substringWithRange:NSMakeRange(i + 10 + k, 1)]isEqualToString:@"<"]; k++) {
                    [auxTextCANTIDAD appendString:[resultado substringWithRange:NSMakeRange(i + 10 + k, 1)]];
                }
                cantidadP = auxTextCANTIDAD.intValue;
            }
            
            if ([[resultado substringWithRange:NSMakeRange(i, 8)] isEqualToString:@"<precio>"]) {
                NSMutableString * auxTextPRECIO = [[NSMutableString alloc]init];
                for (int k = 0; ![[resultado substringWithRange:NSMakeRange(i + 8 + k, 1)]isEqualToString:@"<"]; k++) {
                    [auxTextPRECIO appendString:[resultado substringWithRange:NSMakeRange(i + 8 + k, 1)]];
                }
                double precioCant = cantidadP * auxTextPRECIO.doubleValue;
                [listaProductoPrecio addObject:[NSString stringWithFormat:@"%f", precioCant]];
            }
            
            if ([[resultado substringWithRange:NSMakeRange(i, 21)] isEqualToString:@"</productos></return>"]) {
                double precio = 0;
                for (int l = 0; l < listaProductoPrecio.count; l++) {
                    precio = precio + [NSString stringWithFormat:@"%@",[listaProductoPrecio objectAtIndex:l]].doubleValue;
                }
                [listaPrecio addObject:[NSString stringWithFormat:@"%f", precio]];
                listaProductoPrecio = [[NSMutableArray alloc]init];
            }
        }
        @catch (NSException *exception) {
            //NSLog(@"Error");
        }
    }
    
    [tabla reloadData];
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

- (IBAction)volver:(id)sender {
    MasViewController * destinoCarrito = [self.storyboard instantiateViewControllerWithIdentifier:@"viewMas"];
    [self.view removeFromSuperview];
    [destinoCarrito didMoveToParentViewController:self];
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
