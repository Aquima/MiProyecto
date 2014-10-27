//
//  ViewController.h
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 20/05/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PosicionamientoController.h"
#import "bd.h"

@interface ViewController : UIViewController <NSURLConnectionDataDelegate>

@property(nonatomic, strong)NSMutableData * acumulaDatos;
@property(nonatomic, strong)NSMutableData * acumulaDatosWS;
@property(nonatomic, strong)PosicionamientoController * posicionamientoController;
@property (strong, nonatomic) IBOutlet UIImageView *imgCargando;
@property(nonatomic, strong)bd * ConexionBD;

@end
