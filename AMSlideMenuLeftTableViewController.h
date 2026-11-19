//
//  AMSlideMenuLeftTableViewController.h
//  AMSlideMenu
//
// The MIT License (MIT)
//
// Created by : arturdev
// Copyright (c) 2014 SocialObjects Software. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE

#import <UIKit/UIKit.h>
#import "MyClass.h"

@class AMSlideMenuMainViewController;

@interface AMSlideMenuLeftTableViewController : UITableViewController

@property (weak, nonatomic) AMSlideMenuMainViewController *mainVC;
@property (nonatomic) BOOL prepareforsegue;
@property (nonatomic,strong) NSString *sourceview;
@property (nonatomic,strong) NSString *studentprofile_studentkey;
@property (nonatomic) NSInteger studentprofile_submenu;
@property (nonatomic) NSInteger centersetup_submenu;
@property (nonatomic) NSString * centersetup_submenukey;
@property (nonatomic,strong) ClassKeys *studentprofile_classkeys;
@property (nonatomic,strong) NSString *taskassignment_selectedtaskview;
@property (nonatomic,strong) NSString *taskassignment_selectedview;
@property (nonatomic,strong) NSString *taskassignment_selectedtaskkey;
@property (nonatomic,strong) NSString *assessment_selecteddtkey;
@property (nonatomic,strong) NSString *studentprofile_saleskey;
@property (nonatomic,strong) NSString *leadprofile_leadkey;
@property (nonatomic,strong) NSString *renewal_selectedview;
@property (nonatomic) NSInteger leadprofile_submenu;

@property (nonatomic,strong) NSString *studentinformationaction;
@property (nonatomic,strong) AssessmentTrialRecord *studentinformationatobject;
@property (nonatomic,strong) ClassScheduleRecord *studentinformationclassscheduleobject;
@property (nonatomic,strong) Lead *studentinformationleadobject;
@property (nonatomic,strong) DTRecord *studentinformationdtobject;
@property (nonatomic,strong) NSString *datedisplayed;


// Only afor non storyboard use
- (void)openContentNavigationController:(UINavigationController *)nvc;

@end
