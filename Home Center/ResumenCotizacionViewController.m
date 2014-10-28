//
//  ResumenCotizacionViewController.m
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 2/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import "ResumenCotizacionViewController.h"
#import "CodigoBarrasViewController.h"
#import "CarritoViewController.h"
#import "usuario.h"

@interface ResumenCotizacionViewController (){
    int opcionInternet;
}

@end

@implementation ResumenCotizacionViewController
@synthesize txtTotal, imgCodigoBarras, tabla, ConexionBD, Producto, Cotizacion, acumulaDatos, listaCarrito, imgFoto, scrollView, txtCotizacionID, lblTextCotID, txtCLICKImg, btnLlamar, lblTextTotal, lblM1, lblM3;

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
    
    NSMutableArray * listaCotizacion = [ConexionBD consultaCotizacionTemp];
    Cotizacion = [listaCotizacion objectAtIndex:0];
    
    [scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(320, 510)];
    
    listaCarrito = [ConexionBD consultaCarrito];
    
    [[[[[self tabBarController]tabBar]items]objectAtIndex:1]setBadgeValue:@"0"];
    
    NSNumberFormatter * formater = [[NSNumberFormatter alloc]init];
    formater.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber * number = [[NSNumber alloc]initWithDouble:Cotizacion.Precio.doubleValue];
    NSMutableString * preci0;//
    [preci0 appendString:[formater stringFromNumber:number]];
    //= [formater stringFromNumber:number];
    NSString * numeroMostrar = [preci0 stringByReplacingOccurrencesOfString:@"," withString:@"."];
    txtTotal.text = numeroMostrar;
    
    [ConexionBD vaciaCarrito];
    
    [tabla reloadData];
    
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.programaaplicode.com/codigoBarras.php?width=1000&height=500&barcode=%@", Cotizacion.ID]];
    NSData * data = [NSData dataWithContentsOfURL:url];
    imgCodigoBarras.image = [UIImage imageWithData:data];
    
    [imgCodigoBarras setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    [singleTap setNumberOfTapsRequired:1];
    [imgCodigoBarras addGestureRecognizer:singleTap];
    
    txtCotizacionID.text = Cotizacion.ID;
    
    [lblTextCotID setFont:[UIFont fontWithName:@"Miso-Light" size:12.0]];
    [txtCotizacionID setFont:[UIFont fontWithName:@"Miso-Light" size:12.0]];
    [txtCLICKImg setFont:[UIFont fontWithName:@"Miso" size:10.0]];
    [txtTotal setFont:[UIFont fontWithName:@"Miso" size:24.0]];
    [lblTextTotal setFont:[UIFont fontWithName:@"Miso" size:24.0]];
    [lblM1 setFont:[UIFont fontWithName:@"Miso-Light" size:12.0]];
    [lblM3 setFont:[UIFont fontWithName:@"Miso" size:14.0]];
}

-(void)viewWillAppear:(BOOL)animated{
    [ConexionBD eliminaTabControl];
    [ConexionBD registroTabControl:@"ResumenCotizacion"];
    [super viewWillAppear:YES];
}

-(void)singleTapping:(UIGestureRecognizer *)recognizer
{
    [ConexionBD eliminaTabControl];
    [ConexionBD registroTabControl:@"Barcode"];
    CodigoBarrasViewController * destino = [self.storyboard instantiateViewControllerWithIdentifier:@"viewCodigoBarras"];
    destino.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:destino animated:YES completion:NULL];
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
	
    NSNumberFormatter * formater = [[NSNumberFormatter alloc]init];
    formater.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber * number = [[NSNumber alloc]initWithInteger:Producto.precioNuevo.integerValue];
    NSMutableString * preci0 = [formater stringFromNumber:number];
    NSString * numeroMostrar = [preci0 stringByReplacingOccurrencesOfString:@"," withString:@"."];
    
    imgFoto = (UIImageView *)[cell viewWithTag:100];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://homecenterco.scene7.com/is/image/SodimacCO/%@?lista160", Producto.SKU]];
    NSData * data = [NSData dataWithContentsOfURL:url];
    imgFoto.image = [UIImage imageWithData:data];
    
    
	UILabel * lblNombre = (UILabel*)[cell viewWithTag:200];
    lblNombre.text = Producto.nombre;
    
    UILabel * lblSKU = (UILabel*)[cell viewWithTag:800];
    lblSKU.text = [NSString stringWithFormat:@"SKU %@", Producto.SKU];
    
    UILabel * lblCantidad = (UILabel*)[cell viewWithTag:300];
    lblCantidad.text = Producto.cant;
    UILabel * lblPrecio = (UILabel*)[cell viewWithTag:400];
    lblPrecio.text = [NSString stringWithFormat:@"$ %@", numeroMostrar];
    
    [lblNombre setFont:[UIFont fontWithName:@"Miso-Light" size:16.0]];
    [lblSKU setFont:[UIFont fontWithName:@"Miso" size:15.0]];
    [lblCantidad setFont:[UIFont fontWithName:@"Miso" size:12.0]];
    [lblPrecio setFont:[UIFont fontWithName:@"Miso" size:19.0]];
    
    return cell;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [acumulaDatos appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (opcionInternet == 1) {
        imgFoto.image = [UIImage imageWithData:acumulaDatos];
    }
    
    if (opcionInternet == 2) {
        
    }
}

- (IBAction)llamar:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://018000120490"]];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
