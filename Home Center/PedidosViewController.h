//
//  PedidosViewController.h
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 5/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pedido.h"
#import "bd.h"


@interface PedidosViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDataDelegate>

@property (nonatomic, strong)NSMutableData * acumulaDatos;
@property (nonatomic, strong)NSMutableArray * listaPedidos;
@property (nonatomic, strong)pedido * Pedido;
@property (strong, nonatomic) IBOutlet UITableView *tabla;
@property (nonatomic, strong)bd * ConexionBD;
@property (strong, nonatomic) IBOutlet UIView *vistaCargando;
@property (strong, nonatomic) IBOutlet UIImageView *imgCargando;
@property (nonatomic, strong) NSMutableArray * listaCodigo;
@property (nonatomic, strong) NSMutableArray * listaEstado;
@property (nonatomic, strong) NSMutableArray * listaFecha;
@property (nonatomic, strong) NSMutableArray * listaPrecio;
@property (nonatomic, strong) NSMutableArray * listaProductoPrecio;
@property (nonatomic, strong) NSMutableString * textoResultado;

@property (nonatomic, strong) NSMutableArray * listaNombre;
@property (nonatomic, strong) NSMutableArray * listaPrecioVistaPrevia;
@property (nonatomic, strong) NSMutableArray * listaCantidad;
@property (nonatomic, strong) NSMutableArray * listaSKU;
- (IBAction)volver:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblTitulo;

@end
