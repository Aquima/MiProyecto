//
//  AppDelegate.h
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 20/05/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bd.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) bd * ConexionBD;

@end
