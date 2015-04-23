//
//  SavedRoutesTableViewController.h
//  SpinPal
//
//  Created by Luis Gerardo on 4/23/15.
//  Copyright (c) 2015 manolosavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "RouteSection.h"
#import "RouteSectionView.h"

@interface SavedRoutesTableViewController : UITableViewController

///Array of RouteSections for the current route.
@property NSMutableArray *routes;

///Array of RouteSections for the current route.
@property NSMutableArray *route;

@end
