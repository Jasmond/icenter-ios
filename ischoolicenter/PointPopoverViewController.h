//
//  PointPopoverViewController.h
//  ischoolicenter
//
//  Created by Jasmond Luk on 13/7/2023.
//  Copyright © 2023 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "CalendarView.h"

@protocol myPointPopoverViewControllerDelegate <NSObject>

-(void) updatepointrecord;
-(void) dismissPointPopoverWithReloadStudent:(BOOL)reloadstudent;
-(void) dismissPointPopoverduetoconnectionerror;
-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width;

@end

@interface PointPopoverViewController : UIViewController<myCalendarViewDelegate>
{
    GlobalVariables *globalvariables;
    UIStoryboard *mainStoryboard;
    
    __weak IBOutlet UIToolbar *PointToolBar;
    __weak IBOutlet UITableView *PointPopoverTable;
    __weak IBOutlet NSLayoutConstraint *tablebottomconstraint;
    __weak IBOutlet NSLayoutConstraint *studenttablebottomconstraint;
    __weak IBOutlet UIView *DateMasterView;
    __weak IBOutlet UIView *StudentMasterView;
    
    PointRecord *workingPointRecord;
    BOOL keyboardshow;
    float keyboardheight;
    
    BOOL showDateTable;
    BOOL showStudentTable;
    
    
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
    
    __weak IBOutlet UIButton *editButton;
    __weak IBOutlet UIButton *deleteButton;
    __weak IBOutlet UIButton *doneButton;
    
}

@property (nonatomic, strong) PointRecord * PointRecordObject;
@property (nonatomic,strong) NSMutableArray *studentkeys;
@property (nonatomic) BOOL multiplestudents;
@property (nonatomic) NSInteger PointTableMode;
@property (nonatomic,weak) id<myPointPopoverViewControllerDelegate>delegate;
- (IBAction)backbuttonpressed:(id)sender;
- (IBAction)nonebuttonpressed:(id)sender;

-(IBAction) editButtonPressed:(id)sender;
-(IBAction) doneButtonPressed:(id)sender;
-(IBAction) deleteButtonPressed:(id)sender;

@end


