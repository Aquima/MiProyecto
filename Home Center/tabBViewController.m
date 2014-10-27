//
//  tabBViewController.m
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 3/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import "tabBViewController.h"
#import "EscanearViewController.h"
#import "CarritoViewController.h"
#import "AppDelegate.h"
#import "CotizacionesViewController.h"
#import "MasViewController.h"
#import "PedidosViewController.h"
#import "ProductoEncontradoViewController.h"
#import "ConsultasViewController.h"
#import "UbicacionViewController.h"

@interface tabBViewController ()

@end

@implementation tabBViewController
@synthesize ConexionBD;

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

    EscanearViewController* myController1 = [self.storyboard instantiateViewControllerWithIdentifier:@"viewEscaneo"];
    CarritoViewController* myController2 = [self.storyboard instantiateViewControllerWithIdentifier:@"viewCarrito"];
    CotizacionesViewController* myController3 = [self.storyboard instantiateViewControllerWithIdentifier:@"viewMisCotizaciones"];
    //PedidosViewController * myController4 = [self.storyboard instantiateViewControllerWithIdentifier:@"viewPedidos"];
    UbicacionViewController * myController4 = [self.storyboard instantiateViewControllerWithIdentifier:@"viewUbicacion"];
    MasViewController* myController5 = [self.storyboard instantiateViewControllerWithIdentifier:@"viewMas"];
    //ConsultasViewController * myController4 = [self.storyboard instantiateViewControllerWithIdentifier:@"consultasVC"];
    
    NSArray *array = [NSArray arrayWithObjects: myController1, myController2, myController3, myController4, myController5, nil];
    
    self.viewControllers = array;
    self.delegate = self;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    ConexionBD = [[bd alloc]init];
    NSLog(@"VIEW WILL APPEAR TABCONTROL");
    
    
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    
        NSLog(@"Refresh");
        
        [viewController viewWillAppear:YES];
        
        NSLog(@"CANTIDAD SUB VIEWS %d",viewController.view.subviews.count);
    
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
