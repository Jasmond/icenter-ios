//
//  LeftMenuViewController.h
//  ischoolistaff
//
//  Created by Jasmond Luk on 11/5/2016.
//  Copyright © 2016 Dreamware Limited. All rights reserved.
//

#import "AMSlideMenuLeftTableViewController.h"
#import "MyObject.h"
#import "MyClass.h"

@interface LeftMenuViewController : AMSlideMenuLeftTableViewController
{
    
    GlobalVariables *globalvariables;
    UIImageView *menuimage;
    
    UILabel *menuitemlabel;
    UIImageView *menuitemimage;
    NSArray *menuimageArray;
    UILabel *datelabel;
    
    NSDateFormatter *df;
}

@property (nonatomic,strong) NSArray *menuArray;

@end