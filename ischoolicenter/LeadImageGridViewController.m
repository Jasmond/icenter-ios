//
//  LeadImageGridViewController.m
//  EyeEnroll
//
//  Created by Jasmond Luk on 18/5/15.
//  Copyright (c) 2015 DreamHigh Company Limited. All rights reserved.
//

#import "LeadImageGridViewController.h"
#import "LeadGridCollectionViewCell.h"
#import "MyClass.h"

@interface LeadImageGridViewController ()

@end

@implementation LeadImageGridViewController
@synthesize leadArray,leadcategory,mode,source,tmpcallingkey;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    globalvariables=[GlobalVariables singleObj];
    
    filteredLeadArray=[[NSMutableArray alloc]initWithArray:leadArray];
    
    viewtitle.text=[NSString stringWithFormat:@"%@ - %@",[MyClass returntitlewithtitle:@"Lead Photo"],[MyClass returntitlewithtitle:leadcategory]];
    [title_CancelButton setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
    [title_DoneButton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];

    df=[[NSDateFormatter alloc]init];df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    
    [leadphotocollection reloadData];
    
    if ([mode isEqualToString:@"multiple"]) {
        //checkimagearray=[[NSMutableArray alloc]init];
        for (int i=0; i<leadArray.count; i++) {
            
            ((Lead *)[leadArray objectAtIndex:i]).photoalbumrecord=[[ClassValidateRecord alloc]initClassValidateRecordwithstatus:@"" classvalidatestatus:[[ClassValidateStatus alloc]init] classvalidmessage:[[ClassValidateMessage alloc]init] classkey:nil];

            if (tmpcallingkey && tmpcallingkey.count>0) {
                if ([tmpcallingkey containsObject:((Student *)[leadArray objectAtIndex:i]).leadkey]) {
                    ((ClassValidateRecord *)((Lead *)[leadArray objectAtIndex:i]).photoalbumrecord).status=@"Checked";
                }
            }
        }
        
        int checked=[self returncheckedimage];
        
        if (checked>0) {
            [title_DoneButton setTitle:[NSString stringWithFormat:@"%@ (%d)",[MyClass returntitlewithtitle:@"Done"],checked] forState:UIControlStateNormal];
        }else{
            [title_DoneButton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
        }
        
    }else{
        title_DoneButton.hidden=YES;
    }
    
    self.preferredContentSize=CGSizeMake(984, 738);
    
    
    leadsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 68, self.preferredContentSize.width, 42)];
    leadsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    leadsearchbar.delegate=self;
    [self.view addSubview:leadsearchbar];
    
    
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


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return filteredLeadArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LeadGridCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    
    leadobject=[filteredLeadArray objectAtIndex:indexPath.row];
    
    cell.leadnamelabel.text=[MyClass returnLeadnameWithLeadkey:leadobject.leadkey option:@"full"];
    
    ////[MyClass downloadImageWithImageview:cell.leadimage collectionview:collectionView indexpath:indexPath gender:leadobject.gender type:@"lead" typekey:leadobject.leadkey image:leadobject.image];
    
    [MyClass downloadImageWithImageview:cell.leadimage gender:leadobject.gender type:@"lead" typekey:leadobject.leadkey image:leadobject.image async:YES];
    
    /*
    if ([leadobject.image isEqualToString:@"Yes"]) {
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@leadimages/%@/lead_%@_%@.jpg",globalvariables.serverpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey, leadobject.leadkey]];
        
        if ([imageCache objectForKey:url]) {
            [cell.leadimage setImage:[imageCache objectForKey:url]];
        }else{
            if ([leadobject.gender isEqualToString:@"Male"]) {
                [cell.leadimage setImage:boyimage];
            }else if ([leadobject.gender isEqualToString:@"Female"]){
                [cell.leadimage setImage:girlimage];
            }else{
                [cell.leadimage setImage:girlimage];
            }
        }
        
        
        [self checkifimagechangedwithURL:url studentimage:cell.leadimage indexpath:indexPath completionBlock:^(BOOL imagechanged, NSURL *URL, UIImageView *stimage, NSIndexPath *stimageindexpath){
            if (imagechanged || ![imageCache objectForKey:URL]) {
                [self downloadImageWithURL:URL studentimage:stimage indexpath:stimageindexpath completionBlock:^(BOOL succeeded, NSData *data, UIImageView *simage, NSIndexPath *imageindexpath, NSURL *_url) {
                    
                    CGPoint point = [simage.superview convertPoint:CGPointZero toView:collectionView];
                    NSIndexPath *indexpath =[collectionView indexPathForItemAtPoint:point];
                    if ([collectionView.indexPathsForVisibleItems indexOfObject:imageindexpath] != NSNotFound && indexpath.row==imageindexpath.row)
                    {
                        if (succeeded) {
                            if (imageindexpath) {
                                if ([[UIImage alloc] initWithData:data]) {
                                    simage.image = [[UIImage alloc] initWithData:data];
                                    [imageCache setObject:simage.image forKey:_url];
                                }
                            }
                        }
                    }
                }];
            }
        }];
    }else{
        
        
        if ([leadobject.gender isEqualToString:@"Male"]) {
            [cell.leadimage setImage:boyimage];
        }else if ([leadobject.gender isEqualToString:@"Female"]){
            [cell.leadimage setImage:girlimage];
        }else{
            [cell.leadimage setImage:girlimage];
        }
        
    }*/
    
    cell.leadimage.layer.cornerRadius=10;
    cell.leadimage.layer.masksToBounds=YES;
    
    //cell.informationbutton.layer.cornerRadius=15;
    //cell.informationbutton.layer.masksToBounds=YES;
    
    photoalbumobject=((Lead *)[filteredLeadArray objectAtIndex:indexPath.row]).photoalbumrecord;
    
    if ([mode isEqualToString:@"multiple"]) {
        cell.informationbutton.hidden=YES;
        if ([source isEqualToString:@"message"]){
            if ([photoalbumobject.status isEqualToString:@"Checked"]) {
                [cell.informationbutton setImage:[UIImage imageNamed:@"checked_icon.png"] forState:UIControlStateNormal];
                cell.informationbutton.hidden=NO;
                cell.informationbutton.userInteractionEnabled=NO;
            }else{
                cell.informationbutton.hidden=YES;
            }
        }
    }else{
        cell.informationbutton.hidden=YES;
    }
    
    return cell;
}



