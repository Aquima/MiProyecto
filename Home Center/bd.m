//
//  bd.m
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 1/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import "bd.h"
#import "producto.h"
#import "cotizacion.h"
#import "cotizacion_detalle.h"
#import "usuario.h"
#import "pedido.h"
#import "ayudas.h"

@implementation bd

//Ruta de la base de datos en el bundle
- (NSString *) obtenerRutaBD{
    NSString *dirDocs;
    NSArray *rutas;
    NSString *rutaBD;
    
    rutas = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    dirDocs = [rutas objectAtIndex:0];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    rutaBD = [[NSString alloc] initWithString:[dirDocs stringByAppendingPathComponent:@"bdsodimac.sqlite"]];
    
    if([fileMgr fileExistsAtPath:rutaBD] == NO){
        [fileMgr copyItemAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"bdsodimac.sqlite"] toPath:rutaBD error:NULL];
    }
    
    return rutaBD;
}

//Metodos ayudas
-(void)registroAyuda:(NSString *)Menu productoEncontrado:(NSString *)ProductoEncontrado carrito:(NSString *)Carrito cotizaciones:(NSString *)Cotizaciones mas:(NSString *)Mas{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO ayudas (ayuda_menu, ayuda_producto_encontrado, ayuda_carrito, ayuda_cotizaciones, ayuda_mas) VALUES ('%@', '%@', '%@', '%@', '%@')", Menu, ProductoEncontrado, Carrito, Cotizaciones, Mas];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Registro Ayuda");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Registro Ayuda");
            }
        }
    }
}

-(void)actualizaAyuda:(NSString *)Menu productoEncontrado:(NSString *)ProductoEncontrado carrito:(NSString *)Carrito cotizaciones:(NSString *)Cotizaciones mas:(NSString *)Mas{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"UPDATE ayudas SET ayuda_menu = '%@', ayuda_producto_encontrado = '%@', ayuda_carrito = '%@', ayuda_cotizaciones = '%@', ayuda_mas = '%@'", Menu, ProductoEncontrado, Carrito, Cotizaciones, Mas];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Ayuda actualizada");
            }
        }
    }
}

-(NSMutableArray *)consultaAyuda{
    NSMutableArray * listaAyuda = [[NSMutableArray alloc] init];
	NSString * ubicacionDB = [self obtenerRutaBD];
	
	if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
		NSLog(@"No se puede conectar con la BD");
	}
    const char *sentenciaSQL = "SELECT * FROM ayudas";
	sqlite3_stmt *sqlStatement;
	
	if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
		NSLog(@"Problema al preparar el statement");
	}
	
	while(sqlite3_step(sqlStatement) == SQLITE_ROW){
        ayudas * Ayuda = [[ayudas alloc]init];
        Ayuda.Menu = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
        Ayuda.ProductoEncontrado = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
        Ayuda.Carrito = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
        Ayuda.Cotizaciones = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
        Ayuda.Mas = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 4)];
        
        [listaAyuda addObject:Ayuda];
	}
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(BaseDatos);
    
	return listaAyuda;
}

//Metodos ViewDidLoadEscanear
-(void)registroVEscanear:(NSString *)Visto{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO viewescanear (visto) VALUES ('%@')", Visto];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Registro Escanear");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Registro Escanear");
            }
        }
    }
}

-(NSString *)consultaVEscanear{
    NSString * ubicacionDB = [self obtenerRutaBD];
	
	if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
		NSLog(@"No se puede conectar con la BD");
	}
	
	const char *sentenciaSQL = "SELECT * FROM viewescanear";
	sqlite3_stmt *sqlStatement;
	
	if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
		NSLog(@"Problema al preparar el statement");
	}
	NSString * Visto;
	while(sqlite3_step(sqlStatement) == SQLITE_ROW){
		Visto = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
	}
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(BaseDatos);
    
	return Visto;
}

-(void)eliminaVEscanear{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        const char *sentenciaSQL = "DELETE FROM 'main'.'viewescanear'";
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
            }
        }
    }
}

//Metodos Notificacion
-(void)registroNotificacion:(NSString *)Token{
    NSLog(Token);
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO notificacion (token) VALUES ('%@')", Token];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Registro Token Notificación");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Registro Notificación");
            }
            NSLog(@"ENTRO PERO NO REGISTRO");
        }
        NSLog(@"E");
    }
}

