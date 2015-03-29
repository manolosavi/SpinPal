//
//  ViewController.m
//  SpinPal
//
//  Created by manolo on 3/19/15.
//  Copyright (c) 2015 manolosavi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

static BOOL ISADDINGNEWSECTION;
static NSInteger SECTIONTOEDIT;
static CurrentStatus STATUS;

- (void)viewDidLoad {
	[super viewDidLoad];
	[_scrollView setBackgroundColor:[UIColor colorWithHue:0 saturation:0 brightness:0 alpha:.2]];
	_editSectionView.hidden = true;
	[_editSectionView.layer setOpacity:0];
	
	_route = [self getRoute];
	
	CGRect frame = CGRectMake(0, self.view.frame.size.height-80, self.view.frame.size.width/2, 80);
	_leftButton = [[UIButton alloc] initWithFrame:frame];
	[_leftButton setBackgroundColor:[UIColor redColor]];
	frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height-80, self.view.frame.size.width/2, 80);
	_rightButton = [[UIButton alloc] initWithFrame:frame];
	[_rightButton setBackgroundColor:[UIColor blueColor]];
	[self.view insertSubview:_leftButton atIndex:0];
	[self.view insertSubview:_rightButton atIndex:0];
	
	[_closeButton setBackgroundColor:[UIColor colorWithHue:138/360.0 saturation:.77 brightness:.9 alpha:1]];
	
	STATUS = (_route.count>1)?CurrentStatusReady:CurrentStatusEmpty;
	[self statusChanged];
	
	[self loadViewsIntoContainer];
	
//	For debugging, resets on launch
	[self resetRoute];
}

- (void)loadViewsIntoContainer {
	CGRect frame = CGRectMake(0, 0, self.view.frame.size.width-200 + 200*_route.count, 240);
	
	_routeViewsContainer = [[UIView alloc] initWithFrame:frame];
	[_scrollView insertSubview:_routeViewsContainer atIndex:0];
	[_scrollView setContentSize:_routeViewsContainer.frame.size];
	_routeViews = [[NSMutableArray alloc] init];
	for (int i=0; i<_route.count; i++) {
		int offset = self.view.frame.size.width/2-80;
		frame = CGRectMake(offset+200*i, 0, 160, 240);
		RouteSectionView *v = [[RouteSectionView alloc] initWithFrame:frame];
		[v setSection:_route[i]];
		[v loadData];
		[_routeViews addObject:v];
		[_routeViewsContainer addSubview:v];
	}
}

- (void)insertAddNewSectionViewToContainer {
	CGRect frame = _routeViewsContainer.frame;
	frame.size.width = frame.size.width+200;//Make frame for container
	[_routeViewsContainer setFrame:frame];
	int offset = self.view.frame.size.width/2-80;
	frame = CGRectMake(offset+200*_route.count, 0, 160, 240);//Make frame for section
	RouteSectionView *view = [[RouteSectionView alloc] initWithFrame:frame];
	RouteSection *section = [[RouteSection alloc] initWithRouteType:RouteTypeNone];
	[view setSection:section];//Set view's section
	[view loadData];//Load data from section
	[_route addObject:section];//Add section to array of sections
	[_routeViews addObject:view];//Add view to array of section views
	[_routeViewsContainer addSubview:view];//Add view to container
	[_scrollView setContentSize:_routeViewsContainer.frame.size];//Set new size for scrollview's content
	if (_scrollView.contentSize.width > self.view.frame.size.width) {
		CGPoint offset = CGPointMake(_scrollView.contentSize.width - _scrollView.bounds.size.width, 0);
		[self.scrollView setContentOffset:offset animated:true];//Offset to show the right-most icon
	}
}

- (void)removeAddNewSectionViewFromContainer {
	CGRect frame = _routeViewsContainer.frame;
	frame.size.width = frame.size.width-200;
	[_routeViewsContainer setFrame:frame];
	
	[[_routeViews lastObject] removeFromSuperview];
	[_route removeLastObject];
	[_routeViews removeLastObject];
	
	[_scrollView setContentSize:CGSizeMake(200*_route.count, 240)];//Set new size for scrollview's content
}

- (void)openNewSectionView:(UIButton *)sender {
	_editSectionView.hidden = false;
	[UIView animateWithDuration:.3 animations:^{
		[_editSectionView.layer setOpacity:1];
	}];
	
	for (int i=0; i<_route.count; i++) {
		if ([_routeViews[i] iconButton] == sender) {
			SECTIONTOEDIT = i;
			break;
		}
	}
	
	RouteSection *section = _route[SECTIONTOEDIT];
	ISADDINGNEWSECTION = section.type==RouteTypeNone;
	
	
	if (!ISADDINGNEWSECTION) {
//		load section to edit
//		UITextField text = section.seconds etc
	}
}

- (IBAction)closeNewSectionView:(id)sender {
//	Edit old "new section button" info
	RouteSection *section = _route[SECTIONTOEDIT];
//	section.rpm = UITextField…;
	section.type = RouteTypeStraightStand;
	[section changeIcon];
	[_routeViews[SECTIONTOEDIT] setSection:section];
	[_routeViews[SECTIONTOEDIT] loadData];
	
	if (ISADDINGNEWSECTION) {
//		Add new "new section button"
		[self insertAddNewSectionViewToContainer];
	}
	
	[UIView animateWithDuration:.3 animations:^{
		[_editSectionView.layer setOpacity:0];
	} completion:^(BOOL finished) {
		_editSectionView.hidden = false;
	}];
}

- (void)statusChanged {
//	CurrentStatusEmpty		= no button
//	CurrentStatusReady		= new/start
//	CurrentStatusRunning	= pause
//	CurrentStatusPaused		= stop/continue
//	CurrentStatusEnded		= new/restart
	
//	ready->running
//	CGPoint offset = CGPointMake(0, 0);
//	[self.scrollView setContentOffset:offset animated:true];
//	[self removeAddNewSectionViewFromContainer];
}

#pragma mark Saving / Loading

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

- (void)resetRoute {
	[_route removeAllObjects];
	[_routeViewsContainer removeFromSuperview];
	RouteSection *section = [[RouteSection alloc] initWithRouteType:RouteTypeNone];
	[_route addObject:section];
	[self saveRoute];
	[self loadViewsIntoContainer];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end