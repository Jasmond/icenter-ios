//
//  ChangeLogViewController.h
//  iCenter
//
//  Created by Jasmond Luk on 27/5/2022.
//  Copyright © 2022 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyClass.h"
#import "MyObject.h"
#import "MainViewController.h"
#import "SwitchCenterViewController.h"
#import "PickerViewController.h"
#import "CalendarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChangeLogViewController : UIViewController<myPickerViewControllerDelegate,mySwitchCenterViewControllerDelegate,myCalendarViewDelegate>
{
    GlobalVariables *globalvariables;
    UIStoryboard *mainStoryboard;

    __weak IBOutlet UITableView *logTable;
    __weak IBOutlet UISearchBar *searchBar;
    __weak IBOutlet UISegmentedControl *actionSC;
//    __weak IBOutlet UIButton *dateRangeButton;
    __weak IBOutlet UIButton *fromButton;
    __weak IBOutlet UIButton *toButton;
    __weak IBOutlet UIButton *typeButton;
    __weak IBOutlet UILabel *ChangeDetailsHeading;
    
    __weak IBOutlet UILabel *dateHeading;
    __weak IBOutlet UILabel *ChangedByHeading;
    __weak IBOutlet UILabel *studentHeading;
    __weak IBOutlet UILabel *typeHeading;
    __weak IBOutlet UILabel *UserActivityHeading;
    UIView *headertitleview;
    UILabel *headertitlename;
    UILabel *headercentername;
    UIImageView *headercenternamearrow;
    UIButton *switchcenterbutton;
    SwitchCenterViewController *switchcenterviewcontroller;
    
    NSMutableArray *actionArray;
//    NSMutableArray *dateRangeArray;
    NSMutableArray *typeArray;
    NSMutableArray *activityLogArray;
    NSMutableArray *filteredActivityLogArray;
    
    NSString *dateRangeSelected;
    NSString *typeSelected;
    
    UIRefreshControl *tablerefresh;
    
    BOOL runviewdidappear;
    
    CalendarView *calendarview;
//    UIButton *masterviewbutton;
    __weak IBOutlet UIButton *masterviewbutton;
    __weak IBOutlet UIView *masterview;
    __weak IBOutlet NSLayoutConstraint *masterviewleadingconstraint;
    __weak IBOutlet NSLayoutConstraint *masterviewtrailingconstrain;
    
    NSDate *fromDate;
    NSDate *toDate;
    NSString *selectedItem;
}
//- (IBAction)dateRangeButtonPressed:(id)sender;
- (IBAction)fromButtonPressed:(id)sender;
- (IBAction)toButtonPressed:(id)sender;
- (IBAction)typeButtonPressed:(id)sender;
- (IBAction)menubuttonPressed:(id)sender;
- (IBAction)actionUpdated:(UISegmentedControl *)sender;


@end

NS_ASSUME_NONNULL_END
