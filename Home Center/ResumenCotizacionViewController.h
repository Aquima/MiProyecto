//
//  ResumenCotizacionViewController.h
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 2/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bd.h"
#import "cotizacion.h"
#import "producto.h"

@interface ResumenCotizacionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDataDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgCodigoBarras;
- (IBAction)llamar:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *txtTotal;
@property (strong, nonatomic) IBOutlet UITableView *tabla;
@property (nonatomic, strong)UIImageView * imgFoto;
@property(nonatomic, strong)bd * ConexionBD;
@property(nonatomic, strong)producto * Producto;
@property(nonatomic, strong)cotizacion * Cotizacion;
@property(nonatomic, strong)NSMutableArray * listaCarrito;
@property (nonatomic, strong)NSMutableData * acumulaDatos;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *txtCotizacionID;
@property (strong, nonatomic) IBOutlet UIButton *btnLlamar;
@property (strong, nonatomic) IBOutlet UILabel *lblTextCotID;
@property (strong, nonatomic) IBOutlet UILabel *txtCLICKImg;
@property (strong, nonatomic) IBOutlet UILabel *lblTextTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblM1;
@property (strong, nonatomic) IBOutlet UILabel *lblM3;

@end
