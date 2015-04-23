//
//  OverviewCollectionViewController.h
//  SpinPal
//
//  Created by manolo on 4/16/15.
//  Copyright (c) 2015 manolosavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RouteSection.h"
#import "RouteSectionView.h"
#import "ViewController.h"

@interface OverviewCollectionViewController : UICollectionViewController

///Array of RouteSections for the current route.
@property (strong) NSMutableArray *route;

@end