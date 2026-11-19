//
//  StaffGroupViewController.m
//  iCenter
//
//  Created by Jasmond on 5/11/2019.
//  Copyright © 2019 DreamHigh Company Limited. All rights reserved.
//

#import "StaffGroupViewController.h"

@interface StaffGroupViewController ()

@end

#define groupactivecolor [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1]
#define groupinactivecolor [UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:1]
#define TABLE_VIEW_CELL_DEFAULT_ID @"cellIdentifier"

@implementation StaffGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    globalvariables=[GlobalVariables singleObj];
    // Do any additional setup after loading the view.
    self.preferredContentSize=CGSizeMake(860, 600);
    if (@available(iOS 13.0, *)) {
        self.modalInPresentation=TRUE;
    }
    
    selectedGroupNameRow=0;
    [self determinegroupcount];
    self.view.backgroundColor=[UIColor colorWithRed:165.0/255.0 green:188.0/255.0 blue:213.0/255.0 alpha:1.0];

    groupalertarray=[[NSArray alloc]initWithObjects:@"Makeup arrangement", @"Auto renewal failure", @"Online enrollment", @"online_payment", nil];
    [self retrieveGroup];
    [self retrieveStaffListwithflushcachedata:YES];

    titlelabel.text=[MyClass returntitlewithtitle:@"Staff Group Setup"];
    [groupbutton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [groupbutton setTitle:[MyClass returntitlewithtitle:@"Group"] forState:UIControlStateNormal];
    [groupbutton setBackgroundColor:groupactivecolor];
    [groupbutton addTarget:self action:@selector(groupbuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [memberbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [memberbutton setTitle:[MyClass returntitlewithtitle:@"Member"] forState:UIControlStateNormal];
    [memberbutton addTarget:self action:@selector(memberbuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [memberbutton setBackgroundColor:groupinactivecolor];
    
    [staff_groupnametable reloadData];
    [staff_groupdetailstable reloadData];
    
    [staff_groupnametable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    
    staff_membergroupview=[[UIScrollView alloc]initWithFrame:CGRectMake(staff_membertable.frame.size.width, staff_membertable.frame.origin.y+0.5, self.preferredContentSize.width-staff_membertable.frame.size.width, staff_membertable.frame.size.height-1)];
    [memberview addSubview:staff_membergroupview];
    
    float width=(staff_membergroupview.frame.size.width/GroupArray.count>100)?staff_membergroupview.frame.size.width/GroupArray.count:100;
    staff_membergrouptable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, GroupArray.count*width, staff_membertable.frame.size.height) style:UITableViewStylePlain];
    staff_membergrouptable.delegate=self;
    staff_membergrouptable.dataSource=self;
    [staff_membergroupview addSubview:staff_membergrouptable];
    if ([staff_membergrouptable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        staff_membergrouptable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
    staff_membergroupview.contentSize=CGSizeMake(staff_membergrouptable.frame.size.width, staff_membergroupview.frame.size.height);
    
    
    
    
    [closebutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [closebutton setTitle:[MyClass returntitlewithtitle:@"Close"] forState:UIControlStateNormal];
    closebutton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    closebutton.backgroundColor=[UIColor whiteColor];
    closebutton.layer.borderWidth=1;
    closebutton.layer.cornerRadius=4;
    closebutton.layer.masksToBounds=YES;
    closebutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    closebutton.titleLabel.font=[UIFont systemFontOfSize:18];
    //[closebutton addTarget: self action:@selector(group_closebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [closebutton addTarget: self action:@selector(privilege_buttonhighlightcolor:) forControlEvents: UIControlEventTouchDown];
    [closebutton addTarget: self action:@selector(privilege_buttonresetcolor:) forControlEvents: UIControlEventTouchCancel];
    [closebutton addTarget: self action:@selector(privilege_buttonresetcolor:) forControlEvents: UIControlEventTouchUpOutside];
    
    informationupdated=NO;
    
}

-(void) determinegroupcount
{
    Staff *staffobject;
    groupcountdictionary=[[NSMutableDictionary alloc]init];
    for (int i=0; i<allStaffArray.count; i++) {
        staffobject=[allStaffArray objectAtIndex:i];
        for (int j=0; j<staffobject.grouparray.count;j++) {
            NSString *count=[groupcountdictionary valueForKey:[staffobject.grouparray objectAtIndex:j]];
            if (!count) {
                [groupcountdictionary setValue:@"1" forKey:[staffobject.grouparray objectAtIndex:j]];
            }else{
                count=[NSString stringWithFormat:@"%i",[count intValue]+1];
                [groupcountdictionary removeObjectForKey:[staffobject.grouparray objectAtIndex:j]];
                [groupcountdictionary setValue:count forKey:[staffobject.grouparray objectAtIndex:j]];
            }
        }
    }
}


- (IBAction)addgroup:(id)sender {
    if (![self isgroupnamealreadyexistwithgroupname:((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).groupname groupkey:((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).groupkey]) {
        [self addGroupWithName:[self returnnewgroupname]];
        tableViewCellIdentifierCount++;
        tableViewCellIdentifier = [NSString stringWithFormat:@"%@%lu", TABLE_VIEW_CELL_DEFAULT_ID, (unsigned long)tableViewCellIdentifierCount];
        [staff_groupdetailstable reloadData];
    }else{
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Staff Group"] message:[MyClass returntitlewithtitle:@"Please use a different group name as it already exists"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }
}

- (IBAction)deletegroup:(id)sender {
    if ([groupcountdictionary valueForKey:((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).groupkey]) {
        UIAlertController *deletealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Staff Group"] message:[MyClass returntitlewithtitle:@"This group has some staff in it. Are you sure to delete?"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self deleteGroupWithGroupkey:((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).groupkey];
        }];
        
        UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [deletealert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [deletealert addAction:OKAction];
        [deletealert addAction:CancelAction];
        [self presentViewController:deletealert animated:YES completion:nil];
    }else{
        [self deleteGroupWithGroupkey:((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).groupkey];
    }
    
}


-(BOOL) isgroupnamealreadyexistwithgroupname:(NSString *)groupname groupkey:(NSString *)groupkey
{
    for (int i=0; i<GroupArray.count; i++) {
        if ([((GroupRecord *)[GroupArray objectAtIndex:i]).groupname caseInsensitiveCompare:groupname]==NSOrderedSame && ![((GroupRecord *)[GroupArray objectAtIndex:i]).groupkey isEqualToString:groupkey]) {
            return TRUE;
        }
    }
    return FALSE;
}

-(NSString *) returnnewgroupname
{
    NSMutableArray *newgrouparray=[[NSMutableArray alloc]init];
    for (int i=0; i<GroupArray.count; i++) {
        GroupRecord *groupobject=[GroupArray objectAtIndex:i];
        if ([groupobject.groupname length]>=9) {
            if ([groupobject.groupname length]>=9 && [[groupobject.groupname substringToIndex:9] isEqualToString:@"New Group"]) {
                [newgrouparray addObject:groupobject.groupname];
            }
        }
    }
    

        for (int i=1; i<1000; i++) {
            if (![newgrouparray containsObject:[NSString stringWithFormat:@"New Group %d",i]]) {
                return [NSString stringWithFormat:@"New Group %d",i];
            }
        }
    
    return @"New Group";
}

-(BOOL) deleteGroupWithGroupkey:(NSString *)groupkey
{

    //combine arrays
    NSDictionary *dictionary = @{@"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"groupkey" : groupkey,
                                 @"postaction" : @"deletegroup"
                                 };
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    /*
    NSData   *finalData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalvariables.generalphpfullpath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalData length]] forHTTPHeaderField:@"Content-Length"];
    [postRequest setHTTPBody:finalData];
    
    __block BOOL result=FALSE;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            result=TRUE;

            
        }
        //NSString *resString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    if (result) {
        [self retrieveGroup];
        
        if (GroupArray.count>0) {
            if (selectedGroupNameRow>GroupArray.count-1) {
                selectedGroupNameRow=GroupArray.count-1;
            }
            [staff_groupnametable reloadData];
            [staff_groupnametable selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedGroupNameRow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
            [staff_groupdetailstable reloadData];
        }
        informationupdated=YES;
    }
    
    return result;

}

-(BOOL) addGroupWithName:(NSString *)groupname
{

    //combine arrays
    NSDictionary *dictionary = @{@"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"groupname" : groupname,
                                 @"postaction" : @"addgroup"
                                 };
    
    __block BOOL result=FALSE;
    __block NSString *newgroupkey;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSMutableArray * JSONArray = jsonreturned[@"content"];
            newgroupkey=[[JSONArray objectAtIndex:0] objectForKey:@"groupkey"];
        }
    }];
    /*
    NSData   *finalData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalvariables.generalphpfullpath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalData length]] forHTTPHeaderField:@"Content-Length"];
    [postRequest setHTTPBody:finalData];
    
    __block BOOL result=FALSE;
    __block NSString *newgroupkey;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSString *resString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!error) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSMutableArray * JSONArray = jsonreturned[@"content"];
            newgroupkey=[[JSONArray objectAtIndex:0] objectForKey:@"groupkey"];
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    if (result) {
        [self retrieveGroup];
        selectedGroupNameRow=[self findgroupindexrowwithgroupkey:newgroupkey];
        
        [staff_groupnametable reloadData];
        [staff_groupnametable selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedGroupNameRow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
        informationupdated=YES;
    }
    
    return result;

}

-(BOOL) retrieveGroup
{
    GroupArray=[MyClass returnStaffGroupArrayIncludeAll:YES];
    //[self showprivilagegroupbutton];
    
    return GroupArray?YES:NO;
}

-(int) findgroupindexrowwithgroupkey:(NSString *)groupkey
{
    for (int i=0; i<GroupArray.count; i++) {
        if ([((GroupRecord *)[GroupArray objectAtIndex:i]).groupkey isEqualToString:groupkey]) {
            return i;
        }
    }
    return 0;
}

-(void) groupbuttonpressed
{
    [self determinegroupcount];
    [staff_groupnametable reloadData];
    groupview.hidden=NO;
    memberview.hidden=YES;
    [groupbutton setBackgroundColor:groupactivecolor];
    [memberbutton setBackgroundColor:groupinactivecolor];
    [groupbutton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [memberbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void) memberbuttonpressed
{
    float width=(staff_membergroupview.frame.size.width/GroupArray.count>100)?staff_membergroupview.frame.size.width/GroupArray.count:100;
    staff_membergrouptable.frame=CGRectMake(0, 0, width*GroupArray.count, staff_membertable.frame.size.height);
    staff_membergroupview.contentSize=CGSizeMake(width*GroupArray.count, staff_membergrouptable.frame.size.height);
    [staff_membergrouptable reloadData];
    groupview.hidden=YES;
    memberview.hidden=NO;
    [groupbutton setBackgroundColor:groupinactivecolor];
    [memberbutton setBackgroundColor:groupactivecolor];
    [groupbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [memberbutton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
}

- (IBAction)closebuttonpressed:(UIButton *)sender {

    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    
    if (![self isgroupnamealreadyexistwithgroupname:((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).groupname groupkey:((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).groupkey]) {
        [self.delegate closestaffgroupviewcontrollerwithreload:informationupdated];
    }else{
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Staff Group"] message:[MyClass returntitlewithtitle:@"Please use a different group name as it already exists"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }
}


-(void)privilege_buttonhighlightcolor:(UIButton *)sender
{
    sender.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)privilege_buttonresetcolor:(UIButton *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==staff_groupdetailstable){
        return 3;
    }else{
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (tableView==staff_groupnametable){
        if (section==0) {
            return [MyClass returntitlewithtitle:@"Staff Group"];
        }
    }else if (tableView==staff_groupdetailstable){
        if (section==0) {
            return [MyClass returntitlewithtitle:@"Group Name"];
        }else if (section==1) {
            return [MyClass returntitlewithtitle:@"Description"];
        }else if (section==2) {
            return [MyClass returntitlewithtitle:@"Group Notification Event"];
        }
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView==staff_groupnametable){
        return CGFLOAT_MIN;
    }
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView==staff_membertable || tableView==staff_membergrouptable) {
        return 0.3f;
    }
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView==staff_membertable || tableView==staff_membergrouptable) {
        UIView* view = [UIView new];
        [view setBackgroundColor:[UIColor lightGrayColor]];
        return view;
    }
    return nil;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView==staff_groupnametable){
        return GroupArray.count;
    }else if (tableView==staff_groupdetailstable){
        if (section==0 || section==1) {
            return 1;
        }else{
            return groupalertarray.count;
        }
    }else if (tableView==staff_membertable){
        return allStaffArray.count;
    }else if (tableView==staff_membergrouptable){
        return allStaffArray.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==staff_groupdetailstable){
        if (indexPath.section==1) {
            return 70;
        }
    }
    return 38;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==staff_groupnametable){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        UILabel *GeneralLabel;
        UILabel *CountLabel;
        NSString *count;
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if (cell==nil){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, tableView.frame.size.width-20-45, 38)];
            GeneralLabel.font=[UIFont systemFontOfSize:15];
            GeneralLabel.textColor=[UIColor darkGrayColor];
            GeneralLabel.tag=301;
            [cell.contentView addSubview:GeneralLabel];
            
            
            CountLabel = [[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.size.width-100-10, 0, 100, 38)];
            CountLabel.font=[UIFont systemFontOfSize:13];
            CountLabel.textColor=[UIColor grayColor];
            CountLabel.textAlignment=NSTextAlignmentRight;
            CountLabel.tag=302;
            [cell.contentView addSubview:CountLabel];
            
        }else{
            GeneralLabel=(UILabel *)[cell.contentView viewWithTag:301];
            CountLabel=(UILabel *)[cell.contentView viewWithTag:302];
        }
        
        GeneralLabel.text=((GroupRecord *)[GroupArray objectAtIndex:indexPath.row]).groupname;
        count=[groupcountdictionary valueForKey:((GroupRecord *)[GroupArray objectAtIndex:indexPath.row]).groupkey];
        CountLabel.text=count?count:@"";
        
        
        return cell;
        
    }else if (tableView==staff_groupdetailstable){
        
        if (indexPath.section==0) {
            static NSString *CellIdentifier = @"section_0_cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
            
            UITextField *menutext;

            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            menutext = [[UITextField alloc]initWithFrame:CGRectMake(15, 4, tableView.frame.size.width-30, 30)];
            menutext.font=[UIFont systemFontOfSize:15];
            menutext.textColor=[UIColor darkGrayColor];
            //menutext.textAlignment=NSTextAlignmentRight;
            menutext.borderStyle = UITextBorderStyleRoundedRect;
            menutext.text=((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).groupname;
            [menutext addTarget:self action:@selector(editgroupnameeditingchanged:) forControlEvents:UIControlEventEditingChanged];
            [menutext addTarget:self action:@selector(editgroupnameeditingdidend:) forControlEvents:UIControlEventEditingDidEnd];
            [cell.contentView addSubview:menutext];
            menutext.tag=selectedGroupNameRow;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.section==1) {
            static NSString *CellIdentifier = @"section_1_cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
            
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            
            groupdescriptiontext = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(15, 4, tableView.frame.size.width-30, 60)];
            groupdescriptiontext.font=[UIFont systemFontOfSize:15];
            groupdescriptiontext.textColor=[UIColor darkGrayColor];
            groupdescriptiontext.text=((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).description;
            groupdescriptiontext.delegate=self;
            groupdescriptiontext.placeholder=[MyClass returntitlewithtitle:@"Description"];
            //[menutext addTarget:self action:@selector(editgroupname:) forControlEvents:UIControlEventEditingChanged];
            [cell.contentView addSubview:groupdescriptiontext];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            static NSString *CellIdentifier = @"section_2_cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
            UILabel *GeneralLabel;
            UISwitch *menuswitch;
            //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            if (cell==nil){
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 38)];
                GeneralLabel.font=[UIFont systemFontOfSize:15];
                GeneralLabel.textColor=[UIColor darkGrayColor];
                GeneralLabel.tag=301;
                [cell.contentView addSubview:GeneralLabel];
                
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 302;
                [menuswitch addTarget:self action:@selector(updategroup:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:menuswitch];
                
            }else{
                GeneralLabel=(UILabel *)[cell.contentView viewWithTag:301];
                menuswitch=(UISwitch *)[cell.contentView viewWithTag:302];
            }
            
            GeneralLabel.text=[MyClass returntitlewithtitle:[groupalertarray objectAtIndex:indexPath.row]];
            NSIndexPath *indexp=[staff_groupnametable indexPathForSelectedRow];
            if (indexPath.row==0) {
                menuswitch.on=((GroupRecord *)[GroupArray objectAtIndex:indexp.row]).makeuparrangementnotification;
            }else if(indexPath.row==1){
                menuswitch.on=((GroupRecord *)[GroupArray objectAtIndex:indexp.row]).autorenewalfailurenotification;
            }else if(indexPath.row==2){
                menuswitch.on=((GroupRecord *)[GroupArray objectAtIndex:indexp.row]).onlineenrollmentnotification;
            }else{
                menuswitch.on=((GroupRecord *)[GroupArray objectAtIndex:indexp.row]).onlinepaymentnotification;
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else if (tableView==staff_membertable){

        static NSString *CellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        UILabel *GeneralLabel;
        if (cell==nil){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, tableView.frame.size.width-30, 38)];
            GeneralLabel.font=[UIFont systemFontOfSize:15];
            GeneralLabel.textColor=[UIColor darkGrayColor];
            GeneralLabel.tag=301;
            GeneralLabel.numberOfLines=0;
            [cell.contentView addSubview:GeneralLabel];
            
        }else{
            GeneralLabel=(UILabel *)[cell.contentView viewWithTag:301];
        }
        
        GeneralLabel.text=[MyClass returnstaffnamewithusername:((Staff *)[allStaffArray objectAtIndex:indexPath.row]).username firstorfullname:@"full"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
        
    }else if (tableView==staff_membergrouptable){
        
        //NSString *CellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier ];
        UIButton *membergroupbutton;
        
        float width=(staff_membergroupview.frame.size.width/GroupArray.count>100)?staff_membergroupview.frame.size.width/GroupArray.count:100;
        if (cell==nil){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellIdentifier];

            for (int i=0;i<GroupArray.count;i++) {
                membergroupbutton=[[UIButton alloc]initWithFrame:CGRectMake(i*width+(width-30)/2, 4, 30, 30)];
                [membergroupbutton setImage:[UIImage imageNamed:@"checked_icon.png"] forState:UIControlStateNormal];
                [membergroupbutton addTarget: self action:@selector(enablegroupmember:) forControlEvents: UIControlEventTouchUpInside];
                membergroupbutton.tag=1000+i;
                [cell.contentView addSubview:membergroupbutton];
            }
        }
        
        
        for (int i=0; i<GroupArray.count; i++) {
            membergroupbutton=(UIButton *)[cell.contentView viewWithTag:1000+i];
            
            if([self containsGroupKeyWithMemberArray:((Staff *)[allStaffArray objectAtIndex:indexPath.row]).grouparray groupKey:((GroupRecord *)[GroupArray objectAtIndex:i]).groupkey]){
                membergroupbutton.layer.opacity=1;
            }else{
                membergroupbutton.layer.opacity=0.2;
            }
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        return cell;
        
        
    }
    return nil;

}

-(void) updategroup:(UISwitch *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:staff_groupdetailstable];
    NSIndexPath *indexpath =[staff_groupdetailstable indexPathForRowAtPoint:point];
    
    NSString *parameter;
    if (indexpath.row==0) {
        parameter=@"makeuparrangementnotification";
    }else if (indexpath.row==1){
        parameter=@"autorenewalfailurenotification";
    }else if (indexpath.row==2){
        parameter=@"onlineenrollmentnotification";
    }else{
        parameter=@"onlinepaymentnotification";
    }
    
    [self updateGroupWithField:parameter Value:sender.on?@"Yes":@"No" groupkey:((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).groupkey];
}

-(void) editgroupnameeditingchanged:(UITextField *)sender
{
    //privilegenameupdated=TRUE;
    ((GroupRecord *)[GroupArray objectAtIndex:sender.tag]).groupname=sender.text;
    
    //[self updateGroupWithField:@"groupname" Value:sender.text groupkey:((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).groupkey];
    
    //NSIndexPath *current=[staff_groupnametable indexPathForSelectedRow];
    
    [staff_groupnametable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedGroupNameRow inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [staff_groupnametable selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedGroupNameRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}


-(void) editgroupnameeditingdidend:(UITextField *)sender
{
    //trim leading and trailing space
    sender.text=[MyClass leadingtrailingspacestrimmed:sender.text];
    ((GroupRecord *)[GroupArray objectAtIndex:sender.tag]).groupname=sender.text;
    
    if (![self isgroupnamealreadyexistwithgroupname:sender.text groupkey:((GroupRecord *)[GroupArray objectAtIndex:sender.tag]).groupkey]) {
        ((GroupRecord *)[GroupArray objectAtIndex:sender.tag]).groupname=sender.text;
        
        [self updateGroupWithField:@"groupname" Value:sender.text groupkey:((GroupRecord *)[GroupArray objectAtIndex:sender.tag]).groupkey];
        [self retrieveStaffListwithflushcachedata:NO];
        
        //NSIndexPath *current=[staff_groupnametable indexPathForSelectedRow];
        
        
        [staff_groupnametable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [staff_groupnametable selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedGroupNameRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

-(BOOL) updateGroupWithField:(NSString *)field Value:(NSString *)value groupkey:(NSString *)groupkey
{

    //combine arrays
    NSDictionary *dictionary = @{@"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"field" : field,
                                 @"value" : value,
                                 @"groupkey" : groupkey,
                                 @"postaction" : @"updategroup"
                                 };
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    /*
    NSData   *finalData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalvariables.generalphpfullpath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalData length]] forHTTPHeaderField:@"Content-Length"];
    [postRequest setHTTPBody:finalData];
    
    __block BOOL result=FALSE;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSString *resString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!error) {
            result=TRUE;
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    if (result) {
        [self retrieveGroup];
        informationupdated=YES;
    }
    return result;
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView==staff_membergrouptable) {
        [staff_membertable setContentOffset:CGPointMake(0, scrollView.contentOffset.y)];
    }else if (scrollView==staff_membertable){
        [staff_membergrouptable setContentOffset:CGPointMake(staff_membergrouptable.contentOffset.x, scrollView.contentOffset.y)];
    }
    
    
}

-(BOOL) containsGroupKeyWithMemberArray:(NSMutableArray *)memberarray groupKey:(NSString *)groupkey
{
    for (int i=0; i<memberarray.count; i++) {
        GroupMemberRecord *member=[memberarray objectAtIndex:i];
        if ([member.groupkey isEqualToString:groupkey]) {
            return TRUE;
        }
    }
    return FALSE;
}

-(void) enablegroupmember:(UIButton *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:staff_membergrouptable];
    NSIndexPath *indexpath =[staff_membergrouptable indexPathForRowAtPoint:point];
    
    if([self containsGroupKeyWithMemberArray:((Staff *)[allStaffArray objectAtIndex:indexpath.row]).grouparray groupKey:((GroupRecord *)[GroupArray objectAtIndex:sender.tag-1000]).groupkey]){
//    if ([((Staff *)[allStaffArray objectAtIndex:indexpath.row]).grouparray containsObject:((GroupRecord *)[GroupArray objectAtIndex:sender.tag-1000]).groupkey]) {
        //[((Staff *)[StaffArray objectAtIndex:indexpath.row]).grouparray removeObject:((GroupRecord *)[GroupArray objectAtIndex:sender.tag-1000]).groupkey];
        sender.layer.opacity=0.2;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updatestaffgroupwithoption:@"remove" groupkey:((GroupRecord *)[GroupArray objectAtIndex:sender.tag-1000]).groupkey staffkey:((Staff *)[allStaffArray objectAtIndex:indexpath.row]).staffkey];
            [self retrieveStaffListwithflushcachedata:YES];
        });

    }else{
        //[((Staff *)[StaffArray objectAtIndex:indexpath.row]).grouparray addObject:((GroupRecord *)[GroupArray objectAtIndex:sender.tag-1000]).groupkey];
        sender.layer.opacity=1;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updatestaffgroupwithoption:@"add" groupkey:((GroupRecord *)[GroupArray objectAtIndex:sender.tag-1000]).groupkey staffkey:((Staff *)[allStaffArray objectAtIndex:indexpath.row]).staffkey];
            [self retrieveStaffListwithflushcachedata:YES];
        });
    }
}

-(BOOL) updatestaffgroupwithoption:(NSString *)option groupkey:(NSString *)groupkey staffkey:(NSString *)staffkey
{

    //combine arrays
    NSDictionary *dictionary = @{@"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"groupkey" : groupkey,
                                 @"staffkey" : staffkey,
                                 @"option" : option,
                                 @"postaction" : @"updatestaffgroup"
                                 };
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    /*
    NSData   *finalData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalvariables.generalphpfullpath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalData length]] forHTTPHeaderField:@"Content-Length"];
    [postRequest setHTTPBody:finalData];
    
    __block BOOL result=FALSE;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            result=TRUE;
        }
        //NSString *resString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    if (result) {
        informationupdated=YES;
    }
    return result;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (tableView==staff_groupnametable){
        selectedGroupNameRow=indexPath.row;
        [staff_groupdetailstable reloadData];
    }
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (tableView==staff_membergrouptable){
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
        [headerView setBackgroundColor:[UIColor systemGroupedBackgroundColor]];
        float width=tableView.frame.size.width/GroupArray.count;
        for (int i=0; i<GroupArray.count; i++) {
            UILabel *myLabel = [[UILabel alloc] init];
            myLabel.frame = CGRectMake(width*i+5, 0, width-10, 40);
            myLabel.font = [UIFont boldSystemFontOfSize:13];
            myLabel.textAlignment=NSTextAlignmentCenter;
            myLabel.minimumScaleFactor=0.7;
            myLabel.adjustsFontSizeToFitWidth=YES;
            myLabel.numberOfLines=0;
            myLabel.text = ((GroupRecord *)[GroupArray objectAtIndex:i]).groupname;
            myLabel.textColor=[UIColor grayColor];
            [headerView addSubview:myLabel];
        }
        
        return headerView;
    }else if (tableView==staff_membertable){
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
        [headerView setBackgroundColor:[UIColor systemGroupedBackgroundColor]];
        return headerView;
    }else{
        return nil;
    }
}

-(void) retrieveStaffListwithflushcachedata:(BOOL)flushcachedata
{
    allStaffArray=[[NSMutableArray alloc] initWithArray:[MyClass retrieveStaffListwithvalid:@"All" role:@"All" flushcachedata:flushcachedata]];
    NSSortDescriptor *sortbyfirstname = [NSSortDescriptor sortDescriptorWithKey:@"firstname" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSSortDescriptor *sortbylastname = [NSSortDescriptor sortDescriptorWithKey:@"lastname" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSArray *sortDescriptors = @[sortbyfirstname,sortbylastname];
    allStaffArray = [NSMutableArray arrayWithArray:[allStaffArray sortedArrayUsingDescriptors:sortDescriptors]];
}

@end
