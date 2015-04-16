//
//  NavigationViewController.h
//  SpinPal
//
//  Created by manolo on 4/16/15.
//  Copyright (c) 2015 manolosavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverviewCollectionViewController.h"

@interface NavigationViewController : UINavigationController

///Array of RouteSections for the current route.
@property NSMutableArray *route;

@end