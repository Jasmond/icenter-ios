//
//  SwitchCenterViewController.h
//  ischoolicenter
//
//  Created by Jasmond Luk on 1/6/2016.
//  Copyright © 2016 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "MyClass.h"

@protocol mySwitchCenterViewControllerDelegate <NSObject>

//-(void) cancelswitchcenter;
-(void) doneswitchcenterwithreload:(BOOL)reload centerkey:(NSString *)centerkey centerimage:(UIImage *)centerimage;

@end

@interface SwitchCenterViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    GlobalVariables *globalvariables;
    
    UIButton *selectbutton;
    NSMutableArray *CenterSelectionArray;
    
    
    __weak IBOutlet UITableView *centerselectiontable;
    UILabel *centername_list;
    UILabel *centeraddress_list;
    UIImageView *centerimage_list;
    UIImageView *checkimage_list;
    //NSCache *centerimageCache;
    
    CenterRecord *centerobject;
    
    //NSString *centerimagelastupdatetime;
    
    NSDateFormatter *df;
    
    UIImage *centerimage;
    
    UIButton *donebutton;
    UIButton *cancelbutton;
    
    NSMutableArray *CenterArray;
    NSMutableArray *FilteredCenterArray;
    
//    BOOL abc;
    __weak IBOutlet UISearchBar *centersearchbar;
    
}

@property (nonatomic,weak) id<mySwitchCenterViewControllerDelegate>delegate;
@property (nonatomic,strong) NSString *singleselection;
@property (nonatomic,strong) NSString *updatecenterkey;
@property (nonatomic,strong) NSString *sourceview;
@property (nonatomic) NSString *showcancelbutton;

@end
