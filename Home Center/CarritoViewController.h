//
//  CarritoViewController.h
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 2/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bd.h"
#import "producto.h"

@interface CarritoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDataDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tabla;
@property (strong, nonatomic) IBOutlet UILabel *txtSubTotal;
@property (strong, nonatomic) IBOutlet UILabel *txtIVA;
@property (strong, nonatomic) IBOutlet UILabel *txtAhorro;
@property (strong, nonatomic) IBOutlet UILabel *txtTotal;
- (IBAction)generaCotizacion:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnGeneraCotizacion;
@property(nonatomic, strong)NSMutableArray * listaCarrito;
@property(nonatomic, strong)bd * ConexionBD;
@property(nonatomic, strong)producto * Producto;
@property (nonatomic, strong)UIImageView * imgFoto;
@property (strong, nonatomic) IBOutlet UITabBarItem *iconoCarrito;
@property (strong, nonatomic) IBOutlet UIImageView *imgMensaje;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *Cargando;
@property (nonatomic, strong)NSMutableData * acumulaDatos;
@property (strong, nonatomic) IBOutlet UIView *vistaCargando;
@property (strong, nonatomic) IBOutlet UIImageView *imgCargando;
@property (strong, nonatomic) IBOutlet UIImageView *ayuda;
@property (strong, nonatomic) IBOutlet UIImageView *ayuda1;

@property (nonatomic, strong) NSNumberFormatter * formater;
@property (nonatomic, strong) NSNumber * number;
@property (nonatomic, strong) NSMutableString * preci0;
@property (nonatomic, strong) NSMutableString * numeroMostrar;
@property (nonatomic, strong) NSMutableArray * listaDatosIMG;
@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblVerificaPrecios;

@property (nonatomic, strong) NSMutableString * activoGC;
@property (nonatomic, assign) int validaGC;

@end
