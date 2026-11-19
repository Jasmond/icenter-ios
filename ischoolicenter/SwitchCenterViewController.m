//
//  SwitchCenterViewController.m
//  ischoolicenter
//
//  Created by Jasmond Luk on 1/6/2016.
//  Copyright © 2016 DreamHigh Company Limited. All rights reserved.
//

#import "SwitchCenterViewController.h"

#define screenwidth 610
#define screenheight 458

@implementation SwitchCenterViewController
@synthesize singleselection,updatecenterkey,sourceview,showcancelbutton;

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor systemGroupedBackgroundColor];
    self.preferredContentSize=CGSizeMake(610, 458);
    
    globalvariables=[GlobalVariables singleObj];
    df=[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    //centerimageCache=[[NSCache alloc]init];
    
    
    donebutton =[[UIButton alloc]initWithFrame:CGRectMake(screenwidth-100-20,15,100,44)];
    [donebutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    donebutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    donebutton.titleLabel.font=[UIFont systemFontOfSize:18];
    [donebutton addTarget: self action:@selector(switchcenterdonebuttonpressed) forControlEvents: UIControlEventTouchUpInside];
    
    selectbutton =[[UIButton alloc]initWithFrame:CGRectMake(110,15,screenwidth-240,44)];
    [selectbutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    selectbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    selectbutton.titleLabel.font=[UIFont systemFontOfSize:18];
    [selectbutton addTarget: self action:@selector(selectbuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    
    cancelbutton =[[UIButton alloc]initWithFrame:CGRectMake(20,15,100,44)];
    [cancelbutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    cancelbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cancelbutton.titleLabel.font=[UIFont systemFontOfSize:18];
    [cancelbutton addTarget: self action:@selector(switchcentercancelbuttonpressed) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:donebutton];
    [self.view addSubview:cancelbutton];
    [self.view addSubview:selectbutton];
    
//    centerselectiontable=[[UITableView alloc]initWithFrame:CGRectMake(20, 60, screenwidth-40,screenheight-80) style:UITableViewStylePlain];
//    centerselectiontable.delegate=self;
//    centerselectiontable.dataSource=self;
//    [self.view addSubview:centerselectiontable];
    centersearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];

}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    centersearchbar.text=@"";
    if ([globalvariables.centerrecord.centerkey isEqualToString:@""]) {
        if ([showcancelbutton isEqualToString:@"Yes"]) {
            cancelbutton.hidden=NO;
        }else{
            cancelbutton.hidden=YES;
        }
    }else{
        cancelbutton.hidden=NO;
    }
    
    
    if (sourceview) {
        CenterArray=[[NSMutableArray alloc]initWithArray:[self returnarraywithview:sourceview]];
        FilteredCenterArray=[[NSMutableArray alloc]initWithArray:CenterArray];
    }else{
        CenterArray=[[NSMutableArray alloc]initWithArray:[MyClass returnSortedCenterArraybyCenterName]];
        FilteredCenterArray=[[NSMutableArray alloc]initWithArray:CenterArray];
    }
    
    [donebutton setTitle:[self returnswitchtitlewithtitle:@"Done"] forState:UIControlStateNormal];
    [cancelbutton setTitle:[self returnswitchtitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
    
    if ([singleselection isEqualToString:@"Yes"]) {
        if ([MyClass MultiCenterDidSelect]) {
            CenterSelectionArray=[[NSMutableArray alloc]init];
        }else{
            if ([globalvariables.centerrecord.centerkey isEqualToString:@""]) {
                CenterSelectionArray=[[NSMutableArray alloc]init];
            }else{
                CenterSelectionArray=[[NSMutableArray alloc]initWithArray:[globalvariables.centerrecord.centerkey componentsSeparatedByString:@","]];
            }
        }
        [selectbutton setTitle:[self returnswitchtitlewithtitle:@"Select One"] forState:UIControlStateNormal];
        selectbutton.userInteractionEnabled=NO;
    }else{
        if ([globalvariables.centerrecord.centerkey isEqualToString:@""]) {
            CenterSelectionArray=[[NSMutableArray alloc]init];
        }else{
            CenterSelectionArray=[[NSMutableArray alloc]initWithArray:[globalvariables.centerrecord.centerkey componentsSeparatedByString:@","]];
        }

        [selectbutton setTitle:[self returnswitchtitlewithtitle:(CenterSelectionArray.count<FilteredCenterArray.count)?@"Select all":@"Deselect all"] forState:UIControlStateNormal];
        selectbutton.userInteractionEnabled=YES;
    }
    [centerselectiontable reloadData];
    

    [centerselectiontable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self indexofcenterincenterarraywithcenterkey:globalvariables.centerrecord.centerkey] inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    
}

-(int) indexofcenterincenterarraywithcenterkey:(NSString *)centerkey
{
    for (int i=0; i<FilteredCenterArray.count; i++) {
        if ([((CenterRecord *)[FilteredCenterArray objectAtIndex:i]).centerkey isEqualToString:centerkey]) {
            return i;
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return FilteredCenterArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    //add switch, label and button
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        centername_list=[[UILabel alloc]initWithFrame:CGRectMake(55, 1, centerselectiontable.frame.size.width-50-55, 30)];
        centername_list.font=[UIFont systemFontOfSize:14];
        centername_list.textColor=[UIColor darkGrayColor];
        centername_list.adjustsFontSizeToFitWidth=YES;
        centername_list.minimumScaleFactor=0.5;
        centername_list.tag=200;
        [cell.contentView addSubview:centername_list];

        centeraddress_list=[[UILabel alloc]initWithFrame:CGRectMake(55, 22, centerselectiontable.frame.size.width-50-55, 18)];
        centeraddress_list.font=[UIFont systemFontOfSize:10];
        centeraddress_list.textColor=[UIColor grayColor];
        centeraddress_list.adjustsFontSizeToFitWidth=YES;
        centeraddress_list.minimumScaleFactor=0.5;
        centeraddress_list.tag=203;
        [cell.contentView addSubview:centeraddress_list];
        
        centerimage_list=[[UIImageView alloc]initWithFrame:CGRectMake(10, (44-38*768/1024)/2, 38, 38*768/1024)];
        centerimage_list.layer.cornerRadius=3;
        centerimage_list.layer.masksToBounds=YES;
        centerimage_list.clipsToBounds=YES;
        centerimage_list.contentMode=UIViewContentModeScaleAspectFill;
        centerimage_list.backgroundColor=[UIColor lightGrayColor];
        centerimage_list.tag=201;
        [cell.contentView addSubview:centerimage_list];
        
        checkimage_list=[[UIImageView alloc]initWithFrame:CGRectMake(centerselectiontable.frame.size.width-40, 9, 26, 26)];
        [checkimage_list setImage:[UIImage imageNamed:@"checked_icon.png"]];
        checkimage_list.tag=202;
        [cell.contentView addSubview:checkimage_list];
    }else{
        centername_list=(UILabel *)[cell.contentView viewWithTag:200];
        centerimage_list=(UIImageView *)[cell.contentView viewWithTag:201];
        checkimage_list=(UIImageView *)[cell.contentView viewWithTag:202];
        centeraddress_list=(UILabel *)[cell.contentView viewWithTag:203];
    }
    
    centerobject=[FilteredCenterArray objectAtIndex:indexPath.row];
    centername_list.text=[MyClass returncentershortnamewithcenterkey:centerobject.centerkey];
    centeraddress_list.text=[globalvariables.language isEqualToString:@"English"]?centerobject.centeraddress:centerobject.centeraddress_chinese;
    
    if (![centerobject.centercontact isEqualToString:@""]) {
        if ([centeraddress_list.text isEqualToString:@""]) {
            centeraddress_list.text=centerobject.centercontact;
        }else{
            centeraddress_list.text=[NSString stringWithFormat:@"%@ / %@",centeraddress_list.text,centerobject.centercontact];
        }
    }
    
    if ([CenterSelectionArray containsObject:centerobject.centerkey]) {
        checkimage_list.layer.opacity=1;
    }else{
        checkimage_list.layer.opacity=0.3;
    }
    
    [MyClass downloadImageWithImageview:centerimage_list gender:nil type:@"centerimage" typekey:centerobject.launchimage_landscape image:@"Yes" async:YES];
    
    
    cell.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([singleselection isEqualToString:@"Yes"]) {
        CenterSelectionArray=[[NSMutableArray alloc]initWithObjects:((CenterRecord *)[FilteredCenterArray objectAtIndex:indexPath.row]).centerkey, nil];
    }else{
        if ([CenterSelectionArray containsObject:((CenterRecord *)[FilteredCenterArray objectAtIndex:indexPath.row]).centerkey]) {
            [CenterSelectionArray removeObject:((CenterRecord *)[FilteredCenterArray objectAtIndex:indexPath.row]).centerkey];
        }else{
            [CenterSelectionArray addObject:((CenterRecord *)[FilteredCenterArray objectAtIndex:indexPath.row]).centerkey];
        }
        [selectbutton setTitle:[self returnswitchtitlewithtitle:(CenterSelectionArray.count<FilteredCenterArray.count)?@"Select all":@"Deselect all"] forState:UIControlStateNormal];
    }
    
    [centerselectiontable reloadData];
}

-(NSString *) returnswitchtitlewithtitle:(NSString *)title
{
    if (((CenterRecord *)[MyClass returncenterrecordwithcenterkey:globalvariables.centerrecord.centerkey]).centerkey) {
        if (globalvariables.languagetitledictionary.count>0) {
            return [MyClass returntitlewithtitle:title];
        }else{
            return [MyClass returnlogintitlewithtitle:title];
        }
    }else{
        return [MyClass returnlogintitlewithtitle:title];
    }
}



-(void) selectbuttonpressed:(UIButton *)sender
{
    if (CenterSelectionArray.count<FilteredCenterArray.count ) {
        //select all
        [sender setTitle:[self returnswitchtitlewithtitle:@"Deselect all"] forState:UIControlStateNormal];
        CenterSelectionArray=[[NSMutableArray alloc]initWithArray:[MyClass returnallcentercenterkey]];
        
    }else{
        //deselect all
        [sender setTitle:[self returnswitchtitlewithtitle:@"Select all"] forState:UIControlStateNormal];
        CenterSelectionArray=[[NSMutableArray alloc]init];
    }
    [centerselectiontable reloadData];
}

-(void) switchcenterdonebuttonpressed
{
    
    //self.preferredContentSize=CGSizeMake(700, 20);
    
    
    if (CenterSelectionArray.count==0) {
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[self returnswitchtitlewithtitle:@"Select Center"] message:[self returnswitchtitlewithtitle:@"Please select center"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[self returnswitchtitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else{
        if ([singleselection isEqualToString:@"Yes"]) {
            [self dismissViewControllerAnimated:YES completion:nil];
            if ([self centerswitched]) {
                if ([updatecenterkey isEqualToString:@"Yes"]) {
                    globalvariables.centerrecord=[MyClass returncenterrecordwithcenterselectionarray:CenterSelectionArray];
                    
                    [MyClass clearLocalDataUponSwitch];
//                    globalvariables.documentfolder.classinvoicearray=[[NSMutableArray alloc]init];
//                    globalvariables.documentfolder.classreceiptarray=[[NSMutableArray alloc]init];
//                    globalvariables.documentfolder.salesinvoicearray=[[NSMutableArray alloc]init];
//                    globalvariables.documentfolder.salesreceiptarray=[[NSMutableArray alloc]init];
                }
                
                [self.delegate doneswitchcenterwithreload:YES centerkey:[CenterSelectionArray firstObject] centerimage:nil];
            }
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
            if ([self centerswitched]) {
                globalvariables.centerrecord=[MyClass returncenterrecordwithcenterselectionarray:CenterSelectionArray];

                globalvariables.documentfolder.classinvoicearray=[[NSMutableArray alloc]init];
                globalvariables.documentfolder.classreceiptarray=[[NSMutableArray alloc]init];
                globalvariables.documentfolder.salesinvoicearray=[[NSMutableArray alloc]init];
                globalvariables.documentfolder.salesreceiptarray=[[NSMutableArray alloc]init];
                
                [self.delegate doneswitchcenterwithreload:YES centerkey:globalvariables.centerrecord.centerkey centerimage:nil];
            }
        }
    }
}


-(void)switchcentercancelbuttonpressed
{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(BOOL) centerswitched
{
    NSMutableArray *currentcenterselectionarray=[[NSMutableArray alloc]initWithArray:[globalvariables.centerrecord.centerkey componentsSeparatedByString:@","]];
    NSMutableArray *newcenterselectionarray=[[NSMutableArray alloc]initWithArray:CenterSelectionArray];
    
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: YES];
    
    currentcenterselectionarray=[NSMutableArray arrayWithArray:[currentcenterselectionarray sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]]];
    newcenterselectionarray=[NSMutableArray arrayWithArray:[newcenterselectionarray sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]]];
    
    if ([currentcenterselectionarray isEqualToArray:newcenterselectionarray]) {
        return NO;
    }else{
        return YES;
    }
    
}

//-(NSMutableArray *) returnarraywithview:(NSString *)source_view
//{
//    NSMutableArray * resultarray=[[NSMutableArray alloc]init];
//    
//    if ([source_view isEqualToString:@"classphoto"]) {
//        for (int i=0; i<globalvariables.CenterArray.count; i++) {
//            if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:((CenterRecord *)[globalvariables.CenterArray objectAtIndex:i]).centerkey]).viewclassphoto) {
//                [resultarray addObject:[globalvariables.CenterArray objectAtIndex:i]];
//            }
//        }
//    }else if ([source_view isEqualToString:@"taskassignment"]) {
//        for (int i=0; i<globalvariables.CenterArray.count; i++) {
//            if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:((CenterRecord *)[globalvariables.CenterArray objectAtIndex:i]).centerkey]).viewtaskassignment) {
//                [resultarray addObject:[globalvariables.CenterArray objectAtIndex:i]];
//            }
//        }
//    }
//    
//    return resultarray;
//}

-(NSMutableArray *) returnarraywithview:(NSString *)source_view
{
    NSMutableArray *resultarray = [[NSMutableArray alloc] init];
    
    if ([source_view isEqualToString:@"classphoto"]) {
        for (CenterRecord *centerRecord in globalvariables.CenterDict.allValues) {
            PrivilegeRecord *privilege = [MyClass returnprivilegerecordwithcenterkey:centerRecord.centerkey];
            if (privilege && privilege.viewclassphoto) {
                [resultarray addObject:centerRecord];
            }
        }
    } else if ([source_view isEqualToString:@"taskassignment"]) {
        for (CenterRecord *centerRecord in globalvariables.CenterDict.allValues) {
            PrivilegeRecord *privilege = [MyClass returnprivilegerecordwithcenterkey:centerRecord.centerkey];
            if (privilege && privilege.viewtaskassignment) {
                [resultarray addObject:centerRecord];
            }
        }
    }
    
    return resultarray;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar==centersearchbar) {
        [self returnfiltercenterarray];
        [centerselectiontable setContentOffset:CGPointZero animated:YES];
    }
}

-(void) returnfiltercenterarray
{
    //NSMutableArray *result;
    
    
    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];
    

    if (![centersearchbar.text isEqualToString:@""]) {
        
        newCondition = [NSPredicate predicateWithBlock:^BOOL(CenterRecord *object, NSDictionary *bindings) {

            return [object.centername rangeOfString:centersearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.centerkey rangeOfString:centersearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.centershortname_chinese rangeOfString:centersearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.centershortname_english rangeOfString:centersearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.centeraddress rangeOfString:centersearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.centeraddress_chinese rangeOfString:centersearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.sidprefix rangeOfString:centersearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound
            ;
        }];
        [nsPredicatearray addObject:newCondition];
        
    }
    
    
    if (nsPredicatearray.count>0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
        FilteredCenterArray= [[NSMutableArray alloc]initWithArray:[CenterArray filteredArrayUsingPredicate:predicate]];
    }else{
        FilteredCenterArray= [[NSMutableArray alloc]initWithArray:CenterArray];
    }
    
//    FilteredCenterArray=[NSMutableArray arrayWithArray:[FilteredCenterArray sortedArrayUsingDescriptors:sortDescriptorsArray]];
    
    [centerselectiontable reloadData];

}

@end