-(void)eliminaNotificacion{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        const char *sentenciaSQL = "DELETE FROM 'main'.'notificacion'";
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Elimina notificacion");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Notificacion eliminada");
            }
        }
    }
}

-(NSString *)consultaNotificacion{
    NSString * ubicacionDB = [self obtenerRutaBD];
	
	if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
		NSLog(@"No se puede conectar con la BD");
	}
	
	const char *sentenciaSQL = "SELECT * FROM notificacion";
	sqlite3_stmt *sqlStatement;
	
	if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
		NSLog(@"Problema al preparar el statement, Consulta Notificación");
	}
	NSString * QR;
	while(sqlite3_step(sqlStatement) == SQLITE_ROW){
		QR = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
	}
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(BaseDatos);
    
	return QR;
}


//Metodos QR
-(void)registroQR:(NSString *)QR{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO qr (qr_url) VALUES ('%@')", QR];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Registro QR");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Registro QR");
            }
        }
    }
}

-(NSString *)consultaQR{
    NSString * ubicacionDB = [self obtenerRutaBD];
	
	if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
		NSLog(@"No se puede conectar con la BD");
	}
	
	const char *sentenciaSQL = "SELECT * FROM qr";
	sqlite3_stmt *sqlStatement;
	
	if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
		NSLog(@"Problema al preparar el statement, Consulta QR");
	}
	NSString * QR;
	while(sqlite3_step(sqlStatement) == SQLITE_ROW){
		QR = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
	}
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(BaseDatos);
    
	return QR;
}

-(void)eliminaQR{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        const char *sentenciaSQL = "DELETE FROM 'main'.'qr'";
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Elimina QR");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"QR eliminado");
            }
        }
    }
}

//Metodos Pedido
-(void)registroPedido:(NSString *)Fecha estado:(NSString *)Estado precio:(NSString *)Precio{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO pedido (pedido_fecha, pedido_estado, pedido_precio) VALUES ('%@', '%@', '%@')", Fecha, Estado, Precio];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Registro Pedido");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Registro Pedido");
            }
        }
    }
}

-(void)eliminaPedido{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        const char *sentenciaSQL = "DELETE FROM 'main'.'pedido'";
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Elimina Pedido");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Pedido eliminado");
            }
        }
    }
}

-(NSMutableArray *)consultaPedidos{
    NSMutableArray * listaPedido = [[NSMutableArray alloc] init];
	NSString * ubicacionDB = [self obtenerRutaBD];
	
	if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
		NSLog(@"No se puede conectar con la BD");
	}
    const char *sentenciaSQL = "SELECT * FROM pedido";
	sqlite3_stmt *sqlStatement;
	
	if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
		NSLog(@"Problema al preparar el statement");
	}
	
	while(sqlite3_step(sqlStatement) == SQLITE_ROW){
        pedido * Pedido = [[pedido alloc]init];
        Pedido.Fecha = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
        Pedido.Estado = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
        Pedido.Precio = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
		[listaPedido addObject:Pedido];
	}
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(BaseDatos);
    
	return listaPedido;
}

//Metodos usuario
-(void)registroUsuario:(NSString *)Correo estado:(NSString *)Estado idUsuario:(NSString *)ID{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO usuario (usuario_correo, usuario_estado, usuario_id) VALUES ('%@', '%@', '%@')", Correo, Estado, ID];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Registro Usuario");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Registro Usuario");
            }
        }
    }
}

-(NSMutableArray *)consultaUsuario{
    NSMutableArray * listaUsuario = [[NSMutableArray alloc] init];
	NSString * ubicacionDB = [self obtenerRutaBD];
	
	if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
		NSLog(@"No se puede conectar con la BD");
	}
	
	const char *sentenciaSQL = "SELECT * FROM usuario";
	sqlite3_stmt *sqlStatement;
	
	if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
		NSLog(@"Problema al preparar el statement");
	}
	
	if(sqlite3_step(sqlStatement) == SQLITE_ROW){
        usuario * Usuario = [[usuario alloc]init];
        Usuario.Correo = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
        Usuario.Estado = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
        Usuario.ID = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
        [listaUsuario addObject:Usuario];
        NSLog(@"Consultado Usuario");
	} else {
        NSLog(@"No encontro Usuario");
    }
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(BaseDatos);
    
	return listaUsuario;
}

