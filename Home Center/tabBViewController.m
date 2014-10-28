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
    UIStoryboard*currentStoryBoard;
    ConexionBD = [[bd alloc]init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // The device is an iPad running iOS 3.2 or later.
       currentStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    }
    else
    {
        // The device is an iPhone or iPod touch.
        currentStoryBoard = [UIStoryboard storyboardWithName:@"Main"
                                                      bundle:NULL];
    }
    EscanearViewController* myController1 = [currentStoryBoard instantiateViewControllerWithIdentifier:@"viewEscaneo"];
    CarritoViewController* myController2 = [currentStoryBoard instantiateViewControllerWithIdentifier:@"viewCarrito"];
    CotizacionesViewController* myController3 = [currentStoryBoard instantiateViewControllerWithIdentifier:@"viewMisCotizaciones"];
    //PedidosViewController * myController4 = [self.storyboard instantiateViewControllerWithIdentifier:@"viewPedidos"];
    UbicacionViewController * myController4 = [currentStoryBoard instantiateViewControllerWithIdentifier:@"viewUbicacion"];
    MasViewController* myController5 = [currentStoryBoard instantiateViewControllerWithIdentifier:@"viewMas"];
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
