//
//  ConsultasViewController.m
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 3/07/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import "ConsultasViewController.h"
#import "XMLController.h"
#import "ProductoEncontradoViewController.h"
#import "producto.h"

@interface ConsultasViewController (){
    int pagina;
    int tipoConsulta;
    NSMutableString * urlOnClick;
    int numeroReferencias;
    int tipoCelda;
}

@end

@implementation ConsultasViewController
@synthesize acumulaDatos, txtConsulta, tabla, listaPasillo, listaReferencia, listaOnClick, listaSKU, ConexionBD;

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if (self.view.subviews.count == 5) {
        for (int i = 4; i < [[self.view subviews] count]; i++ ) {
            [[[self.view subviews] objectAtIndex:i] removeFromSuperview];
        }
        NSLog(@"REMOVIO");
    }
    
    tipoConsulta = 0;
    numeroReferencias = 0;
    tipoCelda = 0;
    urlOnClick = [[NSMutableString alloc]init];
    listaPasillo = [[NSMutableArray alloc]init];
    listaReferencia = [[NSMutableArray alloc]init];
    listaOnClick = [[NSMutableArray alloc]init];
    listaSKU = [[NSMutableArray alloc]init];
    txtConsulta.text = @"";
    [tabla reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int cantidadItems = 0;
    if (tipoCelda == 0) {
        cantidadItems = [listaReferencia count];
    } else {
        cantidadItems = [listaSKU count];
    }
    return cantidadItems;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tipoCelda == 0) {
        static NSString * simpleTableIdentifier= @"celda";
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        
        UILabel * lblPasillo = (UILabel*)[cell viewWithTag:200];
        lblPasillo.text = [NSString stringWithFormat:@"Pasillo %@", [listaPasillo objectAtIndex:indexPath.row]];
        UILabel * lblReferencias = (UILabel*)[cell viewWithTag:300];
        lblReferencias.text = [NSString stringWithFormat:@"%@ Referencias", [listaReferencia objectAtIndex:indexPath.row]];
    } else {
        static NSString * simpleTableIdentifier = @"celda1";
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        
        UILabel * lblSKU = (UILabel*)[cell viewWithTag:500];
        lblSKU.text = [NSString stringWithFormat:@"SKU %@", [listaSKU objectAtIndex:indexPath.row]];
        
    }
    
    return cell;
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
    NSLog(@"Descargo consultas");
    
    if (tipoConsulta == 1) {
        listaPasillo = [[NSMutableArray alloc]init];
        listaReferencia = [[NSMutableArray alloc]init];
        listaSKU = [[NSMutableArray alloc]init];
        listaOnClick = [[NSMutableArray alloc]init];
        for (int i = 0; i < resultado.length; i++) {
            @try {
                if ([[resultado substringWithRange:NSMakeRange(i, 24)] isEqualToString:@"onclick=\"location.href='"]) {
                    NSMutableString * auxTextOnClick = [[NSMutableString alloc]init];
                    for (int j = 0; ![[resultado substringWithRange:NSMakeRange(i + 24 + j, 1)]isEqualToString:@"'"]; j++) {
                        [auxTextOnClick appendString:[resultado substringWithRange:NSMakeRange(i + 24 + j, 1)]];
                    }
                    [listaOnClick addObject:auxTextOnClick];
                    NSLog(@"ONCLICK %@", auxTextOnClick);
                }
                
                if ([[resultado substringWithRange:NSMakeRange(i, 22)] isEqualToString:@"<b>Pasillo&nbsp;&nbsp;"]) {
                    NSMutableString * auxText = [[NSMutableString alloc]init];
                    int auxIndicador = 0;
                    for (int j = 0; ![[resultado substringWithRange:NSMakeRange(i + 22 + j, 1)]isEqualToString:@":"]; j++) {
                        [auxText appendString:[resultado substringWithRange:NSMakeRange(i + 22 + j, 1)]];
                        auxIndicador = j;
                    }
                    [listaPasillo addObject:auxText];
                    NSLog(@"PASILLO %@", auxText);
                    
                    if ([[resultado substringWithRange:NSMakeRange(i + 22 + auxIndicador + 1, 64)] isEqualToString:@":</b>&nbsp;&nbsp;&nbsp;<span class=\"fuenteGris\" id=\"fuenteGris\">"]) {
                        NSMutableString * auxText1 = [[NSMutableString alloc]init];
                        for (int k = 0; ![[resultado substringWithRange:NSMakeRange(i + 22 + auxIndicador + 65 + k, 1)]isEqualToString:@"&"]; k++) {
                            [auxText1 appendString:[resultado substringWithRange:NSMakeRange(i + 22 + auxIndicador + 65 + k, 1)]];
                        }
                        NSLog(@"REFERENCIAS %@", auxText1);
                        [listaReferencia addObject:auxText1];
                    }
                }
            }
            @catch (NSException *exception) {
                
            }
        }
    }
    
    if (tipoConsulta == 2) {
        for (int i = 0; i < resultado.length; i++) {
            @try {
                if ([[resultado substringWithRange:NSMakeRange(i, 55)] isEqualToString:@"onclick=\"location.href='detalleProducto.jsp?productoId="]) {
                    NSMutableString * auxTextSKU = [[NSMutableString alloc]init];
                    for (int k = 0; ![[resultado substringWithRange:NSMakeRange(i + 55 + k, 1)]isEqualToString:@"&"]; k++) {
                        [auxTextSKU appendString:[resultado substringWithRange:NSMakeRange(i + 55 + k, 1)]];
                    }
                    NSLog(@"SKU %@", auxTextSKU);
                    [listaSKU addObject:auxTextSKU];
                }
                
                if ([[resultado substringWithRange:NSMakeRange(i, 36)] isEqualToString:@"title=\"Ir a Pagina Siguiente\" href=\""]) {
                    NSMutableString * auxTextPaginas = [[NSMutableString alloc]init];
                    for (int j = 0; ![[resultado substringWithRange:NSMakeRange(i + 36 + j, 1)]isEqualToString:@"\""]; j++) {
                        [auxTextPaginas appendString:[resultado substringWithRange:NSMakeRange(i + 36 + j, 1)]];
                    }
                    NSLog(@"PAGINAS SIGUIENTE %@", auxTextPaginas);
                    if (![urlOnClick isEqualToString:auxTextPaginas]) {
                        urlOnClick = [[NSMutableString alloc]init];
                        [urlOnClick appendString:auxTextPaginas];
                        
                        NSMutableString * parametros = [[NSMutableString alloc]init];
                        NSURL * url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://movil.homecenter.co/SptiHomeCenterMovil/catalogo/%@", auxTextPaginas]];
                        
                        NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
                        [request setHTTPMethod:@"GET"];
                        [request setHTTPBody:[parametros dataUsingEncoding:NSUTF8StringEncoding]];
                        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
                        NSURLConnection * conexion = [[NSURLConnection alloc]initWithRequest:request delegate:self];
                        acumulaDatos = [[NSMutableData alloc]init];
                    }
                    break;
                }
                
                if (listaSKU.count == numeroReferencias) {
                    //OCULTA LA VISTA CARGANDO
                    NSLog(@"OCULTA LA VISTA CARGANDO");
                    tipoCelda = 1;
                    [tabla reloadData];
                    break;
                }
            }
            @catch (NSException *exception) {
                
            }
        }
    }
    
    if (tipoConsulta == 0) {
        XMLController * xmlC = [[XMLController alloc]init];
        NSString * opcionWS = [ConexionBD consultaOpcionWS];
        
        if ([opcionWS isEqualToString:@"consultarProductoSKU"]) {
            [xmlC loadXMLByURL:acumulaDatos opcionWS:@"consultaProductoSKU"];
            
            
            //Cargando.hidden = YES;
            //vistaCargando.hidden = YES;
            
            NSMutableArray * listaProducto = [ConexionBD consultaProducto];
            producto * Producto = [listaProducto objectAtIndex:0];
            
            if (![Producto.nombre isEqualToString:@"-1"]) {
                [ConexionBD eliminaTabControl];
                [ConexionBD registroTabControl:@"Consultas"];
                
                ProductoEncontradoViewController * destino = [self.storyboard instantiateViewControllerWithIdentifier:@"viewProductoEncontrado"];
                [self addChildViewController:destino];
                [self.view addSubview:destino.view];
                [destino didMoveToParentViewController:self];
            } else {
                UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"Producto no disponible" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                [alerta show];
            }
        }
    }
    
    [tabla reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tipoCelda == 0) {
        tipoConsulta = 2;
        urlOnClick = [[NSMutableString alloc]init];
        listaSKU = [[NSMutableArray alloc]init];
        [urlOnClick appendString:[listaOnClick objectAtIndex:indexPath.row]];
        
        numeroReferencias = [NSString stringWithFormat:@"%@",[listaReferencia objectAtIndex:indexPath.row]].intValue;
        
        NSMutableString * parametros = [[NSMutableString alloc]init];
        NSURL * url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://movil.homecenter.co/SptiHomeCenterMovil/catalogo/%@", [listaOnClick objectAtIndex:indexPath.row]]];
        
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
        [request setHTTPMethod:@"GET"];
        [request setHTTPBody:[parametros dataUsingEncoding:NSUTF8StringEncoding]];
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        NSURLConnection * conexion = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        acumulaDatos = [[NSMutableData alloc]init];
    } else {
        tipoConsulta = 0;
        [ConexionBD eliminaOpcionWS];
        [ConexionBD eliminaProducto];
        [ConexionBD registroOpcionWS:@"consultarProductoSKU"];
        [ConexionBD registroProducto:[listaSKU objectAtIndex:indexPath.row] nombre:@"" inspirate:@"" precio:@"" cant:@"0" ficha:@""];
        
        
        NSString * token = @"aa28ffad0c2a5d9f39576f7ae53c3fef";
        NSString * ciudad = [ConexionBD consultaLocalizacion];
        
        NSMutableString * parametros = [[NSMutableString alloc]init];
        [parametros appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"http://ws.saps.advante.cl/\"><SOAP-ENV:Body><ns1:consultarProductoSKU>"];
        [parametros appendFormat:[NSString stringWithFormat:@"<token>%@</token>",token]];
        [parametros appendFormat:[NSString stringWithFormat:@"<sku>%@</sku>",[listaSKU objectAtIndex:indexPath.row]]];
        [parametros appendFormat:[NSString stringWithFormat:@"<ciudad>%@</ciudad></ns1:consultarProductoSKU></SOAP-ENV:Body></SOAP-ENV:Envelope>", ciudad]];
        
        NSURL * url = [[NSURL alloc] initWithString:@"http://10.23.18.250:9080/SAPSOmnicanalWSTomcat/ConsultarProducto?wsdl"];
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[parametros dataUsingEncoding:NSUTF8StringEncoding]];
        [request addValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
        NSURLConnection * conexion = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        acumulaDatos = [[NSMutableData alloc]init];
    }
    
}

- (IBAction)btnConsultar:(id)sender {
    if (txtConsulta.text.length > 0) {
        tipoConsulta = 1;
        NSMutableString * parametros = [[NSMutableString alloc]init];
        NSURL * url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://movil.homecenter.co/SptiHomeCenterMovil/catalogo/listaPasillos.jsp?tienda=13&palabra=%@", txtConsulta.text]];
        
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
        [request setHTTPMethod:@"GET"];
        [request setHTTPBody:[parametros dataUsingEncoding:NSUTF8StringEncoding]];
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        NSURLConnection * conexion = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        acumulaDatos = [[NSMutableData alloc]init];
    }
}

- (IBAction)ocultaTeclado:(id)sender {
}

-(void)viewDidLayoutSubviews{
    if (self.view.subviews.count == 4) {
        [self viewWillAppear:YES];
        NSLog(@"PRUEBA PRUEBA");
    }
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
