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
#import "ChooseSectionTypeTableViewController.h"

@interface ViewController : UIViewController <UIAlertViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

typedef NS_ENUM(NSInteger, CurrentStatus) {
	CurrentStatusEmpty		= -1,
	CurrentStatusReady		= 0,
	CurrentStatusRunning	= 1,
	CurrentStatusPaused		= 2,
	CurrentStatusEnded		= 3,
};

@property (strong) NSMutableArray *route;
@property (strong) NSMutableArray *routeViews;
@property (strong) UIView *routeViewsContainer;
@property (strong) UIButton *leftButton;
@property (strong) UIButton *rightButton;
@property (strong) RouteSection *changeSectionType;
@property (strong) UIPickerView *secondsPickerView;
@property (strong) UIPickerView *jumpCountPickerView;

@property (weak, nonatomic) IBOutlet RouteSectionView *editableSectionView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *editSectionView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@end