-(void)actualizaUsuario:(NSString *)Correo estado:(NSString *)Estado idUsuario:(NSString *)ID{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        NSString *sqlUpdate = [NSString stringWithFormat:@"UPDATE usuario SET usuario_correo = '%@', usuario_estado = '%@', usuario_id = '%@'", Correo, Estado, ID];
        const char *sql = [sqlUpdate UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Actualizo Usuario");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Actualizo Usuario");
            }
        }
    }
}

-(void)eliminaUsuario{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        const char *sentenciaSQL = "DELETE FROM 'main'.'usuario'";
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Elimina Usuario");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Usuario eliminado");
            }
        }
    }
}

//Metodos Token
-(void)registroToken:(NSString *)Token{
    NSLog(Token);
    NSLog(@"T");
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO token (token) VALUES ('%@')", Token];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Registro Token");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Registro Token");
            }
        }
    }
}

-(void)eliminaToken{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        const char *sentenciaSQL = "DELETE FROM 'main'.'token'";
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Elimina Token");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Token eliminado");
            }
        }
    }
}

-(NSString *)consultaToken{
    NSString * ubicacionDB = [self obtenerRutaBD];
	
	if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
		NSLog(@"No se puede conectar con la BD");
	}
	
	const char *sentenciaSQL = "SELECT * FROM token";
	sqlite3_stmt *sqlStatement;
	
	if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
		NSLog(@"Problema al preparar el statement, Consulta Token");
	}
	NSString * Token;
	while(sqlite3_step(sqlStatement) == SQLITE_ROW){
		Token = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
	}
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(BaseDatos);
    
    NSLog(@"T %@", Token);
	return Token;
}

//Metodos TabControl
-(void)registroTabControl:(NSString *)Opcion{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO tabcontrol (tabcontrol_opcion) VALUES ('%@')", Opcion];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Registro TabControl");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Registro TabControl");
            }
        }
    }
}

-(void)eliminaTabControl{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        const char *sentenciaSQL = "DELETE FROM 'main'.'tabcontrol'";
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Elimina TabControl");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"TabControl eliminada");
            }
        }
    }
}

-(NSString *)consultaTabControl{
    NSString * ubicacionDB = [self obtenerRutaBD];
	
	if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
		NSLog(@"No se puede conectar con la BD");
	}
	
	const char *sentenciaSQL = "SELECT * FROM tabcontrol";
	sqlite3_stmt *sqlStatement;
	
	if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
		NSLog(@"Problema al preparar el statement, Consulta TabControl");
	}
	NSString * Opcion;
	while(sqlite3_step(sqlStatement) == SQLITE_ROW){
		Opcion = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
	}
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(BaseDatos);
    
	return Opcion;
}

//Metodos Web Service
-(void)registroOpcionWS:(NSString *)opcionWS{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO webservice (web_service_opcion) VALUES ('%@')", opcionWS];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Registro OpcionWS");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Registro opcionWS");
            }
        }
    }
}

-(NSString *)consultaOpcionWS{
	NSString * ubicacionDB = [self obtenerRutaBD];
	
	if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
		NSLog(@"No se puede conectar con la BD");
	}
	
	const char *sentenciaSQL = "SELECT * FROM webservice";
	sqlite3_stmt *sqlStatement;
	
	if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
		NSLog(@"Problema al preparar el statement, Consulta OpcionWS");
	}
	NSString * opcion_ws;
	while(sqlite3_step(sqlStatement) == SQLITE_ROW){
		opcion_ws = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
	}
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(BaseDatos);
    
	return opcion_ws;
}

-(void)eliminaOpcionWS{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        const char *sentenciaSQL = "DELETE FROM 'main'.'webservice'";
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Elimina OpcionWS");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"OpcionWS eliminada");
            }
        }
    }
}

//Metodos localización
-(void)registroLocalizacion:(NSString *)ciudad{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO localizacion (localizacion_ciudad) VALUES ('%@')", ciudad];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Registro Localizacion");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
            }
        }
    }
}

