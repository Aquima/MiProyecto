//
//  EditarCorreoViewController.h
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 2/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bd.h"
#import "usuario.h"

@interface EditarCorreoViewController : UIViewController <UITextFieldDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtCorreo;
- (IBAction)enviarTC:(id)sender;
@property(nonatomic, strong)UITextField * campoActivo;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic, strong)bd * ConexionBD;
@property (nonatomic, strong)NSMutableData * acumulaDatos;
@property (strong, nonatomic) IBOutlet UIButton *btnVolver;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)voverTC:(id)sender;
- (IBAction)TC:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *vistaCargando;
@property (strong, nonatomic) IBOutlet UIImageView *imgCargando;
-(BOOL) NSStringIsValidEmail:(NSString *)checkString;
@property (nonatomic, strong) NSMutableArray * listaUsuario;
@property (nonatomic, strong) usuario * Usuario;
@property (strong, nonatomic) IBOutlet UIButton *btnEnviar;
@property (strong, nonatomic) IBOutlet UILabel *lblTitulo;
@property (strong, nonatomic) IBOutlet UIButton *btnTC;
@property (strong, nonatomic) IBOutlet UIImageView *imgTitulo;

@end
