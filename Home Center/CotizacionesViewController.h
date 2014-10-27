//
//  CotizacionesViewController.h
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 3/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bd.h"
#import "cotizacion.h"
#import "cotizacion_detalle.h"

@interface CotizacionesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tabla;
@property(nonatomic, strong)bd * ConexionBD;
@property(nonatomic, strong)cotizacion * Cotizacion;
@property(nonatomic, strong)cotizacion_detalle * CotizacionDetalle;
@property(nonatomic, strong)NSMutableArray * listaCotizaciones;
@property (strong, nonatomic) IBOutlet UIImageView *imgMensaje;
@property (strong, nonatomic) IBOutlet UILabel *lblMensaje;
@property (strong, nonatomic) IBOutlet UIImageView *ayuda;
@property (strong, nonatomic) IBOutlet UIImageView *ayuda1;
@property (nonatomic, strong) NSMutableString * strNombreCotizacion;
@property(nonatomic, strong)UITextField * campoActivo;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *lblTitulo;

@end