-(NSString *)consultaLocalizacion{
    NSString * ubicacionDB = [self obtenerRutaBD];
	
	if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
		NSLog(@"No se puede conectar con la BD");
	}
	
	const char *sentenciaSQL = "SELECT * FROM localizacion";
	sqlite3_stmt *sqlStatement;
	
	if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
		NSLog(@"Problema al preparar el statement, Consulta Localizacion");
	}
	NSString * ciudad;
	while(sqlite3_step(sqlStatement) == SQLITE_ROW){
		ciudad = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
	}
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(BaseDatos);
    
	return ciudad;
}

-(void)eliminaLocalizacion{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        const char *sentenciaSQL = "DELETE FROM 'main'.'localizacion'";
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Elimina Localizacion");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Localizacion eliminada");
            }
        }
    }
}

//Metodos video
-(void)registroVideo:(NSString *)Opcion{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO video (video_estado) VALUES ('%@')", Opcion];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Registro Video");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
            }
        }
    }
}

-(NSString *)consultaVideo{
    NSString * ubicacionDB = [self obtenerRutaBD];
	
	if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
		NSLog(@"No se puede conectar con la BD");
	}
	
	const char *sentenciaSQL = "SELECT * FROM video";
	sqlite3_stmt *sqlStatement;
	
	if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
		NSLog(@"Problema al preparar el statement, Consulta Video");
	}
	NSString * video;
	while(sqlite3_step(sqlStatement) == SQLITE_ROW){
		video = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
	}
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(BaseDatos);
    
	return video;
}

-(void)eliminaVideo{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        const char *sentenciaSQL = "DELETE FROM 'main'.'video'";
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Elimina Video");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Video eliminado");
            }
        }
    }
}

//Metodos producto
-(void)registroProducto:(NSString *)SKU nombre:(NSString *)Nombre inspirate:(NSString *)Inspirate precio:(NSString *)Precio cant:(NSString *)Cant ficha:(NSString *)Ficha{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO producto (producto_sku, producto_nombre, producto_precio, producto_cant, producto_inspirate, producto_ficha) VALUES ('%@', '%@', '%@', '%@', '%@', '%@')", SKU, Nombre, Precio, Cant, Inspirate, Ficha];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Registro producto");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Registro producto");
            }
        }
    }
}

-(NSMutableArray *)consultaProducto{
    NSMutableArray * listaProducto = [[NSMutableArray alloc] init];
	NSString * ubicacionDB = [self obtenerRutaBD];
	
	if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
		NSLog(@"No se puede conectar con la BD");
	}
	
	const char *sentenciaSQL = "SELECT * FROM producto";
	sqlite3_stmt *sqlStatement;
	
	if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
		NSLog(@"Problema al preparar el statement");
	}
	
	while(sqlite3_step(sqlStatement) == SQLITE_ROW){
		producto * Producto = [[producto alloc] init];
        Producto.SKU = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
        Producto.nombre = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
        Producto.precio = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
        Producto.cant = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
        Producto.inspirate = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 4)];
        Producto.fichaTecnica = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 5)];
		[listaProducto addObject:Producto];
        NSLog(@"Consultado producto");
	}
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(BaseDatos);
    
	return listaProducto;
}

-(void)eliminaProducto{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        const char *sentenciaSQL = "DELETE FROM 'main'.'producto'";
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Elimina Producto");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Producto eliminado");
            }
        }
    }
}

-(void)actualizaProducto:(NSString *)SKU nombre:(NSString *)Nombre inspirate:(NSString *)Inspirate precio:(NSString *)Precio cant:(NSString *)Cant ficha:(NSString *)Ficha{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"UPDATE producto SET producto_sku = '%@', producto_nombre = '%@', producto_precio = '%@', producto_cant = '%@', producto_inspirate = '%@', producto_ficha = '%@'", SKU, Nombre, Precio, Cant, Inspirate, Ficha];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Producto actualizado");
            }
        }
    }
}

//Metodos Producto Temp
-(void)registroProductoTEMP:(NSString *)SKU nombre:(NSString *)Nombre inspirate:(NSString *)Inspirate precio:(NSString *)Precio cant:(NSString *)Cant ficha:(NSString *)Ficha{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO producto_temp (producto_sku, producto_nombre, producto_precio, producto_cant, producto_inspirate, producto_ficha) VALUES ('%@', '%@', '%@', '%@', '%@', '%@')", SKU, Nombre, Precio, Cant, Inspirate, Ficha];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Registro producto TEMP");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Registro producto TEMP");
            }
        }
    }
}

