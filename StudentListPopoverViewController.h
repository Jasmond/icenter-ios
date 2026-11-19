//
//  StudentListPopoverViewController.h
//  ischoolicenter
//
//  Created by Jasmond Luk on 30/7/2016.
//  Copyright © 2016 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "MyClass.h"

@protocol myStudentListPopoverViewControllerDelegate <NSObject>

-(void) donesibling:(SiblingRecord *)siblingrecord;

@end

@interface StudentListPopoverViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIScrollViewDelegate>
{
    GlobalVariables *globalvariables;
    NSDateFormatter *df;
    

    
    NSMutableArray *StudentArray;
    NSMutableArray *FilteredStudentArray;
    
    UITableView *StudentListTable;
    UILabel *StudentNameLabel;
    UILabel *StudentSchoolLabel;
    UILabel *StudentIDLabel;
    UIImageView *studentimage;

    
    UILabel *RelationshipLabel;
    
    Student *studentobject;

    

    UIButton *cancelbutton;
    
    UITableView *RelationshipTable;
    
    UISearchBar *studentsearchbar;
    
    NSArray *RelationshipArray;
    
    NSMutableArray *jsonArray;
    
    NSString *imagelastupdatetime;
    
    NSMutableArray *usersiblingarray;
}

@property (nonatomic,weak) id<myStudentListPopoverViewControllerDelegate>delegate;
@property (nonatomic,strong) SiblingRecord *siblingrecord;
@property (nonatomic,strong) NSString *selfstudentkey;

@end
