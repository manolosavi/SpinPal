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
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@end

@implementation ViewController

UIColor *green, *red;
static BOOL ISADDINGNEWSECTION;
static NSInteger SECTIONTOEDIT;
static CurrentStatus STATUS, OLDSTATUS;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	green = [UIColor colorWithHue:138/360.0 saturation:.77 brightness:.9 alpha:1];
	red = [UIColor colorWithHue:3/360.0 saturation:.77 brightness:.9 alpha:1];
	
	_editSectionView.hidden = true;
	[_editSectionView.layer setOpacity:0];
	
	_route = [self getRoute];
	
	CGRect frame = CGRectMake(0, self.view.frame.size.height-80, self.view.frame.size.width/2, 80);
	_leftButton = [[UIButton alloc] initWithFrame:frame];
	[_leftButton setBackgroundColor:green];
	frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height-80, self.view.frame.size.width/2, 80);
	_rightButton = [[UIButton alloc] initWithFrame:frame];
	[_rightButton setBackgroundColor:red];
	[self.view insertSubview:_leftButton atIndex:0];
	[self.view insertSubview:_rightButton atIndex:0];
	[_leftButton addTarget:self action:@selector(leftButtonTapped) forControlEvents:UIControlEventTouchUpInside];
	[_rightButton addTarget:self action:@selector(rightButtonTapped) forControlEvents:UIControlEventTouchUpInside];
	[_leftButton setTitle:@"Left" forState:UIControlStateNormal];
	[_rightButton setTitle:@"Right" forState:UIControlStateNormal];
	UIFont *font = [UIFont fontWithName:@"AvenirNext-Medium" size:25];
	[_leftButton.titleLabel setFont:font];
	[_leftButton.titleLabel setTextColor:[UIColor whiteColor]];
	[_rightButton.titleLabel setFont:font];
	[_rightButton.titleLabel setTextColor:[UIColor whiteColor]];
	_leftButton.hidden = true;
	[_leftButton.layer setOpacity:0];
	_rightButton.hidden = true;
	[_rightButton.layer setOpacity:0];
	
	_editableSectionView.rightSideButton.userInteractionEnabled = true;
	_editableSectionView.jumpCountTextField.userInteractionEnabled = true;
	_editableSectionView.secondsTextField.userInteractionEnabled = true;
	_pickerView = [[UIPickerView alloc] init];
	_pickerView.delegate = self;
	_pickerView.dataSource = self;
	_editableSectionView.secondsTextField.inputView = _pickerView;
	_editableSectionView.rpmTextField.userInteractionEnabled = true;
	[_closeButton setBackgroundColor:green];
	
	[self setStatus:(_route.count>1)?CurrentStatusReady:CurrentStatusEmpty];
	
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
	[self loadTotalTime];
}

- (void)loadTotalTime {
	int total = 0;
	NSInteger max = ([((RouteSection*)[_route lastObject]) type] == RouteTypeNone)?_route.count-1:_route.count;
	for (int i=0; i<max; i++) {
		total += [_route[i] seconds];
	}
	if (max < 1) {
		_totalTimeLabel.text = @"";
	} else {
		_totalTimeLabel.text = [NSString stringWithFormat:@"%i:%.2i", total/60, total%60];
	}
}

