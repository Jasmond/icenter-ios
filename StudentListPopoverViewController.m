//
//  StudentListPopoverViewController.m
//  ischoolicenter
//
//  Created by Jasmond Luk on 30/7/2016.
//  Copyright © 2016 DreamHigh Company Limited. All rights reserved.
//

#import "StudentListPopoverViewController.h"

#define screenwidth 500
#define screenheight 458

@interface StudentListPopoverViewController ()

@end

@implementation StudentListPopoverViewController
@synthesize siblingrecord,selfstudentkey;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor systemGroupedBackgroundColor];
    
    globalvariables=[GlobalVariables singleObj];
    df=[[NSDateFormatter alloc]init];
    df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    

    
    RelationshipArray=[[NSArray alloc]initWithObjects:@"Brothers",@"Sisters",@"Brother and sister",@"Sister and brother",@"Cousins",@"Friends",@"Classmates",@"Mother and daughter",@"Mother and son",@"Others",nil];
    
    cancelbutton =[[UIButton alloc]initWithFrame:CGRectMake(20,15,100,44)];
    [cancelbutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    cancelbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cancelbutton.titleLabel.font=[UIFont systemFontOfSize:18];
    [cancelbutton addTarget: self action:@selector(cancelbuttonpressed) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:cancelbutton];
    
    StudentListTable=[[UITableView alloc]initWithFrame:CGRectMake(20, 60+44, screenwidth-40,screenheight-80-44) style:UITableViewStylePlain];
    StudentListTable.delegate=self;
    StudentListTable.dataSource=self;
    [self.view addSubview:StudentListTable];


    studentsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(20, 60, screenwidth-40,44)];
    studentsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    studentsearchbar.delegate=self;
    [self.view addSubview:studentsearchbar];
    
    RelationshipTable=[[UITableView alloc]initWithFrame:CGRectMake(screenwidth, 60+44, 200,screenheight-80-44) style:UITableViewStylePlain];
    RelationshipTable.delegate=self;
    RelationshipTable.dataSource=self;
    RelationshipTable.scrollEnabled=FALSE;
    [self.view addSubview:RelationshipTable];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    studentsearchbar.text=@"";
    [self retrieveData];
    usersiblingarray=[[NSMutableArray alloc]init];
    
    [cancelbutton setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
    
}



