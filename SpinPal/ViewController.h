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

/**
 Defines the current status of the app.
 
 CurrentStatusEmpty: The route is currently empty, can add new section to route.
 
 CurrentStatusReady: There's a route loaded, can start route.
 
 CurrentStatusRunning: Route is currently running, can pause.
 
 CurrentStatusPaused: Route is currently paused, can continue or stop.
 
 CurrentStatusEnded: The route has finished, can restart or create a new route.
 */
typedef NS_ENUM(NSInteger, CurrentStatus) {
	CurrentStatusEmpty		= -1,
	CurrentStatusReady		= 0,
	CurrentStatusRunning	= 1,
	CurrentStatusPaused		= 2,
	CurrentStatusEnded		= 3,
};

///Array of RouteSections for the current route.
@property (nonatomic, strong) NSMutableArray *routes;

///Array of RouteSections for the current route.
@property (strong) NSMutableArray *route;

///Array of RouteSectionViews for the current route.
@property (strong) NSMutableArray *routeViews;

///View where all the views from routeViews will be added.
@property (strong) UIView *routeViewsContainer;

///Main left side button. Depending on the app's current status actions can be: Start, Pause, Continue, Restart.
@property (strong) UIButton *leftButton;

///Main right side button. Depending on the app's current status actions can be: New, Stop
@property (strong) UIButton *rightButton;

///Route section that serves to change the type of section that is being edited after choosing a new type on ChooseSectionTypeTableViewController.
@property (strong) RouteSection *changeSectionType;

///PickerView to choose number of seconds when adding/editing a section.
@property (strong) UIPickerView *secondsPickerView;

///PickerView to choose number of jumps when adding/editing a section.
@property (strong) UIPickerView *jumpCountPickerView;

///Button to save the new/edited section into the main view.
@property (strong) UIButton *saveButton;

///Button to delete the section that's being currently edited.
@property (strong) UIButton *deleteButton;

///Special RouteSectionView with user interaction enabled to be able to choose the right values when adding/editing a section.
@property (weak, nonatomic) IBOutlet RouteSectionView *editableSectionView;

///View that shows when adding/editing a section.
@property (weak, nonatomic) IBOutlet UIVisualEffectView *editSectionView;

///ScrollView containing the routeViewsContainer.
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

///Label that shows the sum of the duration of all sections in the current route in m:ss format.
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *routeOverviewButton;


/**
 Loads all @c RouteSectionViews from @c routeViews into @c routeViewsContainer.
 */
- (void)loadViewsIntoContainer;

/**
 Calculates the total duration for all sections in the route and updates @c totalTimeLabel.
 */
- (void)loadTotalTime;

/**
 Inserts a new @c RouteSectionView with type @c SectionTypeNone into @c routeViewsContainer to serve as a New Section button.
 */
- (void)insertAddNewSectionViewToContainer;

/**
 Removes the last @c RouteSectionView in @c routeViewsContainer if it is of type @c SectionTypeNone.
 */
- (void)removeAddNewSectionViewFromContainer;

/**
 Transitions the section type from @c changeSectionType into @c editableSectionView.
 @param sender Segue that is calling the method.
 */
- (IBAction)unwindChooseSectionType:(UIStoryboardSegue *)sender;

/**
 Shows @c editSectionView after tapping on a @c RouteSectionView to edit a section or add a new one.
 @param sender Button of the @c RouteSectionView that's calling the method.
 */
- (void)openEditSectionView:(UIButton *)sender;

/**
 Changes @c deleteButton's frame to hide it.
 */
- (void)hideDeleteButton;

/**
 Changes @c deleteButton's frame to show it.
 */
- (void)showDeleteButton;

/**
 Ends editing mode to hide the keyboard/PickerView.
 @param sender Object that is calling the method.
 */
- (IBAction)hideKeyboard:(id)sender;

/**
 Scrolls the @c ScrollView to the first @c RouteSectionView, and starts a timer after initializing @c remainingTime, @c @c currentRunningSection, and @c currentSectionRemainingTime with their appropiate values.
 */
- (void)startTimer;

