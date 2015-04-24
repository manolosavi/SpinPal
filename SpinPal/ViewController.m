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

UIColor *green, *red;
static BOOL ISADDINGNEWSECTION;
static NSInteger SECTIONTOEDIT;
static CurrentStatus STATUS;
static NSTimer *timer;
static NSTimeInterval remainingTime;
static NSTimeInterval currentSectionRemainingTime;
static int currentRunningSection;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	green = [UIColor colorWithHue:138/360.0 saturation:.77 brightness:.9 alpha:1];
	red = [UIColor colorWithHue:3/360.0 saturation:.77 brightness:.9 alpha:1];
	
	_editSectionView.hidden = true;
	[_editSectionView.layer setOpacity:0];
	
	CGRect frame = CGRectMake(0, self.view.frame.size.height-80, self.view.frame.size.width/2, 80);
	_leftButton = [[UIButton alloc] initWithFrame:frame];
	[_leftButton setBackgroundColor:green];
	_saveButton = [[UIButton alloc] initWithFrame:frame];
	[_saveButton setBackgroundColor:green];
	frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height-80, self.view.frame.size.width/2, 80);
	_rightButton = [[UIButton alloc] initWithFrame:frame];
	[_rightButton setBackgroundColor:red];
	_deleteButton = [[UIButton alloc] initWithFrame:frame];
	[_deleteButton setBackgroundColor:red];
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
	_editableSectionView.rpmTextField.userInteractionEnabled = true;
	[_editableSectionView.rpmTextField addTarget:self action:@selector(rpmDidChange) forControlEvents:UIControlEventEditingChanged];
	_secondsPickerView = [[UIPickerView alloc] init];
	_secondsPickerView.delegate = self;
	_secondsPickerView.dataSource = self;
	[_secondsPickerView setBackgroundColor:[UIColor colorWithHue:33/360. saturation:.03 brightness:.9 alpha:1]];
	_editableSectionView.secondsTextField.inputView = _secondsPickerView;
	_jumpCountPickerView = [[UIPickerView alloc] init];
	_jumpCountPickerView.delegate = self;
	_jumpCountPickerView.dataSource = self;
	[_jumpCountPickerView setBackgroundColor:[UIColor colorWithHue:33/360. saturation:.03 brightness:.9 alpha:1]];
	_editableSectionView.jumpCountTextField.inputView = _jumpCountPickerView;
	[_saveButton setTitle:@"Save" forState:UIControlStateNormal];
	[_deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
	[_saveButton.titleLabel setFont:font];
	[_saveButton.titleLabel setTextColor:[UIColor whiteColor]];
	[_deleteButton.titleLabel setFont:font];
	[_deleteButton.titleLabel setTextColor:[UIColor whiteColor]];
	[_editSectionView.contentView insertSubview:_saveButton atIndex:_editSectionView.contentView.subviews.count];
	[_editSectionView.contentView insertSubview:_deleteButton atIndex:_editSectionView.contentView.subviews.count];
	[_saveButton addTarget:self action:@selector(closeEditSectionView) forControlEvents:UIControlEventTouchUpInside];
	[_deleteButton addTarget:self action:@selector(askDeleteSection) forControlEvents:UIControlEventTouchUpInside];
	
	_route = [[NSMutableArray alloc] initWithObjects:nil];
	[self resetRoute];
}

