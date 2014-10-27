//
//  tabBViewController.h
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 3/06/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bd.h"

@interface tabBViewController : UITabBarController <UITabBarControllerDelegate, UITabBarDelegate>

@property (nonatomic, strong) bd * ConexionBD;

@end
