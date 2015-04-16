//
//  ChooseSectionTypeTableViewController.h
//  SpinPal
//
//  Created by manolo on 4/9/15.
//  Copyright (c) 2015 manolosavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "RouteSection.h"

@interface ChooseSectionTypeTableViewController : UITableViewController

///Section to edit.
@property RouteSection *section;

/**
 Returns the appropiate @c NSInteger for the section type based on the index sent.
 @param index Selected row in the TableView.
 @return Appropiate section type as NSInteger.
 */
- (NSInteger)getSectionType:(NSInteger)index;

/**
 When appropiate, returns the @c intensity value for the section type based on the index sent.
 @param index Selected row in the @c TableView.
 @return Intensity value for the section as @c NSInteger.
 */
- (NSInteger)getIntensity:(NSInteger)index;

@end