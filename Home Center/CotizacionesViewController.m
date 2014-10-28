//
//  CotizacionesViewController.m
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 3/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import "CotizacionesViewController.h"
#import "EscanearViewController.h"
#import "CarritoViewController.h"
#import "MasViewController.h"
#import "PedidosViewController.h"
#import "tabBViewController.h"
#import "ayudas.h"
#import "VistaPreviaCotizacionViewController.h"

@interface CotizacionesViewController (){
    float posicionX;
    float posicionY;
    int validaCambioNombre;
}

@end

@implementation CotizacionesViewController
@synthesize tabla, ConexionBD, Cotizacion, listaCotizaciones, CotizacionDetalle, imgMensaje, lblMensaje, ayuda1, ayuda, strNombreCotizacion, campoActivo, scrollView, lblTitulo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ConexionBD = [[bd alloc]init];
    [lblTitulo setFont:[UIFont fontWithName:@"Miso" size:16.0]];
    
}

-(void)singleTapping:(UIGestureRecognizer *)recognizer
{
    if (imgMensaje.hidden) {
        ayuda.hidden = YES;
        ayuda1.hidden = YES;
        NSMutableArray * listaAyudas = [ConexionBD consultaAyuda];
        ayudas * Ayudas = [listaAyudas objectAtIndex:0];
        [ConexionBD actualizaAyuda:Ayudas.Menu productoEncontrado:Ayudas.ProductoEncontrado carrito:Ayudas.Carrito cotizaciones:@"1" mas:Ayudas.Mas];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [super viewWillDisappear:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    if (self.view.subviews.count == 2) {
        for (int i = 1; i < [[self.view subviews] count]; i++ ) {
            [[[self.view subviews] objectAtIndex:i] removeFromSuperview];
        }
        NSLog(@"REMOVIO");
    }
    
    [[self scrollView] setContentSize:[[self view] frame].size];
    
    //Notificaciones del teclado
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(apareceElTeclado:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(desapareceElTeclado:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //Detección de toques en el scroll view
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewPulsado)];
    [tapRecognizer setCancelsTouchesInView:NO];
    [[self scrollView] addGestureRecognizer:tapRecognizer];
    
    validaCambioNombre = -1;
    
    listaCotizaciones = [ConexionBD consultaCotizaciones];
    if (listaCotizaciones.count > 0) {
        imgMensaje.hidden = YES;
        NSMutableArray * listaAyudas = [ConexionBD consultaAyuda];
        ayudas * Ayudas = [listaAyudas objectAtIndex:0];
        NSLog(@"AYUDA COTIZACIONES %@",Ayudas.Cotizaciones);
        if ([Ayudas.Cotizaciones isEqualToString:@"0"]) {
            ayuda.hidden = NO;
            ayuda1.hidden = NO;
            [ayuda setUserInteractionEnabled:YES];
            UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
            [singleTap setNumberOfTapsRequired:1];
            [ayuda addGestureRecognizer:singleTap];
        } else {
            ayuda.hidden = YES;
            ayuda1.hidden = YES;
        }
    } else {
        imgMensaje.hidden = NO;
        ayuda.hidden = YES;
        ayuda1.hidden = YES;
    }
    [tabla reloadData];
    
    NSMutableArray * lista = [ConexionBD consultaCarrito];
    NSLog(@"%d", [lista count]);
    [[[[[self tabBarController]tabBar]items]objectAtIndex:1]setBadgeValue:[NSString stringWithFormat:@"%d", lista.count]];
    
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listaCotizaciones count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"celda";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    @try {
        Cotizacion = [listaCotizaciones objectAtIndex:indexPath.row];
        
        UILabel * lblNombre = (UILabel*)[cell viewWithTag:200];
        lblNombre.text =  Cotizacion.Nombre;
        UILabel * lblFecha = (UILabel*)[cell viewWithTag:300];
        NSString * strFecha;
        @try {
            strFecha = [Cotizacion.Fecha substringToIndex:11];
        }
        @catch (NSException *exception) {
            strFecha = [Cotizacion.Fecha substringToIndex:10];
        }
        
        lblFecha.text = strFecha;
        
        UILabel * lblFechaTXT = (UILabel*)[cell viewWithTag:301];
        lblFechaTXT.text = @"Fecha de expiración";
        
        UILabel * lblCant = (UILabel*)[cell viewWithTag:400];
        lblCant.text = [NSString stringWithFormat:@"Número de ítems %@", Cotizacion.Items];
        UILabel * lblPrecio = (UILabel *)[cell viewWithTag:500];
        
        NSNumberFormatter * formater = [[NSNumberFormatter alloc]init];
        formater.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber * number = [[NSNumber alloc]initWithDouble:Cotizacion.Precio.doubleValue];
        NSMutableString * preci0;
        [preci0 appendString:[formater stringFromNumber:number]];
        //= [formater stringFromNumber:number];
        NSMutableString * numeroMostrar;
        //= [preci0 stringByReplacingOccurrencesOfString:@"," withString:@"."];
        [numeroMostrar appendString:[preci0 stringByReplacingOccurrencesOfString:@"," withString:@"."]];
        lblPrecio.text = [NSString stringWithFormat:@"$ %@", numeroMostrar];
        
        //UIButton * btnEditar = (UIButton *)[cell viewWithTag:600];
        //[btnEditar addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        //posicionX = btnEditar.frame.origin.x;
        //posicionY = btnEditar.frame.origin.y;
        
        //UITextField * txtCambioNombre = (UITextField *)[cell viewWithTag:850];
        //txtCambioNombre.text = Cotizacion.Nombre;
        
        /*if (validaCambioNombre == indexPath.row) {
         txtCambioNombre.hidden = NO;
         } else {
         txtCambioNombre.hidden = YES;
         strNombreCotizacion = [[NSMutableString alloc]init];
         [strNombreCotizacion appendString:txtCambioNombre.text];
         NSLog(strNombreCotizacion);
         }*/
        
        //[txtCambioNombre addTarget:self action:@selector(editoNombre:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        //UIButton * btnCambioNombre = (UIButton *)[cell viewWithTag:800];
        //[btnCambioNombre addTarget:self action:@selector(buttonCambioNombre:) forControlEvents:UIControlEventTouchUpInside];
        
        [lblNombre setFont:[UIFont fontWithName:@"Miso" size:16.0]];
        [lblFecha setFont:[UIFont fontWithName:@"Miso" size:12.0]];
        [lblFechaTXT setFont:[UIFont fontWithName:@"Miso" size:12.0]];
        [lblCant setFont:[UIFont fontWithName:@"Miso" size:12.0]];
        [lblPrecio setFont:[UIFont fontWithName:@"Miso" size:23.0]];
    }
    @catch (NSException *exception) {
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VistaPreviaCotizacionViewController * destino = [self.storyboard instantiateViewControllerWithIdentifier:@"viewVistaPreviaCotizacion"];
    
    [ConexionBD eliminaTabControl];
    [ConexionBD registroTabControl:@"vistaPreviaCotizacion"];
    
    Cotizacion = [listaCotizaciones objectAtIndex:indexPath.row];
    destino.idCotizacion = Cotizacion.ID;
    
    [self addChildViewController:destino];
    [self.view addSubview:destino.view];
    [destino didMoveToParentViewController:self];
}

-(void)buttonClicked:(id)sender
{
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:tabla];
    NSIndexPath *indexPath = [tabla indexPathForRowAtPoint:touchPoint];
    
    [ConexionBD registroBoton];
    [ConexionBD vaciaCarrito];
    Cotizacion = [listaCotizaciones objectAtIndex:indexPath.row];
    NSMutableArray * listaCotizacionDetalle = [ConexionBD consultaCotizacionDetalle:Cotizacion.ID];
    for (int i = 0; i < listaCotizacionDetalle.count; i++) {
        CotizacionDetalle = [listaCotizacionDetalle objectAtIndex:i];
        [ConexionBD registroCarrito:CotizacionDetalle.SKU nombre:CotizacionDetalle.Nombre precio:CotizacionDetalle.Precio cant:CotizacionDetalle.Cant precioNuevo:CotizacionDetalle.Precio];
    }
    [[[[[self tabBarController]tabBar]items]objectAtIndex:1]setBadgeValue:[NSString stringWithFormat:@"%d", listaCotizacionDetalle.count]];
    
    [ConexionBD eliminaCotizacionTemp];
    [ConexionBD registroCotizacionTemp:Cotizacion.ID fecha:Cotizacion.Fecha precio:Cotizacion.Precio items:Cotizacion.Items subTotal:Cotizacion.SubTotal ahorro:Cotizacion.Ahorro iva:Cotizacion.IVA nombre:Cotizacion.Nombre];
    
    UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"Revisa el Carrito" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
    [alerta show];
    
}

/*-(void)buttonCambioNombre:(id)sender
{
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:tabla];
    NSIndexPath *indexPath = [tabla indexPathForRowAtPoint:touchPoint];
    validaCambioNombre = indexPath.row;
    [tabla reloadData];
}*/

/*-(void)editoNombre:(id)sender
{
    if (campoActivo.text.length > 0) {
        Cotizacion = [listaCotizaciones objectAtIndex:validaCambioNombre];
        [ConexionBD actualizarCotizacion:Cotizacion.ID fecha:Cotizacion.Fecha precio:Cotizacion.Precio items:Cotizacion.Items subTotal:Cotizacion.SubTotal ahorro:Cotizacion.Ahorro iva:Cotizacion.IVA nombre:campoActivo.text];
        listaCotizaciones = [ConexionBD consultaCotizaciones];
        
        validaCambioNombre = -1;
        [tabla reloadData];
    } else {
        UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"Homecenter" message:@"El campo nombre esta vacio" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [alerta show];
    }
    
}*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        Cotizacion = [listaCotizaciones objectAtIndex:indexPath.row];
        [ConexionBD eliminarCotizacion:Cotizacion.ID];
        [ConexionBD eliminaCotizacionDetalle:Cotizacion.ID];
        [listaCotizaciones removeObjectAtIndex:indexPath.row];
        [tabla reloadData];
        
        if (listaCotizaciones.count == 0) {
            imgMensaje.hidden = NO;
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Borrar";
}

#pragma mark - Métodos de UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setCampoActivo:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setCampoActivo:nil];
}

#pragma mark - Notificaciones del teclado
- (void) apareceElTeclado:(NSNotification *)laNotificacion
{
    NSDictionary *infoNotificacion = [laNotificacion userInfo];
    CGSize tamanioTeclado = [[infoNotificacion objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height, 0);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [scrollView setContentInset:edgeInsets];
    [scrollView setScrollIndicatorInsets:edgeInsets];
    [scrollView scrollRectToVisible:[self campoActivo].frame animated:YES];
}

- (void) desapareceElTeclado:(NSNotification *)laNotificacion
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    [scrollView setContentInset:edgeInsets];
    [scrollView setScrollIndicatorInsets:edgeInsets];
    [UIView commitAnimations];
}

#pragma mark - Métodos de acción adicionales
- (void) scrollViewPulsado
{
    [[self view] endEditing:YES];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)viewDidLayoutSubviews{
    if (self.view.subviews.count == 1) {
        [self viewWillAppear:YES];
        NSLog(@"PRUEBA PRUEBA");
    }
    
}

@end
