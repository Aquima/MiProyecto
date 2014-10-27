//
//  ActivarCuentaViewController.h
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 2/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bd.h"
#import "usuario.h"

@interface ActivarCuentaViewController : UIViewController<UITextFieldDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)activadoCuenta:(id)sender;
//@property (strong, nonatomic) IBOutlet UITextField *txtCorreo;
- (IBAction)reenviarCorreo:(id)sender;
//@property(nonatomic, strong)UITextField * campoActivo;
@property(nonatomic, strong)bd * ConexionBD;
@property (nonatomic, strong)NSMutableData * acumulaDatos;
@property (strong, nonatomic) IBOutlet UIView *vistaCargando;
@property (strong, nonatomic) IBOutlet UIImageView *imgCargando;
@property (nonatomic, strong) NSMutableArray * listaUsuario;
@property (nonatomic, strong) usuario * Usuario;

@property (strong, nonatomic) IBOutlet UIWebView *webView1;
@property (strong, nonatomic) IBOutlet UIWebView *webView2;
@property (strong, nonatomic) IBOutlet UIWebView *webView3;
@property (strong, nonatomic) IBOutlet UILabel *lblTitulo;
@property (strong, nonatomic) IBOutlet UIButton *btnActivar;
@property (strong, nonatomic) IBOutlet UIButton *btnReenviar;

@end
