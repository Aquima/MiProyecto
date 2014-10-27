//
//  VistaPreviaPedidosViewController.m
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 25/07/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import "VistaPreviaPedidosViewController.h"
#import "PedidosViewController.h"

@interface VistaPreviaPedidosViewController (){
    double Total;
    int validaIMG;
}

@end

@implementation VistaPreviaPedidosViewController
@synthesize formater, number, numeroMostrar, tabla, preci0, txtTotal, listaPrecio, listaCantidad, listaNombre, listaSKU, listaDatosIMG, acumulaDatos, lblTotla, lblVerificaPrecio;

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
    
    Total = 0;
    
    for (int i = 0; i < [listaPrecio count]; i++) {
        NSLog([NSString stringWithFormat:@"Precio: %@", [listaPrecio objectAtIndex:i]]);
        Total = Total + [NSString stringWithFormat:@"%@", [listaPrecio objectAtIndex:i]].doubleValue;
    }
    
    formater = [[NSNumberFormatter alloc]init];
    formater.numberStyle = NSNumberFormatterDecimalStyle;
    number = [[NSNumber alloc]initWithDouble:Total];
    preci0 = [formater stringFromNumber:number];
    numeroMostrar = [preci0 stringByReplacingOccurrencesOfString:@"," withString:@"."];
    txtTotal.text = numeroMostrar;
    
    //vistaCargando.hidden = NO;
    listaDatosIMG = [[NSMutableArray alloc]init];

    NSMutableString * parametros = [[NSMutableString alloc]init];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://homecenterco.scene7.com/is/image/SodimacCO/%@?lista160", [listaSKU objectAtIndex:0]]];

    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setHTTPBody:[parametros dataUsingEncoding:NSUTF8StringEncoding]];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    NSURLConnection * conexion = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    acumulaDatos = [[NSMutableData alloc]init];
    validaIMG = 1;
    
    [lblVerificaPrecio setFont:[UIFont fontWithName:@"Miso" size:12.0]];
    [lblTotla setFont:[UIFont fontWithName:@"Miso" size:23.0]];
    [txtTotal setFont:[UIFont fontWithName:@"Miso" size:23.0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listaSKU count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"celda";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSNumberFormatter * formater1 = [[NSNumberFormatter alloc]init];
    formater1.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber * number1 = [[NSNumber alloc]initWithDouble:[NSString stringWithFormat:@"%@", [listaPrecio objectAtIndex:indexPath.row]].doubleValue];
    NSMutableString * preci00 = [[NSMutableString alloc]init];
    [preci00 appendString:[formater1 stringFromNumber:number1]];
    NSLog(preci00);
    NSString * numeroMostrar1 = [preci00 stringByReplacingOccurrencesOfString:@"," withString:@"."];
    
    NSLog(@"PRECIO FORMATIADO %@", numeroMostrar);
    
    UIImageView * imgFoto = (UIImageView *)[cell viewWithTag:100];
    
    imgFoto = (UIImageView *)[cell viewWithTag:100];
    /*NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://homecenterco.scene7.com/is/image/SodimacCO/%@?lista160", [listaSKU objectAtIndex:indexPath.row]]];
    NSData * data = [NSData dataWithContentsOfURL:url];
    imgFoto.image = [UIImage imageWithData:data];*/
    if (listaDatosIMG.count == listaSKU.count) {
        imgFoto.image = [UIImage imageWithData:[listaDatosIMG objectAtIndex:indexPath.row]];
    }
    
	UILabel * lblNombre = (UILabel*)[cell viewWithTag:200];
    lblNombre.text = [listaNombre objectAtIndex:indexPath.row];
    UILabel * lblCantidad = (UILabel*)[cell viewWithTag:300];
    lblCantidad.text = [NSString stringWithFormat:@"Cantidad: %@", [listaCantidad objectAtIndex:indexPath.row]];
    
    
    UILabel * lblPrecio = (UILabel*)[cell viewWithTag:400];
    lblPrecio.text = [NSString stringWithFormat:@"$ %@", numeroMostrar1];
    
    [lblNombre setFont:[UIFont fontWithName:@"Miso-Light" size:16.0]];
    [lblCantidad setFont:[UIFont fontWithName:@"Miso" size:12.0]];
    [lblPrecio setFont:[UIFont fontWithName:@"Miso" size:23.0]];
    
    return cell;
}

- (IBAction)volver:(id)sender {
    PedidosViewController * destinoCarrito = [self.storyboard instantiateViewControllerWithIdentifier:@"viewPedidos"];
    [self.view removeFromSuperview];
    [destinoCarrito didMoveToParentViewController:self];
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
        if (listaSKU.count == listaDatosIMG.count) {
            validaIMG = 0;
            [tabla reloadData];
            NSLog(@"Entro1");
        } else {
            NSLog(@"INDEX %d", listaDatosIMG.count);

            NSMutableString * parametros = [[NSMutableString alloc]init];
            NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://homecenterco.scene7.com/is/image/SodimacCO/%@?lista160", [listaSKU objectAtIndex:listaDatosIMG.count]]];

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

@end
