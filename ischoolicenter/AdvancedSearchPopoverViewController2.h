//
//  AdvancedSearchPopoverViewController2.h
//  iCenter
//
//  Created by Jasmond Luk on 3/12/2022.
//  Copyright © 2022 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "CalendarView.h"

@protocol myAdvancedSearchPopoverViewControllerDelegate <NSObject>

-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width;
-(void) donotrunviewdidappear;
-(void) returnSearchResult:(NSMutableArray *)studentArray;
-(void) dismissAdvancedSearchWithLoading:(BOOL)loading;

@end


@interface AdvancedSearchPopoverViewController2 : UIViewController
{
    GlobalVariables *globalvariables;
    UIStoryboard *mainStoryboard;
    
    __weak IBOutlet UITableView *MessagePopoverTable;
    __weak IBOutlet NSLayoutConstraint *tablebottomconstraint;
    __weak IBOutlet NSLayoutConstraint *producttablebottomconstraint;
    __weak IBOutlet NSLayoutConstraint *paymentstatustablebottomconstraint;
    __weak IBOutlet UIToolbar *MessageToolbar;
    
    OutboxMessageRecord *workingMessage;
    
    BOOL showSubjectTable;
    BOOL showInstructorTable;
    BOOL showClassDateTable;
    BOOL showGradeTable;
    BOOL showStudentStatusTable;
    BOOL showDropTable;
    BOOL showProductTable;
    BOOL showPaymentStatusTable;
    
    UIView *SubjectTableMasterView;
    UITableView *SubjectTable;
    UIToolbar *SubjectTableToolBar;
    UISearchBar *subjectsearchbar;
    
    UIView *InstructorTableMasterView;
    UITableView *InstructorTable;
    UIToolbar *InstructorTableToolBar;
    UISearchBar *instructorsearchbar;
    
    UIView *ClassDateTableMasterView;
    UITableView *ClassDateTable;
    UIToolbar *ClassDateTableToolBar;
    
    UIView *GradeTableMasterView;
    UITableView *GradeTable;
    UIToolbar *GradeTableToolBar;
    
    UIView *StudentStatusTableMasterView;
    UITableView *StudentStatusTable;
    UIToolbar *StudentStatusTableToolBar;
    
    UIView *DropTableMasterView;
    UITableView *DropTable;
    UIToolbar *DropTableToolBar;
    
    __weak IBOutlet UIView *ProductTableMasterView;
    __weak IBOutlet UITableView *ProductTable;
    __weak IBOutlet UISearchBar *productsearchbar;
    __weak IBOutlet UILabel *producttitle;
    __weak IBOutlet UIButton *productresetotanybutton;
    
    __weak IBOutlet UIView *PaymentStatusTableMasterView;
    __weak IBOutlet UITableView *PaymentStatusTable;
    __weak IBOutlet UILabel *paymentstatustitle;
    __weak IBOutlet UIButton *paymentstatusresettoanybutton;
    
    
    NSMutableArray *allsubjectarray;
    NSMutableArray *filteredsubjectarray;
    NSMutableArray *allinstructorarray;
    NSMutableArray *filteredinstructorarray;
    NSMutableArray *gradearray;
    NSMutableArray *studentstatusarray;
    NSMutableArray *droparray;
    NSMutableArray *allproductarray;
    NSMutableArray *filteredproductarray;
    NSMutableArray *paymentstatusarray;
    
    BOOL keyboardshow;
    float keyboardheight;
    
    NSMutableArray *recipientRowDataArray;
    
    UIBarButtonItem *yearButton;
}

@property (weak,nonatomic)id <myAdvancedSearchPopoverViewControllerDelegate>delegate;
- (IBAction)closesidewindow:(id)sender;
- (IBAction)product_resettoanybuttonpressed:(id)sender;
- (IBAction)paymentstatus_resettoanybuttonpressed:(id)sender;

@end