/**
 Resumes the timer after it was paused.
 */
- (void)continueTimer;

/**
 Updates @c remainingTime, @c currentRunningSection, and @c currentSectionRemainingTime with their appropiate values every second. Also updates the appropiate labels in the @c RouteSectionViews in addition to @c totalTimeLabel.
 */
- (void)timerFired;

/**
 Closes @c editSectionView and saves the new/edited section.
 */
- (void)closeEditSectionView;

/**
 Asks the user for confirmation before deleting the section that's being currently edited.
 */
- (void)askDeleteSection;

/**
 Deletes the section that's being currently edited and closes @c editSectionView.
 */
- (void)deleteSection;

/**
 Called when @c leftButton is tapped, performs the appropiate action based on the app's current status.
 *
 @c CurrentStatusReady: Button is set to Start. Changes current status to @c CurrentStatusRunning.
 *
 @c CurrentStatusRunning: Button is set to Pause. Changes current status to @c CurrentStatusPaused.
 *
 @c CurrentStatusPaused: Button is set to Contine. Changes current status to @c CurrentStatusRunning.
 *
 @c CurrentStatusEnded: Button is set to Restart. Changes current status to @c CurrentStatusRunning.
 */
- (void)leftButtonTapped;

/**
 Called when @c rightButton is tapped, performs the appropiate action based on the app's current status.
 *
 @c CurrentStatusReady: Button is set to New. Asks to reset route.
 *
 @c CurrentStatusPaused: Button is set to Stop. Changes current status to @c CurrentStatusReady.
 *
 @c CurrentStatusEnded: Button is set to New. Asks to reset route.
 */
- (void)rightButtonTapped;

/**
 Animates @c rightButton's frame to hide it.
 */
- (void)hideRightButton;

/**
 Animates @c rightButton's frame to show it.
 */
- (void)showRightButton;

/**
 Updates the app's status.
 *
 Change to @c CurrentStatusEmpty: Hides @c leftButton and @c rightButton, enables interaction with @c scrollView.
 *
 Change to @c CurrentStatusReady: Shows @c leftButton and @c rightButton with the titles of Start and New respectively. Enables interaction with @c scrollView. If previous status was @c CurrentStatusPaused it also calls @c -insertAddNewSectionViewToContainer.
 *
 Change to @c CurrentStatusRunning: Calls @c -loadTotalTime and @c -removeAddNewSectionViewFromContainer. Calls @c -startTimer or @c -continueTimer depending if the previous status was @c CurrentStatusReady/CurrentStatusEnded or @c CurrentStatusPaused respectively. Hides @c rightButton and sets the @c leftButton's title to Pause. Disables interaction with @c scrollView.
 *
 Change to @c CurrentStatusPaused: Pauses the timer and disables interaction with @c scrollView. Shows @c leftButton and @c rightButton with the titles of Continue and Stop respectively.
 * 
 Change to @c CurrentStatusEnded: Disables interaction with @c scrollView. Shows @c leftButton and @c rightButton with the titles of Continue and Stop respectively.
 @param newStatus Status the app will have when the method finishes.
 */
- (void)setStatus:(CurrentStatus)newStatus;

/**
 Gets the path to the file where the route is saved.
 @return String with the path to the file.
 */
- (NSString *)routeFilename;

/**
 Loads saved route from disk.
 @return Array of @c RouteSections that make the route
 */
- (NSMutableArray *)getRoute;

- (NSMutableArray *)getRoutes;
- (void)setRoutes:(NSMutableArray*)routes;

/**
 Saves the current route to disk.
 @return True if the saving succeeded, false otherwise.
 */
- (BOOL)saveRoute;

/**
 Resets the route by deleting all sections in the current route.
 */
- (void)resetRoute;

/**
 Asks the user for confirmation before reseting the route.
 */
- (void)askResetRoute;

/**
 Updates the rpm value on @c editableSectionView's section based on the newly entered value on @c editableSectionView's @c rpmTextField. Also removes leading zeros from @c editableSectionView's @c rpmTextField.
 */
- (void)rpmDidChange;

@end