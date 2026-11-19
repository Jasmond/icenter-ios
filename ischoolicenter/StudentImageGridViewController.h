//
//  StudentImageGridViewController.h
//  EyeEnroll
//
//  Created by Jasmond Luk on 11/9/14.
//  Copyright (c) 2014 Dreamware Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "StudentGridCollectionViewCell.h"

@protocol myStudentImageGridViewControllerDelegate <NSObject>

-(void) dismissstudentgridviewwithreload:(BOOL)reload;
-(void) passstudentfromgrid:(NSString *)studentkey;
-(void) passstudentarrayfromgrid:(NSMutableArray *)studentarray;
-(void) refreshstudentimagegridpresentingview;

@end

@interface StudentImageGridViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,myStudentGridCollectionViewCellDelegate,UISearchBarDelegate>
{
    
    GlobalVariables *globalvariables;
//    sqlite3 *isdb;
    
    IBOutlet UILabel *viewtitle;
    
    IBOutlet UICollectionView *studentphotocollection;
    
    
    UILabel *StudentNameLabel;

    
    Student *studentobject;

    
    NSDateFormatter *df;

    IBOutlet UIButton *title_CancelButton;
    IBOutlet UIButton *title_DoneButton;
    //NSMutableArray *checkimagearray;
    //NSMutableArray *validateclassmessagearray;
    //NSMutableArray *validateclassstatusarray;
    ClassValidateRecord *photoalbumobject;
    
    
    UIPopoverPresentationController *myPopoverController;
    
    NSMutableArray *filteredStudentArray;
    __weak IBOutlet UISearchBar *studentsearchbar;
    
    NSString *tmpTotalDiscount;
    int noofroundoffdigit;
    __weak IBOutlet UIStackView *copydiscountstack;
    __weak IBOutlet UILabel *title_copydiscount;
    __weak IBOutlet UISwitch *swcopydiscount;
    

}
@property (nonatomic,weak)id<myStudentImageGridViewControllerDelegate>delegate;
@property (nonatomic,strong) NSMutableArray *studentArray;
@property (nonatomic,strong) NSString *studentcategory;
@property (nonatomic,strong) NSString *source;
@property (nonatomic,strong) NSString *mode;
@property (nonatomic,strong) EnrollmentRecord *enrollmentrecord;
@property (nonatomic,strong) SalesRecord *salesrecord;
@property (nonatomic,strong) NSMutableArray *classarray;
@property (nonatomic,strong) NSMutableArray *instructorarray;
@property (nonatomic,strong) NSMutableArray *subjectarray;
@property (nonatomic,strong) NSMutableArray *tmpcallingkey;
@property (nonatomic,strong) NSMutableArray *promotionarray;

- (IBAction)cancelbuttonpressed:(id)sender;
- (IBAction)savebuttonpressed:(id)sender;

@end
