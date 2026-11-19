//
//  LeadImageGridViewController.h
//  EyeEnroll
//
//  Created by Jasmond Luk on 18/5/15.
//  Copyright (c) 2015 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"

@protocol myLeadImageGridViewControllerDelegate <NSObject>

-(void) dismissleadgridview;
-(void) passleadfromgrid:(NSString *)leadkey;
-(void) passleadarrayfromgrid:(NSMutableArray *)leadarray;

@end

@interface LeadImageGridViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>
{
    
    GlobalVariables *globalvariables;
    IBOutlet UILabel *viewtitle;
    
    IBOutlet UICollectionView *leadphotocollection;
    
    
    UILabel *LeadNameLabel;
    Lead *leadobject;
    
    
    NSDateFormatter *df;
    
    IBOutlet UIButton *title_CancelButton;
    IBOutlet UIButton *title_DoneButton;
    
    //NSMutableArray *checkimagearray;
    
    UISearchBar *leadsearchbar;
    
    NSMutableArray *filteredLeadArray;
    ClassValidateRecord *photoalbumobject;
    
}
@property (nonatomic,weak)id<myLeadImageGridViewControllerDelegate>delegate;
@property (nonatomic,strong) NSMutableArray *leadArray;
@property (nonatomic,strong) NSString *leadcategory;
@property (nonatomic,strong) NSString *source;
@property (nonatomic,strong) NSString *mode;
@property (nonatomic,strong) NSMutableArray *tmpcallingkey;

- (IBAction)cancelbuttonpressed:(id)sender;
- (IBAction)donebuttonpressed:(id)sender;

@end