- (void)insertAddNewSectionViewToContainer {
	CGRect frame = _routeViewsContainer.frame;
	frame.size.width = frame.size.width+200;//Make frame for container
	[_routeViewsContainer setFrame:frame];
	int offset = self.view.frame.size.width/2-80;
	frame = CGRectMake(offset+200*_route.count, 0, 160, 240);//Make frame for section
	RouteSectionView *view = [[RouteSectionView alloc] initWithFrame:frame];
	[view.layer setOpacity:0];
	RouteSection *section = [[RouteSection alloc] initWithRouteType:RouteTypeNone];
	[view setSection:section];//Set view's section
	[view loadData];//Load data from section
	[_route addObject:section];//Add section to array of sections
	[_routeViews addObject:view];//Add view to array of section views
	[_routeViewsContainer addSubview:view];//Add view to container
	[UIView animateWithDuration:.2 animations:^{
		[view.layer setOpacity:1];
	}];
	[_scrollView setContentSize:_routeViewsContainer.frame.size];//Set new size for scrollview's content
	if (_scrollView.contentSize.width > self.view.frame.size.width) {
		CGPoint offset = CGPointMake(_scrollView.contentSize.width - _scrollView.bounds.size.width, 0);
		[self.scrollView setContentOffset:offset animated:true];//Offset to show the right-most icon
	}
	[self loadTotalTime];
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

- (IBAction)unwindChooseSectionType:(UIStoryboardSegue *)sender {
	_editableSectionView.section = _changeSectionType;
	[_editableSectionView loadData];
}

- (void)openNewSectionView:(UIButton *)sender {
	if (![[[[[sender superview] superview] superview] superview] isKindOfClass:[UIScrollView class]]) {
		RouteSection *sect = ((RouteSectionView*)[[sender superview] superview]).section;
		[self performSegueWithIdentifier:@"chooseSectionTypeSegue" sender:sect];
		return;
	}
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
	
	
	section = [[RouteSection alloc] initWithRouteType:RouteTypeRaceSit];
	[_editableSectionView setSection:section];
	[_editableSectionView loadData];
	
	if (!ISADDINGNEWSECTION) {
//		load section to edit
		section.seconds = 25;
	} else {
		section.seconds = 25;
	}
}

- (IBAction)hideKeyboard:(id)sender {
	[_editableSectionView endEditing:true];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (component == 0) {
		return 5;
	} else {
		return 12;
	}
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	NSInteger number;
	if (component == 0) {
		number = row;
	} else {
		number = row*5;
	}
	return [NSString stringWithFormat:@"%ld", number];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	int mins = (int)[pickerView selectedRowInComponent:0];
	int secs = (int)[pickerView selectedRowInComponent:1]*5;
	[_editableSectionView.section setSeconds:(NSTimeInterval)(mins*60 + secs)];
	_editableSectionView.secondsTextField.text = [NSString stringWithFormat:@"%i:%.2i", mins, secs];
}

- (IBAction)closeNewSectionView:(id)sender {
//	Edit old "new section button" info
	RouteSection *section = _route[SECTIONTOEDIT];
//	section.rpm = UITextField…;
    
    section.type = _editableSectionView.section.type;
    section.rpm = _editableSectionView.section.rpm;
    section.seconds = _editableSectionView.section.seconds;
    section.rightSide = _editableSectionView.section.rightSide;
    section.jumpCount = _editableSectionView.section.jumpCount;
	[section changeIcon];
	[_routeViews[SECTIONTOEDIT] setSection:section];
	[_routeViews[SECTIONTOEDIT] loadData];
	
	if (ISADDINGNEWSECTION) {
//		Add new "new section button"
		[self insertAddNewSectionViewToContainer];
	}
	
	[self setStatus:(_route.count>1)?CurrentStatusReady:CurrentStatusEmpty];
	[UIView animateWithDuration:.3 animations:^{
		[_editSectionView.layer setOpacity:0];
		[_editableSectionView.layer setOpacity:0];
	} completion:^(BOOL finished) {
		_editSectionView.hidden = false;
	}];
}

- (void)leftButtonTapped {
	if (STATUS == CurrentStatusRunning) {
		[self showRightButton];
		[self setStatus:CurrentStatusReady];
	} else {
		[self hideRightButton];
		[self setStatus:CurrentStatusRunning];
	}
}

- (void)rightButtonTapped {
	
}

- (void)hideRightButton {
	CGRect lFrame = CGRectMake(0, self.view.frame.size.height-80, self.view.frame.size.width, 80);
	CGRect rFrame = CGRectMake(self.view.frame.size.width, self.view.frame.size.height-80, self.view.frame.size.width/2, 80);
	
	[UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
		[_leftButton setFrame:lFrame];
		[_rightButton setFrame:rFrame];
	} completion:nil];
}

- (void)showRightButton {
	CGRect lFrame = CGRectMake(0, self.view.frame.size.height-80, self.view.frame.size.width/2, 80);
	CGRect rFrame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height-80, self.view.frame.size.width/2, 80);
	UIView *v = [[UIView alloc] initWithFrame:rFrame];
	[v setBackgroundColor:red];
	[self.view insertSubview:v atIndex:0];
	[UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
		[_leftButton setFrame:lFrame];
		[_rightButton setFrame:rFrame];
	} completion:^(BOOL finished) {
		[v removeFromSuperview];
	}];
}

- (void)setStatus:(CurrentStatus)newStatus {
//	CurrentStatusEmpty		= no button
//	CurrentStatusReady		= new/start
//	CurrentStatusRunning	= pause
//	CurrentStatusPaused		= stop/continue
//	CurrentStatusEnded		= new/restart
	
	switch (newStatus) {
		case CurrentStatusEmpty:{
			[UIView animateWithDuration:.2 animations:^{
				[_leftButton.layer setOpacity:0];
				[_rightButton.layer setOpacity:0];
			} completion:^(BOOL finished) {
				_leftButton.hidden = true;
				_rightButton.hidden = true;
			}];
			[_scrollView setUserInteractionEnabled:true];
			}break;
		case CurrentStatusReady:{
			[_leftButton setTitle:@"Start" forState:UIControlStateNormal];
			[_rightButton setTitle:@"New" forState:UIControlStateNormal];
			_leftButton.hidden = false;
			_rightButton.hidden = false;
			[UIView animateWithDuration:.2 animations:^{
				[_leftButton.layer setOpacity:1];
				[_rightButton.layer setOpacity:1];
			}];
			if (STATUS == CurrentStatusRunning) {
				[self insertAddNewSectionViewToContainer];
			}
			[_scrollView setUserInteractionEnabled:true];
			}break;
		case CurrentStatusRunning:{
			if (STATUS == CurrentStatusReady) {
				CGPoint offset = CGPointMake(0, 0);
				[_scrollView setContentOffset:offset animated:true];
				[UIView animateWithDuration:.2 animations:^{
//					Hide it first, delete after delay to avoid problems with scroll offset
					[[[_routeViews lastObject] layer] setOpacity:0];
				}];
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					[self removeAddNewSectionViewFromContainer];
				});
			}
			[_leftButton setTitle:@"Pause" forState:UIControlStateNormal];
			[_scrollView setUserInteractionEnabled:false];
			}break;
		case CurrentStatusPaused:
			[_leftButton setTitle:@"Continue" forState:UIControlStateNormal];
			[_rightButton setTitle:@"Stop" forState:UIControlStateNormal];
			[_scrollView setUserInteractionEnabled:false];
			break;
		case CurrentStatusEnded:
			[_leftButton setTitle:@"Restart" forState:UIControlStateNormal];
			[_rightButton setTitle:@"New" forState:UIControlStateNormal];
			[_scrollView setUserInteractionEnabled:true];
			break;
	}
	OLDSTATUS = STATUS;
	STATUS = newStatus;
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