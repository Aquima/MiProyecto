//
//  bd.h
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 1/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface bd : NSObject
{
    sqlite3 * BaseDatos;
}

-(NSString *) obtenerRutaBD;

//Metodos ayuda
-(void)registroAyuda:(NSString *)Menu productoEncontrado:(NSString *)ProductoEncontrado carrito:(NSString *)Carrito cotizaciones:(NSString *)Cotizaciones mas:(NSString *)Mas;
-(void)actualizaAyuda:(NSString *)Menu productoEncontrado:(NSString *)ProductoEncontrado carrito:(NSString *)Carrito cotizaciones:(NSString *)Cotizaciones mas:(NSString *)Mas;
-(NSMutableArray *)consultaAyuda;

//Metodos ViewDidLoad Escanear
-(void)registroVEscanear:(NSString *)Visto;
-(NSString *)consultaVEscanear;
-(void)eliminaVEscanear;

//Metodos Notificacion
-(void)registroNotificacion:(NSString *)Token;
-(NSString *)consultaNotificacion;
-(void)eliminaNotificacion;

//Metodos QR
-(void)registroQR:(NSString *)QR;
-(NSString *)consultaQR;
-(void)eliminaQR;

//Metodos token
-(void)registroToken:(NSString *)Token;
-(NSString *)consultaToken;
-(void)eliminaToken;

//Metodos Pedido
-(void)registroPedido:(NSString *)Fecha estado:(NSString *)Estado precio:(NSString *)Precio;
-(void)eliminaPedido;
-(NSMutableArray *)consultaPedidos;

//Metodos usuario
-(void)registroUsuario:(NSString *)Correo estado:(NSString *)Estado idUsuario:(NSString *)ID;
-(NSMutableArray *)consultaUsuario;
-(void)actualizaUsuario:(NSString *)Correo estado:(NSString *)Estado idUsuario:(NSString *)ID;
-(void)eliminaUsuario;

//Metodos tabControl
-(void)registroTabControl:(NSString *)Opcion;
-(NSString *)consultaTabControl;
-(void)eliminaTabControl;

//Metodos web_service
-(void)registroOpcionWS:(NSString *)opcionWS;
-(NSString *)consultaOpcionWS;
-(void)eliminaOpcionWS;

//Metodos localizacion
-(void)registroLocalizacion:(NSString *)ciudad;
-(NSString *)consultaLocalizacion;
-(void)eliminaLocalizacion;

//Metodos video
-(void)registroVideo:(NSString *)Opcion;
-(NSString *)consultaVideo;
-(void)eliminaVideo;

//Metodos producto
-(void)registroProducto:(NSString *)SKU nombre:(NSString *)Nombre inspirate:(NSString *)Inspirate precio:(NSString *)Precio cant:(NSString *)Cant ficha:(NSString *)Ficha;
-(NSMutableArray *)consultaProducto;
-(void)eliminaProducto;
-(void)actualizaProducto:(NSString *)SKU nombre:(NSString *)Nombre inspirate:(NSString *)Inspirate precio:(NSString *)Precio cant:(NSString *)Cant ficha:(NSString *)Ficha;

//Metodos producto TEMP
-(void)registroProductoTEMP:(NSString *)SKU nombre:(NSString *)Nombre inspirate:(NSString *)Inspirate precio:(NSString *)Precio cant:(NSString *)Cant ficha:(NSString *)Ficha;
-(NSMutableArray *)consultaProductoTEMP;
-(void)eliminaProductoTEMP;

//Metodos carrito
-(void)registroCarrito:(NSString *)SKU nombre:(NSString *)Nombre precio:(NSString *)Precio cant:(NSString *)Cant precioNuevo:(NSString *)PrecioNuevo;
-(NSMutableArray *)consultaCarritoSKU:(NSString *)SKU;
-(void)actualizarCarrito:(NSString *)SKU nombre:(NSString *)Nombre precio:(NSString *)Precio cant:(NSString *)Cant precioNuevo:(NSString *)PrecioNuevo;
-(NSMutableArray *)consultaCarrito;
-(void)eliminaCarrito:(NSString *)SKU;
-(void)vaciaCarrito;

//Metodos cotizacion
-(void)registroCotizacion:(NSString *)CotizacionID fecha:(NSString *)Fecha precio:(NSString *)Precio items:(NSString *)Items subTotal:(NSString *)SubTotal ahorro:(NSString *)Ahorro iva:(NSString *)IVA nombre:(NSString *)Nombre;
-(NSMutableArray *)consultaCotizacion:(NSString *)CotizacionID;
-(void)actualizarCotizacion:(NSString *)CotizacionID fecha:(NSString *)Fecha precio:(NSString *)Precio items:(NSString *)Items subTotal:(NSString *)SubTotal ahorro:(NSString *)Ahorro iva:(NSString *)IVA nombre:(NSString *)Nombre;
-(NSMutableArray *)consultaCotizaciones;
-(void)eliminarCotizacion:(NSString *)ID;

//Metodos cotizacion temp
-(void)registroCotizacionTemp:(NSString *)CotizacionID fecha:(NSString *)Fecha precio:(NSString *)Precio items:(NSString *)Items subTotal:(NSString *)SubTotal ahorro:(NSString *)Ahorro iva:(NSString *)IVA nombre:(NSString *)Nombre;
-(NSMutableArray *)consultaCotizacionTemp;
-(void)eliminaCotizacionTemp;


//Metodos cotizacion_detalle
-(void)registroCotizacionDetalle:(NSString *)CotizacionID sku:(NSString *)SKU nombre:(NSString *)Nombre precio:(NSString *)Precio cant:(NSString *)Cant;
-(void)eliminaCotizacionDetalle:(NSString *)CotizacionID;
-(NSMutableArray *)consultaCotizacionDetalle:(NSString *)CotizacionID;

//Metodos boton
-(void)registroBoton;
-(void)eliminaBoton;
-(NSString *)consultaBoton;

//Metodos Valida WS
-(void)registroValidaWS:(NSString *)Valor;
-(void)eliminaValidaWS;
-(NSString *)consultaValidaWS;

@end
