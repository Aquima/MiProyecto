//
//  MasViewController.h
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 2/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bd.h"

@interface MasViewController : UIViewController <NSURLConnectionDataDelegate>

- (IBAction)editarCorreo:(id)sender;
@property(nonatomic, strong)bd * ConexionBD;
@property (strong, nonatomic) IBOutlet UIButton *verVideo;
- (IBAction)irVideo:(id)sender;
- (IBAction)irTerminosCondiciones:(id)sender;
- (IBAction)volverTerminosCondiciones:(id)sender;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *btnVolver;
@property (strong, nonatomic) IBOutlet UIImageView *ayuda;
@property (strong, nonatomic) IBOutlet UIImageView *ayuda1;
@property (strong, nonatomic) IBOutlet UIImageView *ayuda2;
@property (strong, nonatomic) IBOutlet UIImageView *ayuda3;
- (IBAction)btnMisCompras:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *ayuda4;

@property (strong, nonatomic) IBOutlet UILabel *lblOpciones;
@property (strong, nonatomic) IBOutlet UIButton *btnVerVideo;
@property (strong, nonatomic) IBOutlet UIButton *btnMisCompras;
@property (strong, nonatomic) IBOutlet UIButton *btnEditarCorre;
@property (strong, nonatomic) IBOutlet UIButton *btnVerTC;
- (IBAction)encuesta:(id)sender;

@property (nonatomic, strong)NSMutableData * acumulaDatos;
@property (strong, nonatomic) IBOutlet UIImageView *imgTitulo;
@property (strong, nonatomic) IBOutlet UIImageView *ayuda5;

@end
