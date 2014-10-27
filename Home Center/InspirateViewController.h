//
//  InspirateViewController.h
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 1/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bd.h"
#import "producto.h"

@interface InspirateViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)cerrar:(id)sender;
@property(nonatomic, strong)bd * ConexionBD;
@property(nonatomic, strong)producto * Producto;

@end
