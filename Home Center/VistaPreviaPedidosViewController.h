//
//  VistaPreviaPedidosViewController.h
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 25/07/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VistaPreviaPedidosViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDataDelegate>

- (IBAction)volver:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tabla;
@property (strong, nonatomic) IBOutlet UILabel *txtTotal;

@property (nonatomic, strong) NSNumberFormatter * formater;
@property (nonatomic, strong) NSNumber * number;
@property (nonatomic, strong) NSMutableString * preci0;
@property (nonatomic, strong) NSMutableString * numeroMostrar;

@property (nonatomic, strong) NSMutableArray * listaNombre;
@property (nonatomic, strong) NSMutableArray * listaPrecio;
@property (nonatomic, strong) NSMutableArray * listaCantidad;
@property (nonatomic, strong) NSMutableArray * listaSKU;

@property (nonatomic, strong) NSMutableArray * listaDatosIMG;
@property (nonatomic, strong)NSMutableData * acumulaDatos;
@property (strong, nonatomic) IBOutlet UILabel *lblVerificaPrecio;
@property (strong, nonatomic) IBOutlet UILabel *lblTotla;

@end
