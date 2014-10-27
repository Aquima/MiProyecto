//
//  QRViewController.m
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 6/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import "QRViewController.h"
#import "EscanearViewController.h"

@interface QRViewController ()

@end

@implementation QRViewController
@synthesize webView, ConexionBD;

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
    NSString * rutaUrl = [ConexionBD consultaQR];
    NSLog(rutaUrl);
    NSURL * url = [[NSURL alloc] initWithString:rutaUrl];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cerrar:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:NULL];
    EscanearViewController * destinoEscaneo = [self.storyboard instantiateViewControllerWithIdentifier:@"viewEscaneo"];
    [self addChildViewController:destinoEscaneo];
    [self.view addSubview:destinoEscaneo.view];
    [destinoEscaneo didMoveToParentViewController:self];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
