//
//  ProductoEncontradoViewController.h
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 1/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bd.h"
#import "producto.h"

@interface ProductoEncontradoViewController : UIViewController <UITextFieldDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) IBOutlet UILabel *txtNombreProducto;
- (IBAction)verDetalleProducto:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *txtSKUProducto;
@property (strong, nonatomic) IBOutlet UILabel *txtPrecioProducto;
- (IBAction)agregrarCotizador:(id)sender;
- (IBAction)inspirate:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtCant;
@property (strong, nonatomic) IBOutlet UIImageView *imgProducto;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic, strong)bd * ConexionBDPE;
@property(nonatomic, strong)producto * ProductoPE;
@property(nonatomic, strong)UITextField * campoActivo;

@property (nonatomic, strong)NSMutableData * acumulaDatos;
- (IBAction)PR1:(id)sender;
- (IBAction)PR2:(id)sender;
- (IBAction)PR3:(id)sender;
- (IBAction)PR4:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnVerDetalle;

@property (strong, nonatomic) IBOutlet UIView *vistaDetalle;
@property (strong, nonatomic) IBOutlet UIButton *btnInspirate;
@property (strong, nonatomic) IBOutlet UIButton *ocultarCaracteristicas;
- (IBAction)btnOcultarDetalle:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *flechaAbajo;


@property (strong, nonatomic) IBOutlet UIButton *btn1;
@property (strong, nonatomic) IBOutlet UIButton *btn2;
@property (strong, nonatomic) IBOutlet UIButton *btn3;
@property (strong, nonatomic) IBOutlet UIButton *btn4;
@property (strong, nonatomic) IBOutlet UILabel *lbl1;
@property (strong, nonatomic) IBOutlet UILabel *lbl2;
@property (strong, nonatomic) IBOutlet UILabel *lbl3;
@property (strong, nonatomic) IBOutlet UILabel *lbl4;
@property (strong, nonatomic) IBOutlet UILabel *txtProductoRelacionado;
@property (strong, nonatomic) IBOutlet UITextView *txtDetalleProducto;
@property (strong, nonatomic) IBOutlet UIView *vistaCargando;
@property (strong, nonatomic) IBOutlet UIImageView *imgCargando;
@property (strong, nonatomic) IBOutlet UILabel *lblPrecio1;
@property (strong, nonatomic) IBOutlet UILabel *lblPrecio2;
@property (strong, nonatomic) IBOutlet UILabel *lblPrecio3;
@property (strong, nonatomic) IBOutlet UILabel *lblPrecio4;
@property (strong, nonatomic) IBOutlet UIImageView *ayuda1;
@property (strong, nonatomic) IBOutlet UIImageView *ayuda2;
@property (strong, nonatomic) IBOutlet UIImageView *ayuda3;
@property (strong, nonatomic) IBOutlet UIImageView *ayuda;
@property (strong, nonatomic) IBOutlet UILabel *lblCant;
@property (strong, nonatomic) IBOutlet UILabel *lblPrecio;
@property (strong, nonatomic) IBOutlet UILabel *lblProdRel;
@property (strong, nonatomic) IBOutlet UILabel *lblPD2;
@property (strong, nonatomic) IBOutlet UIWebView *webViewProductoDetalle;
@property (strong, nonatomic) IBOutlet UILabel *lblDetP;
@property (strong, nonatomic) IBOutlet UILabel *lblPD1;
@property (strong, nonatomic) IBOutlet UILabel *labelUltimo;

@end
