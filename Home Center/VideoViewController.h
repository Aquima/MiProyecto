//
//  VideoViewController.h
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 3/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "bd.h"

@interface VideoViewController : UIViewController <NSURLConnectionDataDelegate>

@property(nonatomic, strong)NSMutableData * acumulaDatos;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)saltarVideo:(id)sender;
@property (nonatomic, strong)bd * ConexionBD;

@end
