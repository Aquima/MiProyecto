//
//  ConsultasViewController.h
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 3/07/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bd.h"

@interface ConsultasViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, NSURLConnectionDataDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tabla;
@property (nonatomic, strong)NSMutableData * acumulaDatos;
@property (nonatomic, strong)NSMutableArray * listaPasillo;
@property (nonatomic, strong)NSMutableArray * listaReferencia;
@property (nonatomic, strong)NSMutableArray * listaOnClick;
@property (nonatomic, strong)NSMutableArray * listaSKU;
@property (strong, nonatomic) IBOutlet UITextField *txtConsulta;
- (IBAction)btnConsultar:(id)sender;
- (IBAction)ocultaTeclado:(id)sender;
@property (nonatomic, strong) bd * ConexionBD;

@end
