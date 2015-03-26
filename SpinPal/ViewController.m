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
	
	CGRect frame = CGRectMake(0, self.view.frame.size.height/2-90, 130*_route.count, 180);
	_routeViewsContainer = [[UIView alloc] initWithFrame:frame];
	[self.view addSubview:_routeViewsContainer];
	_routeViews = [[NSMutableArray alloc] init];
	for (int i=0; i<_route.count; i++) {
		frame = CGRectMake(130*i, 0, 100, 180);
		RouteSectionView *v = [[RouteSectionView alloc] initWithFrame:frame];
		[v setSection:_route[i]];
		[v loadData];
		[_routeViews addObject:v];
		[_routeViewsContainer addSubview:v];
	}
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