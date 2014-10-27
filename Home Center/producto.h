//
//  producto.h
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 1/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface producto : NSObject

@property(nonatomic, strong)NSString * SKU;
@property(nonatomic, strong)NSString * nombre;
@property(nonatomic, strong)NSString * precio;
@property(nonatomic, strong)NSString * cant;
@property(nonatomic, strong)NSString * inspirate;
@property(nonatomic, strong)NSString * fichaTecnica;
@property(nonatomic, strong)NSString * precioNuevo;

@end