- (void)loadViewsIntoContainer {
	CGRect frame = CGRectMake(0, 0, self.view.frame.size.width-200 + 200*_route.count, 240);
	
	if (!_routeViewsContainer) {
		_routeViewsContainer = [[UIView alloc] initWithFrame:frame];
	} else {
		[_routeViewsContainer setFrame:frame];
	}
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
	NSInteger max = ([((RouteSection*)[_route lastObject]) type] == SectionTypeNone)?_route.count-1:_route.count;
	for (int i=0; i<max; i++) {
		total += [_route[i] seconds];
		[_routeViews[i] loadData];
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
	RouteSection *section = [[RouteSection alloc] initWithSectionType:SectionTypeNone];
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
	RouteSectionView *lastView = [_routeViews lastObject];
	if ([[lastView section] type] == SectionTypeNone) {
		CGRect frame = _routeViewsContainer.frame;
		frame.size.width = frame.size.width-200;
		[_routeViewsContainer setFrame:frame];
		[[_routeViews lastObject] removeFromSuperview];
		[_route removeLastObject];
		[_routeViews removeLastObject];
		[_scrollView setContentSize:CGSizeMake(200*_route.count, 240)];//Set new size for scrollview's content
	}
}

- (IBAction)unwindChooseSectionType:(UIStoryboardSegue *)sender {
	RouteSection *r = _editableSectionView.section;
	_editableSectionView.section = _changeSectionType;
	_editableSectionView.section.seconds = r.seconds;
	_editableSectionView.section.rpm = r.rpm;
	_editableSectionView.section.jumpCount = r.jumpCount;
	_editableSectionView.section.rightSide = r.rightSide;
	[_editableSectionView loadData];
}

- (IBAction)unwindSavedRoutesView:(UIStoryboardSegue *)sender {
	_route = [[sender sourceViewController] route];
}

- (void)openEditSectionView:(UIButton *)sender {
	if (sender == _editableSectionView.iconButton) {
		[self performSegueWithIdentifier:@"chooseSectionTypeSegue" sender:nil];
		return;
	}
	
	for (int i=0; i<_route.count; i++) {
		if ([_routeViews[i] iconButton] == sender) {
			SECTIONTOEDIT = i;
			break;
		}
	}
	
	RouteSection *section = _route[SECTIONTOEDIT];
	ISADDINGNEWSECTION = section.type==SectionTypeNone;
	
	if (ISADDINGNEWSECTION) {
		[self performSegueWithIdentifier:@"chooseSectionTypeSegue" sender:nil];
		[self hideDeleteButton];
	} else {
//		load section to edit
		[_editableSectionView.section changeIcon];
		[_editableSectionView loadData];
		[self showDeleteButton];
	}
    [_editableSectionView setSection:section];
	_editSectionView.hidden = false;
	[UIView animateWithDuration:.3 animations:^{
		[_editSectionView.layer setOpacity:1];
		[_editableSectionView.layer setOpacity:1];
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:.7 delay:.5 options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionRepeat) animations:^{
			CGFloat minOpacity = .5;
			[_editableSectionView.secondsTextField.layer setOpacity:minOpacity];
			[_editableSectionView.jumpCountTextField.layer setOpacity:minOpacity];
			[_editableSectionView.rpmTextField.layer setOpacity:minOpacity];
			[_editableSectionView.rightSideButton.layer setOpacity:minOpacity];
		} completion:nil];
	}];
}

- (void)hideDeleteButton {
	CGRect lFrame = CGRectMake(0, self.view.frame.size.height-80, self.view.frame.size.width, 80);
	CGRect rFrame = CGRectMake(self.view.frame.size.width, self.view.frame.size.height-80, self.view.frame.size.width/2, 80);
	
	[_saveButton setFrame:lFrame];
	[_deleteButton setFrame:rFrame];
}

- (void)showDeleteButton {
	CGRect lFrame = CGRectMake(0, self.view.frame.size.height-80, self.view.frame.size.width/2, 80);
	CGRect rFrame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height-80, self.view.frame.size.width/2, 80);
	
	[_saveButton setFrame:lFrame];
	[_deleteButton setFrame:rFrame];
}

- (IBAction)hideKeyboard:(id)sender {
	[_editableSectionView endEditing:true];
}

