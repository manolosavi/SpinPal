//
//  ViewController.m
//  SpinPal
//
//  Created by manolo on 3/19/15.
//  Copyright (c) 2015 manolosavi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_route = [self getRoute];
	
	CGRect rect = CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2-90, 100, 180);
	
	RouteSectionView *v = [[RouteSectionView alloc] initWithFrame:rect];
	RouteSection *section = [[RouteSection alloc] initWithRouteType:RouteTypeNone];
	[section setSeconds:90];
	[section setRpm:100];
	[section setRepetitions:23];
	[section setResistance:3];
	[v setSection:section];
	[v loadData];
	[self.view addSubview:v];
	
	rect = CGRectMake(self.view.frame.size.width/2-180, self.view.frame.size.height/2-90, 100, 180);
	
	RouteSectionView *v2 = [[RouteSectionView alloc] initWithFrame:rect];
	section = [[RouteSection alloc] initWithRouteType:RouteTypeStraight];
	[section setSeconds:90];
	[section setRpm:100];
	[section setRepetitions:23];
	[section setResistance:3];
	[v2 setSection:section];
	[v2 loadData];
	[self.view addSubview:v2];
}

- (NSString *)routeFilename {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"route.plist"];
}

- (NSMutableArray *)getRoute {
	NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[self routeFilename]];
	NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	
	NSArray *recordedPresets = [unarchiver decodeObjectForKey:@"route"];
	
	return [[NSMutableArray alloc] initWithArray:recordedPresets copyItems:NO];
}

- (BOOL)saveRoute {
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:_route forKey:@"route"];
	[archiver finishEncoding];
	return [data writeToFile:[self routeFilename] atomically:true];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end