-(void)eliminaProductoTEMP{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        const char *sentenciaSQL = "DELETE FROM 'main'.'producto_temp'";
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Elimina Producto TEMP");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Producto TEMP eliminado");
            }
        }
    }
}

-(NSMutableArray *)consultaProductoTEMP{
    NSMutableArray * listaProducto = [[NSMutableArray alloc] init];
	NSString * ubicacionDB = [self obtenerRutaBD];
	
	if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
		NSLog(@"No se puede conectar con la BD");
	}
	
	const char *sentenciaSQL = "SELECT * FROM producto_temp";
	sqlite3_stmt *sqlStatement;
	
	if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
		NSLog(@"Problema al preparar el statement");
	}
	
	while(sqlite3_step(sqlStatement) == SQLITE_ROW){
		producto * Producto = [[producto alloc] init];
        Producto.SKU = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
        Producto.nombre = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
        Producto.precio = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
        Producto.cant = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
        Producto.inspirate = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 4)];
        Producto.fichaTecnica = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 5)];
		[listaProducto addObject:Producto];
        NSLog(@"Consultado producto");
	}
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(BaseDatos);
    
	return listaProducto;
}

//Metodos carrito
-(void)registroCarrito:(NSString *)SKU nombre:(NSString *)Nombre precio:(NSString *)Precio cant:(NSString *)Cant precioNuevo:(NSString *)PrecioNuevo{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO carrito (producto_sku, producto_nombre, producto_precio, producto_cant, producto_precio_nuevo) VALUES ('%@', '%@', '%@', '%@', '%@')", SKU, Nombre, Precio, Cant, PrecioNuevo];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Registro carrito");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Registro carritos");
            }
        }
    }
}

-(NSMutableArray *)consultaCarritoSKU:(NSString *)SKU{
    NSMutableArray * listaProducto = [[NSMutableArray alloc] init];
	NSString * ubicacionDB = [self obtenerRutaBD];
	
	if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
		NSLog(@"No se puede conectar con la BD");
	}
	NSString *sqlConsulta = [NSString stringWithFormat:@"SELECT * FROM carrito WHERE producto_sku = '%@'", SKU];
    const char *sentenciaSQL = [sqlConsulta UTF8String];
	sqlite3_stmt *sqlStatement;
	
	if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
		NSLog(@"Problema al preparar el statement");
	}
	
	while(sqlite3_step(sqlStatement) == SQLITE_ROW){
		producto * Producto = [[producto alloc] init];
        Producto.SKU = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
        Producto.nombre = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
        Producto.precio = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
        Producto.cant = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
        Producto.precioNuevo = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 4)];
		[listaProducto addObject:Producto];
	}
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(BaseDatos);
    
	return listaProducto;
}

-(NSMutableArray *)consultaCarrito{
    NSMutableArray * listaProducto = [[NSMutableArray alloc] init];
	NSString * ubicacionDB = [self obtenerRutaBD];
	
	if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
		NSLog(@"No se puede conectar con la BD");
	}
	
	const char *sentenciaSQL = "SELECT * FROM carrito";
	sqlite3_stmt *sqlStatement;
	
	if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
		NSLog(@"Problema al preparar el statement");
	}
	
	while(sqlite3_step(sqlStatement) == SQLITE_ROW){
		producto * Producto = [[producto alloc] init];
        Producto.SKU = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
        Producto.nombre = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
        Producto.precio = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
        Producto.cant = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
        Producto.precioNuevo = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 4)];
		[listaProducto addObject:Producto];
	}
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(BaseDatos);
    
	return listaProducto;
}

-(void)eliminaCarrito:(NSString *)SKU{
    NSString *ubicacionBD = [self obtenerRutaBD];
	
	if(!(sqlite3_open([ubicacionBD UTF8String], &BaseDatos) == SQLITE_OK)){
		NSLog(@"No se puede conectar con la BD");
		return;
	} else {
		NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM carrito WHERE producto_sku = '%@'", SKU];
		const char *sql = [sqlDelete UTF8String];
		sqlite3_stmt *sqlStatement;
		
		if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
			NSLog(@"Problema al preparar el statement.");
			return;
		} else {
			if(sqlite3_step(sqlStatement) == SQLITE_DONE){
				sqlite3_finalize(sqlStatement);
				sqlite3_close(BaseDatos);
                NSLog(@"Elimino carrito");
			}
		}
	}
}