- (void)startTimer {
	int total = 0;
	for (int i=0; i<_route.count; i++) {
		total += [_route[i] seconds];
	}
	remainingTime = total;
	currentRunningSection = 0;
	currentSectionRemainingTime = [[((RouteSectionView*)_routeViews[0]) section] seconds];
	timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

- (void)continueTimer {
	timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

- (void)timerFired {
	if (remainingTime-- > 1) {
		if (currentSectionRemainingTime-- > 1) {
			[_routeViews[currentRunningSection] secondsTextField].text = [NSString stringWithFormat:@"%i:%.2i", (int)currentSectionRemainingTime/60, (int)currentSectionRemainingTime%60];
		} else if (currentRunningSection < _route.count) {
			[_routeViews[currentRunningSection++] secondsTextField].text = [NSString stringWithFormat:@"0:00"];
			currentSectionRemainingTime = [[((RouteSectionView*)_routeViews[currentRunningSection]) section] seconds];
			CGPoint offset = _scrollView.contentOffset;
			offset.x += 200;
			[_scrollView setContentOffset:offset animated:true];
		}
		_totalTimeLabel.text = [NSString stringWithFormat:@"%i:%.2i", (int)remainingTime/60, (int)remainingTime%60];
	} else {
		_totalTimeLabel.text = @"0:00";
		[_routeViews[currentRunningSection++] secondsTextField].text = @"0:00";
		[timer invalidate];
		[self setStatus:CurrentStatusEnded];
	}
}

- (void)closeEditSectionView {
	if (_editableSectionView.section.seconds < 5) {
		[[[UIAlertView alloc] initWithTitle:@"Section can't be 0 seconds long"
									message:@"Please change the duration of the section and try again."
								   delegate:nil
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil] show];
		[_editableSectionView.secondsTextField becomeFirstResponder];
		return;
	}
//	Edit old "new section button" info
	RouteSection *section = _route[SECTIONTOEDIT];
	section = _editableSectionView.section;
	section.intensity = _editableSectionView.section.intensity;
	[section changeIcon];
	_route[SECTIONTOEDIT] = section;
	[_routeViews[SECTIONTOEDIT] setSection:section];
	[_routeViews[SECTIONTOEDIT] loadData];
	
	if (ISADDINGNEWSECTION) {
//		Add new "new section button"
		[self insertAddNewSectionViewToContainer];
	} else {
		[self loadTotalTime];
	}
	
	[self setStatus:(_route.count>1)?CurrentStatusReady:CurrentStatusEmpty];
	[UIView animateWithDuration:.3 animations:^{
		[_editSectionView.layer setOpacity:0];
		[_editableSectionView.layer setOpacity:0];
	} completion:^(BOOL finished) {
		_editSectionView.hidden = false;
        [_secondsPickerView selectRow:0 inComponent:0 animated:false];
        [_secondsPickerView selectRow:0 inComponent:1 animated:false];
        [_jumpCountPickerView selectRow:0 inComponent:0 animated:false];
	}];
}

- (void)askDeleteSection {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
													message:@"This will delete the selected section. You can't undo this."
												   delegate:self
										  cancelButtonTitle:@"Cancel"
										  otherButtonTitles:@"Delete", nil];
	alert.tag = 1;
	[alert show];
}

- (void)deleteSection {
	[_route removeObjectAtIndex:SECTIONTOEDIT];
	for (int i=0; i<_routeViews.count; i++) {
		[_routeViews[i] removeFromSuperview];
	}
	[_routeViews removeAllObjects];
	[self loadViewsIntoContainer];
	
	[self setStatus:(_route.count>1)?CurrentStatusReady:CurrentStatusEmpty];
	[UIView animateWithDuration:.3 animations:^{
		[_editSectionView.layer setOpacity:0];
		[_editableSectionView.layer setOpacity:0];
	} completion:^(BOOL finished) {
		_editSectionView.hidden = false;
	}];
}

- (void)leftButtonTapped {
	switch (STATUS) {
		case CurrentStatusEmpty://no button
			break;
		case CurrentStatusReady://start
			[self setStatus:CurrentStatusRunning];
			break;
		case CurrentStatusRunning://pause
			[self setStatus:CurrentStatusPaused];
			break;
		case CurrentStatusPaused://continue
			[self setStatus:CurrentStatusRunning];
			break;
		case CurrentStatusEnded://restart
			[self setStatus:CurrentStatusRunning];
			break;
	}
}

- (void)rightButtonTapped {
	switch (STATUS) {
		case CurrentStatusEmpty://no button
			break;
		case CurrentStatusReady://new
			[self askResetRoute];
			break;
		case CurrentStatusRunning://no button
			break;
		case CurrentStatusPaused://stop
			[self setStatus:CurrentStatusReady];
			break;
		case CurrentStatusEnded://new
			[self askResetRoute];
			break;
	}
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
//	CurrentStatusReady		= start/new
//	CurrentStatusRunning	= pause
//	CurrentStatusPaused		= continue/stop
//	CurrentStatusEnded		= restart/new
	
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
			[self showRightButton];
			[_leftButton setTitle:@"Start" forState:UIControlStateNormal];
			[_rightButton setTitle:@"New" forState:UIControlStateNormal];
			_leftButton.hidden = false;
			_rightButton.hidden = false;
			[UIView animateWithDuration:.2 animations:^{
				[_leftButton.layer setOpacity:1];
				[_rightButton.layer setOpacity:1];
			}];
			if (STATUS == CurrentStatusPaused) {
				[self insertAddNewSectionViewToContainer];
			}
			[_scrollView setUserInteractionEnabled:true];
			}break;
		case CurrentStatusRunning:{
			if (STATUS == CurrentStatusReady || STATUS == CurrentStatusEnded) {
				if (STATUS == CurrentStatusEnded) {
					[self loadTotalTime];
				}
				CGPoint offset = CGPointMake(0, 0);
				[_scrollView setContentOffset:offset animated:true];
				[UIView animateWithDuration:.2 animations:^{
//					Hide it first, delete after delay to avoid problems with scroll offset
					if ([[(RouteSectionView*)[_routeViews lastObject] section] type] == SectionTypeNone) {
						[[[_routeViews lastObject] layer] setOpacity:0];
					}
				}];
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					[self removeAddNewSectionViewFromContainer];
				});
				[self startTimer];
			} else if (STATUS == CurrentStatusPaused) {
				[self continueTimer];
			}
			[self hideRightButton];
			[_leftButton setTitle:@"Pause" forState:UIControlStateNormal];
			[_scrollView setUserInteractionEnabled:false];
			}break;
		case CurrentStatusPaused:
			[timer invalidate];
			[self showRightButton];
			[_leftButton setTitle:@"Continue" forState:UIControlStateNormal];
			[_rightButton setTitle:@"Stop" forState:UIControlStateNormal];
			[_scrollView setUserInteractionEnabled:false];
			break;
		case CurrentStatusEnded:
			[self showRightButton];
			[_leftButton setTitle:@"Restart" forState:UIControlStateNormal];
			[_rightButton setTitle:@"New" forState:UIControlStateNormal];
			[_scrollView setUserInteractionEnabled:false];
			break;
	}
	BOOL hideOverview = (newStatus == CurrentStatusEmpty || newStatus == CurrentStatusRunning);
	BOOL hideSavedRoutes = (newStatus == CurrentStatusRunning || newStatus == CurrentStatusPaused);
    [UIView animateWithDuration:.2 animations:^{
        [_routeOverviewButton.layer setOpacity:hideOverview? 0 : 1];
		[_savedRoutesButton.layer setOpacity:hideSavedRoutes? 0 : 1];
    } completion:^(BOOL finished) {
        _routeOverviewButton.hidden = hideOverview;
		_savedRoutesButton.hidden = hideSavedRoutes;
    }];
	STATUS = newStatus;
}

