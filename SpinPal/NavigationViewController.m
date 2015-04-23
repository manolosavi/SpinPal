//
//  NavigationViewController.m
//  SpinPal
//
//  Created by manolo on 4/16/15.
//  Copyright (c) 2015 manolosavi. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[[self navigationBar] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
												  [UIColor colorWithWhite:0 alpha:1], NSForegroundColorAttributeName,
												  [UIFont fontWithName:@"AvenirNext-Medium" size:20], NSFontAttributeName,nil]];
	if ([self.viewControllers[0] isKindOfClass:[OverviewCollectionViewController class]] || [self.viewControllers[0] isKindOfClass:[SavedRoutesTableViewController class]]) {
		[self.viewControllers[0] setRoute:_route];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.destinationViewController isKindOfClass:[OverviewCollectionViewController class]]) {
		[segue.destinationViewController setRoute:_route];
    } else if ([segue.destinationViewController isKindOfClass:[SavedRoutesTableViewController class]]) {
        [segue.destinationViewController setRoute:_route];
    }
}

@end