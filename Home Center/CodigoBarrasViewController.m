//
//  CodigoBarrasViewController.m
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 2/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import "CodigoBarrasViewController.h"
#import "usuario.h"

@interface CodigoBarrasViewController ()

@end

@implementation CodigoBarrasViewController
@synthesize ConexionBD, Cotizacion, imgCodigoBarras, txtCotizacionID, txtCorreo, txtTextCorreo;

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
    NSMutableArray * listaCotizacion = [ConexionBD consultaCotizacionTemp];
    Cotizacion = [listaCotizacion objectAtIndex:0];
    
    
    NSLog(@"COTIZACION ID: %@",Cotizacion.ID);
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.programaaplicode.com/codigoBarras.php?width=1000&height=500&barcode=%@", Cotizacion.ID]];
    
    NSData * data = [NSData dataWithContentsOfURL:url];
    imgCodigoBarras.image = [UIImage imageWithData:data];
    
    txtCotizacionID.text = [NSString stringWithFormat:@"Código de cotización \n %@", Cotizacion.ID];
    
    NSMutableArray * listaUsuario = [ConexionBD consultaUsuario];
    usuario * Usuario = [listaUsuario objectAtIndex:0];
    txtCorreo.text = Usuario.Correo;
    
    [txtCorreo setFont:[UIFont fontWithName:@"Miso" size:18.0]];
    [txtTextCorreo setFont:[UIFont fontWithName:@"Miso" size:18.0]];
    [txtCotizacionID setFont:[UIFont fontWithName:@"Miso" size:18.0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cerrar:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
