//
//  EscanearViewController.h
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 31/05/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bd.h"
#import "producto_encontrado.h"
#import "producto.h"
#import "ProductoEncontradoViewController.h"
#import <AVFoundation/AVFoundation.h>

@import AVFoundation;

@interface EscanearViewController : UIViewController <UITextFieldDelegate, AVCaptureMetadataOutputObjectsDelegate, NSURLConnectionDataDelegate>

@property(nonatomic, strong)NSMutableData * acumulaDatos;

@property (strong, nonatomic) AVCaptureDevice* device;
@property (strong, nonatomic) AVCaptureDeviceInput* input;
@property (strong, nonatomic) AVCaptureMetadataOutput* output;
@property (strong, nonatomic) AVCaptureSession* session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer* preview;

@property (nonatomic) BOOL codeDetected;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *txtSKU;
@property (strong, nonatomic) IBOutlet UIButton *btnConsultarSKU;
@property (strong, nonatomic) IBOutlet UIImageView *imgScan;
@property(nonatomic, strong)UITextField * campoActivo;
- (IBAction)consultarSKU:(id)sender;
@property(nonatomic, strong)bd * ConexionBD;
@property (strong, nonatomic) IBOutlet UIImageView *imgTitulo;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *Cargando;
@property(nonatomic, strong)producto_encontrado * ProductoEncontrado;
@property(nonatomic, strong)producto * Producto;
@property(nonatomic, strong)ProductoEncontradoViewController * destino;
@property (strong, nonatomic) IBOutlet UIView *vistaCargando;
@property (strong, nonatomic) IBOutlet UIImageView *imgCargando;
@property (strong, nonatomic) IBOutlet UIButton *btnVolver;
- (IBAction)volverQR:(id)sender;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIImageView *ayuda1;
@property (strong, nonatomic) IBOutlet UIImageView *ayuda2;

@property (nonatomic, strong) NSMutableURLRequest * request;

-(void)cerrarVista:(UIViewController*) content;
@property (strong, nonatomic) IBOutlet UILabel *lblScan;


@end
