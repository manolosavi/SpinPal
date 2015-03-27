//
//  ViewController.h
//  SpinPal
//
//  Created by manolo on 3/19/15.
//  Copyright (c) 2015 manolosavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RouteSection.h"
#import "RouteSectionView.h"

@interface ViewController : UIViewController

@property (strong) NSMutableArray *route;
@property (strong) NSMutableArray *routeViews;
@property (strong) UIView *routeViewsContainer;

@property (weak, nonatomic) IBOutlet UIVisualEffectView *editSectionView;

@end