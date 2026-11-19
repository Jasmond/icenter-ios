//
//  CouponPopoverViewController.h
//  iCenter
//
//  Created by Jasmond Luk on 3/3/2023.
//  Copyright © 2023 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "CalendarView.h"

@protocol myCouponPopoverViewControllerDelegate <NSObject>

-(void) updatecouponrecord;
-(void) dismissCouponPopoverWithReloadStudentList:(BOOL)reloadstudentlist;
-(void) dismissCouponPopoverduetoconnectionerror;
-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width;

@end

@interface CouponPopoverViewController : UIViewController<myCalendarViewDelegate>
{
    GlobalVariables *globalvariables;
    UIStoryboard *mainStoryboard;
    
    __weak IBOutlet UIToolbar *CouponToolBar;
    __weak IBOutlet UITableView *CouponPopoverTable;
    __weak IBOutlet NSLayoutConstraint *tablebottomconstraint;
    __weak IBOutlet NSLayoutConstraint *studenttablebottomconstraint;
    __weak IBOutlet UIView *NewCouponMasterView;
    __weak IBOutlet UIView *DateMasterView;
    __weak IBOutlet UIView *StudentMasterView;
    
    CouponRecord *workingCouponRecord;
    BOOL keyboardshow;
    float keyboardheight;
    
    BOOL showNewCouponTable;
    BOOL showDateTable;
    BOOL showStudentTable;
    
    __weak IBOutlet UITableView *NewCouponTable;
    __weak IBOutlet UILabel *title_coupon;
    
    NSMutableArray *filteredNewCouponArray;
    NSMutableArray *newCouponArray;
    
    __weak IBOutlet UISearchBar *newcouponsearchbar;
    __weak IBOutlet UIToolbar *newcoupontoolbar;
    
    CalendarView *datecalendarview;
    __weak IBOutlet UIToolbar *datetoolbar;
    __weak IBOutlet UIButton *backButton;
    __weak IBOutlet UIButton *noneButton;
    __weak IBOutlet UILabel *datetitle;
    
    __weak IBOutlet UITableView *StudentTable;
    __weak IBOutlet UILabel *title_student;
    __weak IBOutlet UIToolbar *studenttoolbar;
    __weak IBOutlet UISearchBar *studentsearchbar;
    NSMutableArray *filteredStudentArray;
    NSMutableArray *StudentArray;
    
    NSString *couponquantity;
    __weak IBOutlet UIButton *deleteButton;
    __weak IBOutlet UIButton *doneButton;
    __weak IBOutlet UIButton *editButton;
}

@property (nonatomic, strong) CouponRecord * CouponRecordObject;
//@property (nonatomic,strong) Student *PopoverStudent;
@property (nonatomic,strong) NSMutableArray *studentkeys;
@property (nonatomic) BOOL multiplestudents;
@property (nonatomic) NSInteger CouponTableMode;
@property (nonatomic,weak) id<myCouponPopoverViewControllerDelegate>delegate;
- (IBAction)backbuttonpressed:(id)sender;
- (IBAction)nonebuttonpressed:(id)sender;

-(IBAction) editButtonPressed:(id)sender;
-(IBAction) doneButtonPressed:(id)sender;
-(IBAction) deleteButtonPressed:(id)sender;

@end

