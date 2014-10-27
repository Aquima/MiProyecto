//
//  VistaPreviaCotizacionViewController.m
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 18/07/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import "VistaPreviaCotizacionViewController.h"
#import "cotizacion_detalle.h"
#import "CotizacionesViewController.h"
#import "cotizacion.h"

@interface VistaPreviaCotizacionViewController (){
    double subTotal;
    double Total;
    double IVA;
    double Ahorro;
    int validaIMG;
}

@end

@implementation VistaPreviaCotizacionViewController
@synthesize txtAhorro, txtIVA, txtSubTotal, txtTotal, tabla, Producto, listaCarrito, ConexionBD, formater, number, numeroMostrar, preci0, idCotizacion, listaDatosIMG, acumulaDatos, txtNombre, lblNombre, Cotizacion, btnEdita, lblTotal;

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
    
    NSLog(@"ID COTIZACION %@", idCotizacion);
    
    listaCarrito = [ConexionBD consultaCotizacionDetalle:idCotizacion];
    NSMutableArray * listaCotiza = [ConexionBD consultaCotizacion:idCotizacion];
    Cotizacion = [listaCotiza objectAtIndex:0];
    
    lblNombre.text = Cotizacion.Nombre;
    
    Total = 0;
    subTotal = 0;
    IVA = 0;

    for (int i = 0; i < [listaCarrito count]; i++) {
        cotizacion_detalle * prod = [listaCarrito objectAtIndex:i];
        NSLog(@"CANTIDAD %@", prod.Cant);
        
        Total = Total + (prod.Precio.doubleValue * prod.Cant.doubleValue);
        IVA = Total * 16 / 100;
        subTotal = Total - IVA;
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
    
    //vistaCargando.hidden = NO;
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
    
    [btnEdita.titleLabel setFont:[UIFont fontWithName:@"Miso" size:16.0]];
    [txtTotal setFont:[UIFont fontWithName:@"Miso" size:23.0]];
    [txtNombre setFont:[UIFont fontWithName:@"Miso" size:16.0]];
    [lblNombre setFont:[UIFont fontWithName:@"Miso" size:16.0]];
    [lblTotal setFont:[UIFont fontWithName:@"Miso" size:23.0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
	
    NSLog(@"NOMBRE PRODUCTO: %@",Producto.Nombre);
    NSLog(@"PRECIO PRODUCTO: %@",Producto.Precio);
    
    NSNumberFormatter * formater = [[NSNumberFormatter alloc]init];
    formater.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber * number = [[NSNumber alloc]initWithDouble:Producto.Precio.doubleValue];
    NSMutableString * preci0 = [formater stringFromNumber:number];
    NSString * numeroMostrar = [preci0 stringByReplacingOccurrencesOfString:@"," withString:@"."];
    
    
    NSLog(@"PRECIO FORMATIADO %@", numeroMostrar);
    
    UIImageView * imgFoto = (UIImageView *)[cell viewWithTag:100];
    
    imgFoto = (UIImageView *)[cell viewWithTag:100];
    /*NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://homecenterco.scene7.com/is/image/SodimacCO/%@?lista160", Producto.SKU]];
    NSData * data = [NSData dataWithContentsOfURL:url];
    imgFoto.image = [UIImage imageWithData:data];*/
    if (listaDatosIMG.count == listaCarrito.count) {
        imgFoto.image = [UIImage imageWithData:[listaDatosIMG objectAtIndex:indexPath.row]];
    }
    
	UILabel * lblNombre = (UILabel*)[cell viewWithTag:200];
    lblNombre.text = Producto.Nombre;
    UILabel * lblCantidad = (UILabel*)[cell viewWithTag:300];
    lblCantidad.text = [NSString stringWithFormat:@"Cantidad: %@", Producto.Cant];
    
    
    UILabel * lblPrecio = (UILabel*)[cell viewWithTag:400];
    lblPrecio.text = [NSString stringWithFormat:@"$ %@", numeroMostrar];
    
    [lblNombre setFont:[UIFont fontWithName:@"Miso-Light" size:16.0]];
    [lblCantidad setFont:[UIFont fontWithName:@"Miso" size:12.0]];
    [lblPrecio setFont:[UIFont fontWithName:@"Miso" size:23.0]];
    
    return cell;
}

- (IBAction)btnVolver:(id)sender {
    CotizacionesViewController * destinoCarrito = [self.storyboard instantiateViewControllerWithIdentifier:@"viewMisCotizaciones"];
    [self.view removeFromSuperview];
    [destinoCarrito didMoveToParentViewController:self];
}

- (IBAction)btnEditar:(id)sender {
    [ConexionBD registroBoton];
    [ConexionBD vaciaCarrito];

    NSMutableArray * listaCotizacionDetalle = [ConexionBD consultaCotizacionDetalle:idCotizacion];
    for (int i = 0; i < listaCotizacionDetalle.count; i++) {
        Producto = [listaCotizacionDetalle objectAtIndex:i];
        [ConexionBD registroCarrito:Producto.SKU nombre:Producto.Nombre precio:Producto.Precio cant:Producto.Cant precioNuevo:Producto.Precio];
    }
    [[[[[self tabBarController]tabBar]items]objectAtIndex:1]setBadgeValue:[NSString stringWithFormat:@"%d", listaCotizacionDetalle.count]];
    
    [ConexionBD eliminaCotizacionTemp];
    NSMutableArray * listaCotiza = [ConexionBD consultaCotizacion:idCotizacion];
    cotizacion * Cotizacion = [listaCotiza objectAtIndex:0];
    [ConexionBD registroCotizacionTemp:Cotizacion.ID fecha:Cotizacion.Fecha precio:Cotizacion.Precio items:Cotizacion.Items subTotal:Cotizacion.SubTotal ahorro:Cotizacion.Ahorro iva:Cotizacion.IVA nombre:Cotizacion.Nombre];
    
    CotizacionesViewController * destinoCarrito = [self.storyboard instantiateViewControllerWithIdentifier:@"viewMisCotizaciones"];
    [self.view removeFromSuperview];
    [destinoCarrito didMoveToParentViewController:self];
    
    UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"Revisa el Carrito" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
    [alerta show];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Error");
    validaIMG = 0;
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
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)btnEditarNombre:(id)sender {
    txtNombre.text = lblNombre.text;
    txtNombre.hidden = NO;
}

- (IBAction)cambioNombre:(id)sender {
    if (txtNombre.text.length > 0) {
        
        //VALIDACION DEL ID DE LA COTIZACION EN EL NOMBRE
        BOOL validaIDCotizacionNombre = NO;
        @try {
            for (int i = 0; i < txtNombre.text.length; i++) {
                if ([[txtNombre.text substringWithRange:NSMakeRange(i, Cotizacion.ID.length)] isEqualToString:Cotizacion.ID]) {
                    validaIDCotizacionNombre = YES;
                }
            }
        }
        @catch (NSException *exception) {
            
        }
        
        if (validaIDCotizacionNombre == NO) {
            txtNombre.text = [NSString stringWithFormat:@"%@ %@", txtNombre.text, Cotizacion.ID];
        }
        
        [ConexionBD actualizarCotizacion:Cotizacion.ID fecha:Cotizacion.Fecha precio:Cotizacion.Precio items:Cotizacion.Items subTotal:Cotizacion.SubTotal ahorro:Cotizacion.Ahorro iva:Cotizacion.IVA nombre:txtNombre.text];
        lblNombre.text = txtNombre.text;
        txtNombre.hidden = YES;
    } else {
        UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"El campo nombre está vacío" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [alerta show];
    }
}

- (IBAction)valCaraters:(id)sender {
    if (txtNombre.text.length > 20) {
        NSString * txt = [txtNombre.text substringToIndex:txtNombre.text.length - 1];
        txtNombre.text = txt;
    }
    NSLog(@"CANT CARACTERES");
}

@end
