//
//  XMLController.h
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 4/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import <Foundation/Foundation.h>
@class producto;
#import "cotizacion.h"
#import "bd.h"
#import "pedido.h"
#import "usuario.h"

@interface XMLController : NSObject

@property (nonatomic, strong) NSMutableArray *entidades;
@property (nonatomic, strong) producto * currentProducto;
@property (nonatomic, strong) cotizacion * currentCotizacion;
@property (nonatomic, strong) usuario * currentUsuario;
@property (nonatomic, strong) pedido * currentPedido;
@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, strong) NSMutableString *currentNodeContent;
@property (nonatomic, strong)NSString * OWS;
@property (nonatomic, strong)bd * ConexionBD;
@property (nonatomic, assign)int * indicador;
@property (nonatomic, strong)NSMutableString * cadena;
@property (nonatomic, assign)double ahorro;

-(id) loadXMLByURL:(NSData *)datos opcionWS:(NSString *)OpcionWS;

@end
