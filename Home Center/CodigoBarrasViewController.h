//
//  CodigoBarrasViewController.h
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 2/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bd.h"
#import "cotizacion.h"

@interface CodigoBarrasViewController : UIViewController

- (IBAction)cerrar:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imgCodigoBarras;
@property(nonatomic, strong)bd * ConexionBD;
@property(nonatomic, strong)cotizacion * Cotizacion;
@property (strong, nonatomic) IBOutlet UILabel *txtCotizacionID;
@property (strong, nonatomic) IBOutlet UILabel *txtCorreo;
@property (strong, nonatomic) IBOutlet UILabel *txtTextCorreo;

@end
