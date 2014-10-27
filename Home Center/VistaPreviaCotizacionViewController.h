//
//  VistaPreviaCotizacionViewController.h
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 18/07/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bd.h"
#import "producto.h"
#import "cotizacion_detalle.h"
#import "cotizacion.h"

@interface VistaPreviaCotizacionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDataDelegate>

- (IBAction)btnVolver:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tabla;
@property (strong, nonatomic) IBOutlet UILabel *txtSubTotal;
@property (strong, nonatomic) IBOutlet UILabel *txtIVA;
@property (strong, nonatomic) IBOutlet UILabel *txtAhorro;
@property (strong, nonatomic) IBOutlet UILabel *txtTotal;

@property(nonatomic, strong)NSMutableArray * listaCarrito;
@property(nonatomic, strong)bd * ConexionBD;
@property(nonatomic, strong)cotizacion_detalle * Producto;

@property (nonatomic, strong) NSNumberFormatter * formater;
@property (nonatomic, strong) NSNumber * number;
@property (nonatomic, strong) NSMutableString * preci0;
@property (nonatomic, strong) NSMutableString * numeroMostrar;
@property (strong, nonatomic) IBOutlet UIButton *btnEdita;

@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
@property (nonatomic, strong)NSString * idCotizacion;
- (IBAction)btnEditar:(id)sender;

@property (nonatomic, strong) NSMutableArray * listaDatosIMG;
@property (nonatomic, strong)NSMutableData * acumulaDatos;

@property (strong, nonatomic) IBOutlet UILabel *lblNombre;
- (IBAction)btnEditarNombre:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtNombre;
@property (nonatomic, strong) cotizacion * Cotizacion;

- (IBAction)cambioNombre:(id)sender;
- (IBAction)valCaraters:(id)sender;


@end
