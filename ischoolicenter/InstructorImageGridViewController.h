//
//  InstructorImageGridViewController.h
//  EyeEnroll
//
//  Created by Jasmond Luk on 28/10/2015.
//  Copyright © 2015 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"

@protocol myInstructorImageGridViewControllerDelegate <NSObject>

-(void) dismissinstructorgridview;
-(void) passinstructorfromgrid:(NSString *)username;
-(void) passinstructorlistfromgrid:(NSString *)instructorlist;

@end

@interface InstructorImageGridViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>
{
    
    GlobalVariables *globalvariables;
    //    sqlite3 *isdb;
    
    IBOutlet UILabel *viewtitle;
    
    IBOutlet UICollectionView *instructorphotocollection;
    
    
    UILabel *InstructorNameLabel;

    
    Instructor *instructorobject;
    
    
    NSDateFormatter *df;
    
    IBOutlet UIButton *title_CancelButton;
    
    //NSMutableArray *checkimagearray;
    
    IBOutlet UIButton *title_DoneButton;
    
    UIButton *selectbutton;
    
    UISearchBar *instructorsearchbar;
    
    NSMutableArray *filteredInstructorArray;
    
    ClassValidateRecord *photoalbumobject;
    
}
@property (nonatomic,weak)id<myInstructorImageGridViewControllerDelegate>delegate;
@property (nonatomic,strong) NSMutableArray *instructorArray;
@property (nonatomic,strong) NSString *mode;
@property (nonatomic,strong) NSMutableArray *selectedinstructorarray;

- (IBAction)cancelbuttonpressed:(id)sender;
- (IBAction)savebuttonpressed:(id)sender;

@end