-(void)actualizarCarrito:(NSString *)SKU nombre:(NSString *)Nombre precio:(NSString *)Precio cant:(NSString *)Cant precioNuevo:(NSString *)PrecioNuevo{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"UPDATE carrito SET producto_sku='%@', producto_nombre = '%@', producto_precio = '%@', producto_cant = '%@', producto_precio_nuevo = '%@' WHERE producto_sku = '%@'", SKU, Nombre, Precio, Cant, PrecioNuevo, SKU];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Actualizo carrito");
            }
        }
    }
}

-(void)vaciaCarrito{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        const char *sentenciaSQL = "DELETE FROM 'main'.'carrito'";
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Vacia Carrito");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Carrito vaciado");
            }
        }
    }
}

//Metodos cotización
-(void)registroCotizacion:(NSString *)CotizacionID fecha:(NSString *)Fecha precio:(NSString *)Precio items:(NSString *)Items subTotal:(NSString *)SubTotal ahorro:(NSString *)Ahorro iva:(NSString *)IVA nombre:(NSString *)Nombre{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO cotizacion (cotizacion_id, cotizacion_fecha, cotizacion_precio, cotizacion_items, cotizacion_subtotal, cotizacion_ahorro, cotizacion_iva, cotizacion_nombre) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", CotizacionID, Fecha, Precio, Items, SubTotal, Ahorro, IVA, Nombre];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Registro cotizacion");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
            }
        }
    }
}

-(NSMutableArray *)consultaCotizacion:(NSString *)CotizacionID{
    NSMutableArray * listaCotizacion = [[NSMutableArray alloc] init];
	NSString * ubicacionDB = [self obtenerRutaBD];
	
	if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
		NSLog(@"No se puede conectar con la BD");
	}
	NSString *sqlConsulta = [NSString stringWithFormat:@"SELECT * FROM cotizacion WHERE cotizacion_id = '%@'", CotizacionID];
    const char *sentenciaSQL = [sqlConsulta UTF8String];
	sqlite3_stmt *sqlStatement;
	
	if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
		NSLog(@"Problema al preparar el statement");
	}
	
	while(sqlite3_step(sqlStatement) == SQLITE_ROW){
        cotizacion * Cotizacion = [[cotizacion alloc]init];
        Cotizacion.ID = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
        Cotizacion.Fecha = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
        Cotizacion.Precio = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
        Cotizacion.Items = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
        Cotizacion.SubTotal = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 4)];
        Cotizacion.Ahorro = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 5)];
        Cotizacion.IVA = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 6)];
        Cotizacion.Nombre = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 7)];
		[listaCotizacion addObject:Cotizacion];
	}
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(BaseDatos);
    
	return listaCotizacion;
}

-(NSMutableArray *)consultaCotizaciones{
    NSMutableArray * listaCotizacion = [[NSMutableArray alloc] init];
	NSString * ubicacionDB = [self obtenerRutaBD];
	
	if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
		NSLog(@"No se puede conectar con la BD");
	}
	
	const char *sentenciaSQL = "SELECT * FROM cotizacion";
	sqlite3_stmt *sqlStatement;
	
	if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
		NSLog(@"Problema al preparar el statement");
	}
	
	while(sqlite3_step(sqlStatement) == SQLITE_ROW){
		cotizacion * Cotizacion = [[cotizacion alloc]init];
        Cotizacion.ID = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
        Cotizacion.Fecha = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
        Cotizacion.Precio = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
        Cotizacion.Items = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
        Cotizacion.SubTotal = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 4)];
        Cotizacion.Ahorro = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 5)];
        Cotizacion.IVA = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 6)];
        Cotizacion.Nombre = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 7)];
		[listaCotizacion addObject:Cotizacion];
	}
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(BaseDatos);
    
	return listaCotizacion;
}

