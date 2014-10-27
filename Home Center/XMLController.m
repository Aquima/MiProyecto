//
//  XMLController.m
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 4/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import "XMLController.h"
#import "producto.h"

@implementation XMLController
@synthesize entidades, currentProducto, currentNodeContent, parser, OWS, ConexionBD, currentCotizacion, currentPedido, currentUsuario, indicador, cadena, ahorro;

-(id) loadXMLByURL:(NSData *) datos opcionWS:(NSString *)OpcionWS{
    ConexionBD = [[bd alloc]init];
    entidades = [[NSMutableArray alloc]init];
    OWS = OpcionWS;
	parser = [[NSXMLParser alloc] initWithData:datos];
	parser.delegate = self;
	[parser parse];
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
	if ([elementName isEqualToString:@"return"]) {
		currentProducto = [[producto alloc]init];
        currentCotizacion = [[cotizacion alloc]init];
        currentPedido = [[pedido alloc]init];
        currentUsuario = [[usuario alloc]init];
		currentNodeContent = [[NSMutableArray alloc] init];
        cadena = [[NSMutableString alloc]init];
        indicador = 0;
        ahorro = 0;
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([OWS isEqualToString:@"consultaProductoSKU"]) {
        
        if ([elementName isEqualToString:@"fichaTecnica"]) {
            [cadena appendString:currentNodeContent];
        }
        
        if ([elementName isEqualToString:@"inspirate"]) {
            currentProducto.inspirate = currentNodeContent;
        }
        if ([elementName isEqualToString:@"nombre"]) {
            NSData *stringData = [[currentNodeContent uppercaseString] dataUsingEncoding: NSASCIIStringEncoding allowLossyConversion: YES];
            currentProducto.nombre = [[NSString alloc] initWithData: stringData encoding: NSASCIIStringEncoding];
            NSLog(currentProducto.nombre);
        }
        if ([elementName isEqualToString:@"precio"]) {
            currentProducto.precio = currentNodeContent;
        }
        
        if ([elementName isEqualToString:@"sku"]) {
            currentProducto.SKU = currentNodeContent;
        }
    }
    
    if ([OWS isEqualToString:@"consultaProductosRelacionados"]) {
        if ([elementName isEqualToString:@"nombre"]) {
            currentProducto.nombre = currentNodeContent;
        }
        
        if ([elementName isEqualToString:@"sku"]) {
            currentProducto.SKU = currentNodeContent;
        }
        
        if ([elementName isEqualToString:@"precio"]) {
            currentProducto.precio = currentNodeContent;
            [entidades addObject:currentProducto];
        }
    }
    
    if ([OWS isEqualToString:@"guardarCotizacion"]) {
        if ([elementName isEqualToString:@"fechaVencimiento"]) {
            currentCotizacion.Fecha = currentNodeContent;
        }
        
        if ([elementName isEqualToString:@"idCotizacion"]) {
            currentCotizacion.ID = currentNodeContent;
            NSLog(currentNodeContent);
        }
        
        if ([elementName isEqualToString:@"impuesto"]) {
            currentCotizacion.IVA = currentNodeContent;
        }
        
        if ([elementName isEqualToString:@"descuento"] && indicador > 0) {
            ahorro = ahorro + currentNodeContent.doubleValue;
        }
        
        if ([elementName isEqualToString:@"subTotal"]) {
            currentCotizacion.SubTotal = currentNodeContent;
            NSLog(currentNodeContent);
        }
        
        if ([elementName isEqualToString:@"total"]) {
            currentCotizacion.Precio = currentNodeContent;
            NSLog(currentNodeContent);
        }
        indicador++;
        
    }
    
    if ([OWS isEqualToString:@"Pedidos"]) {
        if ([elementName isEqualToString:@"notaPedidoCodigo"]) {
            currentPedido.Estado = currentNodeContent;
        }
        
        if ([elementName isEqualToString:@"notaPedidoFechaCreacion"]) {
            currentPedido.Fecha = currentNodeContent;
        }
        
        if ([elementName isEqualToString:@"precio"]) {
            currentPedido.Precio = currentNodeContent;
            [entidades addObject:currentPedido];
            NSLog(currentNodeContent);
        }
    }
	
	if ([elementName isEqualToString:@"return"]) {
        
        if ([OWS isEqualToString:@"consultaProductoSKU"]) {
            [ConexionBD actualizaProducto:currentProducto.SKU nombre:currentProducto.nombre inspirate:currentProducto.inspirate precio:currentProducto.precio cant:@"0" ficha:cadena];
        }
        
        if ([OWS isEqualToString:@"consultaProductosRelacionados"]) {
            [ConexionBD eliminaProducto];
            for (int i = 0; i < entidades.count; i++) {
                currentProducto = [entidades objectAtIndex:i];
                NSLog(currentProducto.nombre);
                [ConexionBD registroProducto:currentProducto.SKU nombre:currentProducto.nombre inspirate:@"" precio:currentProducto.precio cant:@"0" ficha:@""];
            }
        }
        
        if ([OWS isEqualToString:@"guardarCotizacion"]) {
            NSMutableArray * listaCotizacion = [ConexionBD consultaCotizacion:currentCotizacion.ID];
            if (![currentCotizacion.ID isEqualToString:@"0"] && ![currentCotizacion.Precio isEqualToString:@"0"] && ![currentCotizacion.Precio isEqualToString:@"0.0"]) {
                if (listaCotizacion.count == 0) {
                    [ConexionBD registroCotizacion:currentCotizacion.ID fecha:currentCotizacion.Fecha precio:currentCotizacion.Precio items:@"" subTotal:currentCotizacion.SubTotal ahorro:[NSString stringWithFormat:@"%f", ahorro] iva:currentCotizacion.IVA nombre:[NSString stringWithFormat:@"Mi Cotización %@", currentCotizacion.ID]];
                    [ConexionBD eliminaCotizacionTemp];
                    [ConexionBD registroCotizacionTemp:currentCotizacion.ID fecha:currentCotizacion.Fecha precio:currentCotizacion.Precio items:@"" subTotal:currentCotizacion.SubTotal ahorro:[NSString stringWithFormat:@"%f", ahorro] iva:currentCotizacion.IVA nombre:[NSString stringWithFormat:@"Mi Cotización %@", currentCotizacion.ID]];
                } else {
                    NSMutableArray * listaC = [ConexionBD consultaCotizacion:currentCotizacion.ID];
                    cotizacion * Cotiz = [listaC objectAtIndex:0];
                    [ConexionBD actualizarCotizacion:currentCotizacion.ID fecha:currentCotizacion.Fecha precio:currentCotizacion.Precio items:@"" subTotal:currentCotizacion.SubTotal ahorro:[NSString stringWithFormat:@"%f", ahorro] iva:currentCotizacion.IVA nombre:Cotiz.Nombre];
                    [ConexionBD eliminaCotizacionTemp];
                    [ConexionBD registroCotizacionTemp:currentCotizacion.ID fecha:currentCotizacion.Fecha precio:currentCotizacion.Precio items:@"" subTotal:currentCotizacion.SubTotal ahorro:[NSString stringWithFormat:@"%f", ahorro] iva:currentCotizacion.IVA nombre:Cotiz.Nombre];
                }
            } else {
                [ConexionBD eliminaCotizacionTemp];
            }
        }
        
        if ([OWS isEqualToString:@"Pedidos"]) {
            [ConexionBD eliminaPedido];
            for (int i = 0; i < entidades.count; i++) {
                currentPedido = [entidades objectAtIndex:i];
                [ConexionBD registroPedido:currentPedido.Fecha estado:currentPedido.Estado precio:currentPedido.Precio];
            }
        }
        
        if ([OWS isEqualToString:@"EditarDatos"] && indicador == 0) {
            NSMutableArray * listaUsuario = [ConexionBD consultaUsuario];
            usuario * USER = [listaUsuario objectAtIndex:0];
            if ([USER.Estado isEqualToString:@"1"]) {
                [ConexionBD actualizaUsuario:USER.Correo estado:@"2" idUsuario:currentNodeContent];
            } else if ([USER.Estado isEqualToString:@"2"]) {
                [ConexionBD actualizaUsuario:USER.Correo estado:@"2" idUsuario:currentNodeContent];
            } else {
                [ConexionBD actualizaUsuario:USER.Correo estado:@"0" idUsuario:currentNodeContent];
            }
            
            NSLog(@"uio, %@", currentNodeContent);
        }
        
        if ([OWS isEqualToString:@"ActivarUsuario"] && indicador == 0) {
            NSLog(@"ACTIVO USUARIOOOOOOOO: %@", currentNodeContent);
            if ([currentNodeContent isEqualToString:@"1"]) {
                NSMutableArray * listaUsuario = [ConexionBD consultaUsuario];
                usuario * USER = [listaUsuario objectAtIndex:0];
                [ConexionBD actualizaUsuario:USER.Correo estado:@"1" idUsuario:USER.ID];
            }
        }
        
        indicador++;
        
		currentProducto = nil;
        currentCotizacion = nil;
        currentUsuario = nil;
        currentPedido = nil;
		currentNodeContent = nil;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	currentNodeContent = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
