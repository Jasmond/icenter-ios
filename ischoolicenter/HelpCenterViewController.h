//
//  HelpCenterViewController.h
//  iCenter
//
//  Created by Jasmond Luk on 14/3/2022.
//  Copyright © 2022 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyClass.h"
#import "MyObject.h"
#import "MainViewController.h"
#import "FullScreenPhotoViewController.h"

@interface HelpCenterViewController : UIViewController<myFullScreenPhotoViewControllerDelegate>
{
    GlobalVariables *globalvariables;
    __weak IBOutlet UITableView *categoryTable;
    __weak IBOutlet UITableView *itemTable;
 
    UIView *headertitleview;
    UILabel *headertitlename;
    
    NSMutableArray *categoryArray;
    NSArray *alphabetArray;
    
    NSInteger selectedCategoryRow;
    
    FullScreenPhotoViewController *fullscreenphotoviewcontroller;
    
    BOOL runviewdidappear;
}

- (IBAction)menubutton:(id)sender;

@end


