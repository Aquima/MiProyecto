//
//  cotizacion.h
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 1/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cotizacion : NSObject

@property(nonatomic, strong)NSString * ID;
@property(nonatomic, strong)NSString * Fecha;
@property(nonatomic, strong)NSString * Precio;
@property(nonatomic, strong)NSString * SubTotal;
@property(nonatomic, strong)NSString * Items;
@property(nonatomic, strong)NSString * Ahorro;
@property(nonatomic, strong)NSString * IVA;
@property(nonatomic, strong)NSString * Nombre;

@end