-(void)actualizarCotizacion:(NSString *)CotizacionID fecha:(NSString *)Fecha precio:(NSString *)Precio items:(NSString *)Items subTotal:(NSString *)SubTotal ahorro:(NSString *)Ahorro iva:(NSString *)IVA nombre:(NSString *)Nombre{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"UPDATE cotizacion SET cotizacion_id='%@', cotizacion_fecha = '%@', cotizacion_precio = '%@', cotizacion_items = '%@', cotizacion_subtotal = '%@', cotizacion_ahorro = '%@', cotizacion_iva = '%@', cotizacion_nombre = '%@' WHERE cotizacion_id = '%@'", CotizacionID, Fecha, Precio, Items, SubTotal, Ahorro, IVA, Nombre, CotizacionID];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
            }
        }
    }
}

-(void)eliminarCotizacion:(NSString *)ID{
    NSString *ubicacionBD = [self obtenerRutaBD];
	
	if(!(sqlite3_open([ubicacionBD UTF8String], &BaseDatos) == SQLITE_OK)){
		NSLog(@"No se puede conectar con la BD");
		return;
	} else {
		NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM cotizacion WHERE cotizacion_id = '%@'", ID];
		const char *sql = [sqlDelete UTF8String];
		sqlite3_stmt *sqlStatement;
		
		if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
			NSLog(@"Problema al preparar el statement.");
			return;
		} else {
			if(sqlite3_step(sqlStatement) == SQLITE_DONE){
				sqlite3_finalize(sqlStatement);
				sqlite3_close(BaseDatos);
                NSLog(@"Elimino cotizacion");
			}
		}
	}
}

//Metodos cotizacion Temp
-(void)registroCotizacionTemp:(NSString *)CotizacionID fecha:(NSString *)Fecha precio:(NSString *)Precio items:(NSString *)Items subTotal:(NSString *)SubTotal ahorro:(NSString *)Ahorro iva:(NSString *)IVA nombre:(NSString *)Nombre{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO cotizacion_temp (cotizacion_id, cotizacion_fecha, cotizacion_precio, cotizacion_items, cotizacion_subtotal, cotizacion_ahorro, cotizacion_iva, cotizacion_nombre) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", CotizacionID, Fecha, Precio, Items, SubTotal, Ahorro, IVA, Nombre];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Registro cotizacion Temp");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Elimino cotizacion detalle");
            }
        }
    }
}

-(NSMutableArray *)consultaCotizacionTemp{
    NSMutableArray * listaCotizacion = [[NSMutableArray alloc] init];
	NSString * ubicacionDB = [self obtenerRutaBD];
	
	if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
		NSLog(@"No se puede conectar con la BD");
	}
	
	const char *sentenciaSQL = "SELECT * FROM cotizacion_temp";
	sqlite3_stmt *sqlStatement;
	
	if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
		NSLog(@"Problema al preparar el statement");
	}
	
	while(sqlite3_step(sqlStatement) == SQLITE_ROW){
		cotizacion * Cotizacion = [[cotizacion alloc]init];
        Cotizacion.ID = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
        Cotizacion.Fecha = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
        Cotizacion.Precio = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
        Cotizacion.Items = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
        Cotizacion.SubTotal = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 4)];
        Cotizacion.Ahorro = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 5)];
        Cotizacion.IVA = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 6)];
        Cotizacion.Nombre = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 7)];
		[listaCotizacion addObject:Cotizacion];
	}
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(BaseDatos);
    
	return listaCotizacion;
}

-(void)eliminaCotizacionTemp{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        const char *sentenciaSQL = "DELETE FROM 'main'.'cotizacion_temp'";
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Elimina Cotizacion Temp");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Cotizacion Temp eliminada");
            }
        }
    }
}

//Metodos cotización detalle
-(void)registroCotizacionDetalle:(NSString *)CotizacionID sku:(NSString *)SKU nombre:(NSString *)Nombre precio:(NSString *)Precio cant:(NSString *)Cant{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO cotizacion_detalle (cotizacion_detalle_cotizacion, cotizacion_detalle_sku, cotizacion_detalle_nombre, cotizacion_detalle_precio, cotizacion_detalle_cant) VALUES ('%@', '%@', '%@', '%@', '%@')", CotizacionID, SKU, Nombre, Precio, Cant];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Registro cotizacion detalle");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
            }
        }
    }
}