-(BOOL) retrieveData
{
    [MyClass getLatestDataSetv2withParameters:@"student" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
    long selectedstudentrow=-1;
        
    StudentArray=[[NSMutableArray alloc]initWithArray:[globalvariables.studentlistarray allValues]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.centerkey = %@ and self.studentkey !=%@",globalvariables.centerrecord.centerkey,selfstudentkey];
    StudentArray=[[NSMutableArray alloc]initWithArray:[StudentArray filteredArrayUsingPredicate:predicate]];
    //StudentArray = [NSMutableArray arrayWithArray:[StudentArray sortedArrayUsingDescriptors:[MyClass returnstudentnamesortdescriptorarray]]];
    
        [self filteredarraywithsearchtext:studentsearchbar.text];
        
        //Reload our student view
        [StudentListTable reloadData];
    
    
        if (siblingrecord && selectedstudentrow<0) {
            for (int i=0; i<FilteredStudentArray.count; i++) {
                if ([siblingrecord.studentkey isEqualToString:((Student *)[FilteredStudentArray objectAtIndex:i]).studentkey]) {
                    selectedstudentrow=i;
                }
            }
        }
        
        if (selectedstudentrow>=0) {
            [StudentListTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedstudentrow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            [StudentListTable.delegate tableView:StudentListTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedstudentrow inSection:0]];
            [RelationshipTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:[RelationshipArray indexOfObject:siblingrecord.relationship] inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        }else{
            if (FilteredStudentArray.count>0) {
                [StudentListTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
        
        return YES;
    /*}else{
        return NO;
    }*/
}

-(void) filteredarraywithsearchtext:(NSString *)searchtext
{
    if (!searchtext || [searchtext isEqualToString:@""]) {
        FilteredStudentArray= [NSMutableArray arrayWithArray:StudentArray];
    }else{
        //[filteredStudentArray removeAllObjects];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.othername contains[c] %@ or SELF.firstname contains[c] %@ or self.lastname contains[c] %@ or any phonearray.contact contains[c] %@ or self.studentid contains[c] %@ or self.remarks contains[c] %@ or self.grade contains[c] %@ or self.school contains[c] %@ or self.parentaddress contains[c] %@ or self.parentemail contains[c] %@",searchtext,searchtext,searchtext,searchtext,searchtext,searchtext,searchtext,searchtext,searchtext,searchtext];
        FilteredStudentArray= [NSMutableArray arrayWithArray:[StudentArray filteredArrayUsingPredicate:predicate]];
    }
    [self sortstudentlist];
    
}

-(void) sortstudentlist
{
    FilteredStudentArray = [NSMutableArray arrayWithArray:[FilteredStudentArray sortedArrayUsingDescriptors:[MyClass returnstudentnamesortdescriptorarray]]];
    
    if (!siblingrecord && selfstudentkey && ![selfstudentkey isEqualToString:@""]) {
        [FilteredStudentArray insertObject:[[Student alloc]initStudentWithstudentkey:@"999999999" studentid:@"" firstname:@"Add New Sibling Student" lastname:@"" othername:@"" gender:@"Male" dateofbirth:nil age:nil grade:nil preferredlanguage:nil school:@"" parentname:nil phonearray:nil parentemail:nil parentaddress:nil remarks:nil flag:nil status:nil promotion:nil image:@"Yes" leadkey:nil studentmedia:nil studentsource:nil siblingarray:nil photoalbumrecord:nil centerkey:nil due:nil avatar:nil sendmessage:YES displayfullname:nil fcmemberid:@"" ddaenabled:NO ddaaccountno:@"" ddaaccountname:@"" ddadebtorreference:@"" ddalimit:@"" extrafield1:@"" parentname2:@"" validcouponcount:nil extrafield2:nil creditamount:0] atIndex:0];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self filteredarraywithsearchtext:searchText];
    [StudentListTable reloadData];
    [StudentListTable setContentOffset:CGPointZero animated:YES];
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    //do stuff
    
    [UIView animateWithDuration:0.3 animations:^{
        RelationshipTable.frame=CGRectMake(screenwidth,60+44, 200,screenheight-80-44);
    } completion:nil];
    
    return YES;
}






- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView==StudentListTable) {
        return 1;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView==StudentListTable) {
        return [FilteredStudentArray count];
    }else{
        return [RelationshipArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    if (tableView==StudentListTable) {
        static NSString *CellIdentifier = @"Cell";
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            StudentNameLabel = [[UILabel alloc]init] ;//WithFrame:CGRectMake(47, 0, 168, 30)];
            StudentNameLabel.font=[UIFont systemFontOfSize:13];
            StudentNameLabel.numberOfLines=0;
            StudentNameLabel.adjustsFontSizeToFitWidth=YES;
            StudentNameLabel.minimumScaleFactor=0.7;
            StudentNameLabel.tag=101;
            [cell.contentView addSubview:StudentNameLabel];
            
            studentimage=[[UIImageView alloc]initWithFrame:CGRectMake(6, 2, 46*154/180, 46)];
            studentimage.layer.cornerRadius=5;
            studentimage.tag=102;
            studentimage.layer.masksToBounds=YES;
            [cell.contentView addSubview:studentimage];
            
            StudentIDLabel = [[UILabel alloc]initWithFrame:CGRectMake(49, 34, 120, 12)];
            StudentIDLabel.font=[UIFont systemFontOfSize:10];
            StudentIDLabel.textColor=[UIColor grayColor];
            StudentIDLabel.adjustsFontSizeToFitWidth=YES;
            StudentIDLabel.minimumScaleFactor=0.7;
            StudentIDLabel.tag=103;
            [cell.contentView addSubview:StudentIDLabel];

            StudentSchoolLabel = [[UILabel alloc]initWithFrame:CGRectMake(175, 34, StudentListTable.frame.size.width-175-10, 12)];
            StudentSchoolLabel.font=[UIFont systemFontOfSize:10];
            StudentSchoolLabel.textColor=[UIColor grayColor];
            StudentSchoolLabel.adjustsFontSizeToFitWidth=YES;
            StudentSchoolLabel.textAlignment=NSTextAlignmentRight;
            StudentSchoolLabel.minimumScaleFactor=0.7;
            StudentSchoolLabel.tag=104;
            [cell.contentView addSubview:StudentSchoolLabel];
            
            
        }else{
            StudentNameLabel=(UILabel *)[cell.contentView viewWithTag:101];
            studentimage=(UIImageView *)[cell.contentView viewWithTag:102];
            StudentIDLabel=(UILabel *)[cell.contentView viewWithTag:103];
            StudentSchoolLabel=(UILabel *)[cell.contentView viewWithTag:104];
        }
        
        
        // Configure the cell...
        
        Student * studentObject;
        studentObject = [FilteredStudentArray objectAtIndex:indexPath.row];
        
        StudentIDLabel.text=studentObject.studentid;
        
        if ([studentObject.studentkey isEqualToString:@"999999999"]) {
            StudentNameLabel.text=[MyClass returntitlewithtitle:studentObject.firstname];
        }else{
            StudentNameLabel.text=[MyClass returnStudentnameWithStudentkey:studentObject.studentkey option:@"fullbutid"];//[MyClass returnfullnamewithfirstname:studentObject.firstname
        }

        StudentSchoolLabel.text=studentObject.school;
        
        if ([studentObject.studentid isEqualToString:@""]) {
            StudentNameLabel.frame=CGRectMake(49, 2, 200, 46);
            StudentSchoolLabel.frame=CGRectMake(175, 0, StudentListTable.frame.size.width-175-10, 46);
        }else{
            StudentNameLabel.frame=CGRectMake(49, 2, 200, 50);
            [StudentNameLabel sizeToFit];
            
            if (StudentNameLabel.frame.size.height>46-12-3) {
                StudentNameLabel.frame=CGRectMake(49, 2, StudentNameLabel.frame.size.width, 46-12-3);
            }else{
                StudentNameLabel.frame=CGRectMake(49, (50-StudentNameLabel.frame.size.height-3-12)/2, 200, StudentNameLabel.frame.size.height);
            }
            
            StudentIDLabel.frame=CGRectMake(49, StudentNameLabel.frame.origin.y+StudentNameLabel.frame.size.height+3, 200, 12);
            StudentSchoolLabel.frame=CGRectMake(175, StudentIDLabel.frame.origin.y, StudentListTable.frame.size.width-175-10, 12);
        }
        
        [MyClass downloadImageWithImageview:studentimage gender:studentObject.gender type:@"student" typekey:studentObject.studentkey image:studentObject.image async:YES];

        return cell;
        
    }else{
        static NSString *CellIdentifier = @"Cell";
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            RelationshipLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 168, 50)];
            RelationshipLabel.font=[UIFont systemFontOfSize:13];
            RelationshipLabel.numberOfLines=0;
            RelationshipLabel.adjustsFontSizeToFitWidth=YES;
            RelationshipLabel.minimumScaleFactor=0.7;
            RelationshipLabel.tag=201;
            [cell.contentView addSubview:RelationshipLabel];
        }else{
            RelationshipLabel=(UILabel *)[cell.contentView viewWithTag:201];
        }
        
        RelationshipLabel.text=[MyClass returntitlewithtitle:[RelationshipArray objectAtIndex:indexPath.row]];
        
        cell.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.4];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==StudentListTable) {
        return 50;
    }else{
        return 48;
    }
}



-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView==StudentListTable) {
        [UIView animateWithDuration:0.3 animations:^{
            RelationshipTable.frame=CGRectMake(screenwidth,60+44, 200,screenheight-80-44);
        } completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==StudentListTable){
        [self.view endEditing:YES];
        [RelationshipTable reloadData];
        [UIView animateWithDuration:0.3 animations:^{
            RelationshipTable.frame=CGRectMake(screenwidth-20-RelationshipTable.frame.size.width,60+44, 200,screenheight-80-44);
        } completion:nil];
        studentobject=[FilteredStudentArray objectAtIndex:indexPath.row];
    }else if (tableView==RelationshipTable){
        [UIView animateWithDuration:0.3 animations:^{
            RelationshipTable.frame=CGRectMake(screenwidth,60+44, 200,screenheight-80-44);
        } completion:^(BOOL finished) {
            [self.delegate donesibling:[[SiblingRecord alloc]initSiblingRecordwithStudentname:[MyClass returnStudentnameWithStudentkey:studentobject.studentkey option:@"full"] Studentkey:studentobject.studentkey Relationship:[RelationshipArray objectAtIndex:indexPath.row]]];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

-(void) cancelbuttonpressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