-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(154, 180+20+0);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(46, 5, 20, 5);
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([mode isEqualToString:@"multiple"]) {
        //if ([[checkimagearray objectAtIndex:indexPath.row] isEqualToString:@""] || [[checkimagearray objectAtIndex:indexPath.row] isEqualToString:@"Checked"]) {
        photoalbumobject=((Lead *)[filteredLeadArray objectAtIndex:indexPath.row]).photoalbumrecord;
        
        if (![photoalbumobject.status isEqualToString:@""]) {
            photoalbumobject.status=@"";
            //[checkimagearray replaceObjectAtIndex:indexPath.row withObject:@""];
        }else{
            photoalbumobject.status=@"Checked";
            //[checkimagearray replaceObjectAtIndex:indexPath.row withObject:@"Checked"];
        }
        filteredLeadArray=[self returnfilteleadarray];
        [leadphotocollection reloadData];
        
        int checked=[self returncheckedimage];
        
        if (checked>0) {
            [title_DoneButton setTitle:[NSString stringWithFormat:@"%@ (%d)",[MyClass returntitlewithtitle:@"Done"],checked] forState:UIControlStateNormal];
        }else{
            [title_DoneButton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
        }
        //}
    }else{
        leadobject=[filteredLeadArray objectAtIndex:indexPath.row];
        [self.delegate passleadfromgrid:leadobject.leadkey];
    }
    
}

-(int) returncheckedimage
{
    int checked=0;
    for (int i=0; i<filteredLeadArray.count; i++) {
        photoalbumobject=((Lead *)[filteredLeadArray objectAtIndex:i]).photoalbumrecord;
        if ([photoalbumobject.status isEqualToString:@"Checked"]) {
            checked+=1;
        }
    }
    return checked;
}

- (IBAction)cancelbuttonpressed:(id)sender {
    [self.delegate dismissleadgridview];
    
}

- (IBAction)donebuttonpressed:(id)sender
{
    BOOL checkedimagefound=FALSE;
    
if ([source isEqualToString:@"message"]){
        NSMutableArray *leadlist=[[NSMutableArray alloc]init];
        for (int i=0; i<filteredLeadArray.count; i++) {
            photoalbumobject=((Lead *)[filteredLeadArray objectAtIndex:i]).photoalbumrecord;
            if ([photoalbumobject.status isEqualToString:@"Checked"]) {
                [leadlist addObject:((Lead *)[filteredLeadArray objectAtIndex:i]).leadkey];
                checkedimagefound=TRUE;
            }
        }
        
        if (!checkedimagefound) {
            
            UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Send Message"] message:[MyClass returntitlewithtitle:@"Please select at least 1 lead to send message"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [missinginput dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [missinginput addAction:OKAction];
            //[self presentViewController:missinginput animated:YES completion:nil];
            [MyClass presentViewController:missinginput View:self];
        }else{
            //pass student list to message popover window
            [self.delegate passleadarrayfromgrid:leadlist];
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar==leadsearchbar) {
        filteredLeadArray=[self returnfilteleadarray];
        [leadphotocollection reloadData];
        [leadphotocollection setContentOffset:CGPointZero animated:YES];
    }
}

-(NSMutableArray *) returnfilteleadarray
{
    NSMutableArray *result;
    
    if ([leadsearchbar.text isEqualToString:@""]) {
        result= [[NSMutableArray alloc]initWithArray:leadArray];
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.othername contains[c] %@ or SELF.firstname contains[c] %@ or self.lastname contains[c] %@ or self.parentcontact contains[c] %@ or self.leadid contains[c] %@ or self.remarks contains[c] %@ or self.grade contains[c] %@ or self.school contains[c] %@ or self.parentemail contains[c] %@ or self.parentaddress contains[c] %@ or photoalbumrecord.status contains[c] %@",leadsearchbar.text,leadsearchbar.text,leadsearchbar.text,leadsearchbar.text,leadsearchbar.text,leadsearchbar.text,leadsearchbar.text,leadsearchbar.text,leadsearchbar.text,leadsearchbar.text,@"Checked"];
        
        
        result= [[NSMutableArray alloc]initWithArray:[leadArray filteredArrayUsingPredicate:predicate]];
    }
    
    return [MyClass sortleadlistwithleadarray:result sortingarray:nil];
}


@end