- (void)resetRoute {
	CGPoint offset = CGPointMake(0, 0);
	[_scrollView setContentOffset:offset animated:true];
	[UIView animateWithDuration:.2 animations:^{
		[_scrollView.layer setOpacity:0];
	} completion:^(BOOL finished) {
		for (int i=0; i<_route.count; i++) {
			[_routeViewsContainer.subviews[0] removeFromSuperview];
		}
		[_route removeAllObjects];
		_totalTimeLabel.text = @"0:00";
		RouteSection *section = [[RouteSection alloc] initWithSectionType:SectionTypeNone];
		[_route addObject:section];
		[self loadViewsIntoContainer];
		[_scrollView setContentOffset:offset animated:false];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[UIView animateWithDuration:.2 animations:^{
				[_scrollView.layer setOpacity:1];
			}];
		});
	}];
	[self setStatus:CurrentStatusEmpty];
}

- (void)askResetRoute {
	[[[UIAlertView alloc] initWithTitle:@"Are you sure?"
								message:@"This will delete your current route. You can't undo this."
							   delegate:self
					  cancelButtonTitle:@"Cancel"
					  otherButtonTitles:@"Create New", nil] show];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - AlertView/PickerView methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == [alertView cancelButtonIndex]){
		
	} else {
		if (alertView.tag == 1) {
			[self deleteSection];
		} else {
			[self resetRoute];
		}
	}
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return (_editableSectionView.secondsTextField.isFirstResponder)?2:1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (_editableSectionView.secondsTextField.isFirstResponder) {
		if (component == 0) {
			return 5;
		} else {
			return 12;
		}
	} else {
		return 4;
	}
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	NSInteger number;
	if (_editableSectionView.secondsTextField.isFirstResponder) {
		if (component == 0) {
			number = row;
		} else {
			number = row*5;
		}
	} else {
		number = pow(2, row);
	}
	return [NSString stringWithFormat:@"%ld", number];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if (_editableSectionView.secondsTextField.isFirstResponder) {
		NSInteger mins = [pickerView selectedRowInComponent:0];
		NSInteger secs = [pickerView selectedRowInComponent:1]*5;
		[_editableSectionView.section setSeconds:(NSTimeInterval)(mins*60 + secs)];
		_editableSectionView.secondsTextField.text = [NSString stringWithFormat:@"%ld:%.2ld", mins, secs];
	} else {
		[_editableSectionView.section setJumpCount:pow(2, row)];
		_editableSectionView.jumpCountTextField.text = [NSString stringWithFormat:@"%.0f", pow(2, row)];
	}
}

- (void)rpmDidChange {
//	Remove leading zeros.
	_editableSectionView.rpmTextField.text = [_editableSectionView.rpmTextField.text stringByReplacingOccurrencesOfString:@"^0+" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, _editableSectionView.rpmTextField.text.length)];
	[_editableSectionView.section setRpm:[_editableSectionView.rpmTextField.text integerValue]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.destinationViewController isKindOfClass:[NavigationViewController class]]) {
		[segue.destinationViewController setRoute:_route];
	}
}

@end