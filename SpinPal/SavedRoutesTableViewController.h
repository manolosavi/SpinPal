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

@interface SavedRoutesTableViewController : UITableViewController <UIAlertViewDelegate, UITableViewDataSource>

///Array of routes.
@property NSMutableArray *routes;

///Array of RouteSections for the current route.
@property NSMutableArray *route;

/**
 Gets the path to the file where the routes are saved.
 @return String with the path to the file.
 */
- (NSString *)routesFilename;

/**
 Loads saved routes from disk.
 @return Array of arrays of @c RouteSections that make the route
 */
- (NSMutableArray *)getRoutes;

/**
 Saves the current route to disk.
 @return True if the saving succeeded, false otherwise.
 */
- (BOOL)saveRoutes;

@end