-(NSMutableArray *)consultaCotizacionDetalle:(NSString *)CotizacionID{
    NSMutableArray * listaCotizacionDetalle = [[NSMutableArray alloc] init];
	NSString * ubicacionDB = [self obtenerRutaBD];
	
	if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
		NSLog(@"No se puede conectar con la BD");
	}
	NSString *sqlConsulta = [NSString stringWithFormat:@"SELECT * FROM cotizacion_detalle WHERE cotizacion_detalle_cotizacion = '%@'", CotizacionID];
    const char *sentenciaSQL = [sqlConsulta UTF8String];
	sqlite3_stmt *sqlStatement;
	
	if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
		NSLog(@"Problema al preparar el statement");
	}
	
	while(sqlite3_step(sqlStatement) == SQLITE_ROW){
        cotizacion_detalle * CotizacionDetalle = [[cotizacion_detalle alloc]init];
        CotizacionDetalle.CotizacionID = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
        CotizacionDetalle.SKU = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
        CotizacionDetalle.Nombre = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
        CotizacionDetalle.Precio = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
        CotizacionDetalle.Cant = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 4)];
		[listaCotizacionDetalle addObject:CotizacionDetalle];
	}
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(BaseDatos);
    
	return listaCotizacionDetalle;
}

-(void)eliminaCotizacionDetalle:(NSString *)CotizacionID{
    NSString *ubicacionBD = [self obtenerRutaBD];
	
	if(!(sqlite3_open([ubicacionBD UTF8String], &BaseDatos) == SQLITE_OK)){
		NSLog(@"No se puede conectar con la BD");
		return;
	} else {
		NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM cotizacion_detalle WHERE cotizacion_detalle_cotizacion = '%@'", CotizacionID];
		const char *sql = [sqlDelete UTF8String];
		sqlite3_stmt *sqlStatement;
		
		if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
			NSLog(@"Problema al preparar el statement.");
			return;
		} else {
			if(sqlite3_step(sqlStatement) == SQLITE_DONE){
				sqlite3_finalize(sqlStatement);
				sqlite3_close(BaseDatos);
			}
		}
	}
}

//Metodos boton
-(void)registroBoton{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        const char *sql = "INSERT INTO boton_carrito (boton_estado) VALUES ('1')";
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Registro boton");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
            }
        }
    }
}

-(NSString *)consultaBoton{
    NSString * ubicacionDB = [self obtenerRutaBD];
	
	if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
		NSLog(@"No se puede conectar con la BD");
	}
	
	const char *sentenciaSQL = "SELECT * FROM boton_carrito";
	sqlite3_stmt *sqlStatement;
	
	if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
		NSLog(@"Problema al preparar el statement, Consulta Boton");
	}
	NSString * boton;
	while(sqlite3_step(sqlStatement) == SQLITE_ROW){
		boton = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
	}
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(BaseDatos);
    
	return boton;
}

-(void)eliminaBoton{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        const char *sentenciaSQL = "DELETE FROM 'main'.'boton_carrito'";
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Elimina Boton");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Boton eliminado");
            }
        }
    }
}

//Metodos Valida WS
-(void)registroValidaWS:(NSString *)Valor{
    NSLog(Valor);
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO valida_ws (valida_ws_carrito) VALUES ('%@')", Valor];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Registro Valida WS");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Registro Valida WS");
            }
            NSLog(@"ENTRO PERO NO REGISTRO VALIDA WS");
        }
        NSLog(@"E");
    }
}

-(void)eliminaValidaWS{
    NSString *ubicacionDB = [self obtenerRutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return;
    } else {
        const char *sentenciaSQL = "DELETE FROM 'main'.'valida_ws'";
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement, Elimina Valida WS");
            return;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                sqlite3_close(BaseDatos);
                NSLog(@"Valida WS eliminada");
            }
        }
    }
}

-(NSString *)consultaValidaWS{
    NSString * ubicacionDB = [self obtenerRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &BaseDatos) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    
    const char *sentenciaSQL = "SELECT * FROM valida_ws";
    sqlite3_stmt *sqlStatement;
    
    if(sqlite3_prepare_v2(BaseDatos, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement, Consulta Valida WS");
    }
    NSString * Valor;
    while(sqlite3_step(sqlStatement) == SQLITE_ROW){
        Valor = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
    }
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(BaseDatos);
    
    return Valor;
}


@end
