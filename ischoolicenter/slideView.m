//
//  slideView.m
//  ischooliparent
//
//  Created by Jasmond Luk on 6/6/2019.
//  Copyright © 2019 Dreamware Limited. All rights reserved.
//

#import "slideView.h"

@implementation slideView
@synthesize view;



-(id) initWithFrame:(CGRect)frame SlidePhotoRecord:(SlidePhotoRecord *)slidephotoobject SlideIndex:(NSInteger)slideindex
{
    NSString* nibName = NSStringFromClass([self class]);
    self = [super initWithFrame:frame];
    if (self) {
        if ([[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil]) {
            if (!slidephotoobject.type) {
                addview.hidden=NO;
            }else{
                addview.hidden=YES;
                [MyClass downloadImageWithImageview:imageview gender:nil type:slidephotoobject.type typekey:slidephotoobject.thumbnailurl image:@"Yes" async:YES];
                
                if ([slidephotoobject.title isEqualToString:@""]) {
                    titleview.hidden=YES;
                }else{
                    titleview.hidden=NO;
                    titlelabel.text=slidephotoobject.title;
                }
                videoplayicon.hidden=![slidephotoobject.filetype isEqualToString:@"video"];
                deletebutton.tag=slideindex;
                deletebutton.hidden=!slidephotoobject.editable;
                daylabel.text=[self returndaytitlewithslidephotoobject:slidephotoobject];
                
                if ([[MyClass returnfiletypewithfilename:slidephotoobject.filename] isEqualToString:@"pdf"]) {
                    slidemasterview.backgroundColor=[UIColor whiteColor];
                }else{
                    slidemasterview.backgroundColor=[UIColor clearColor];
                }
                viewbutton.tag=slideindex;
            }

            self.tag=slideindex;
            
            self.view.frame=self.bounds;
            [self addSubview:self.view];
        }
    }
    return self;
}

- (IBAction)addbuttonpressed:(id)sender {
    [self.delegate addSlideWithButton:sender];
}

- (IBAction)viewbuttonpressed:(UIButton *)sender {
    [self.delegate selectedSlideIndex:sender.tag];
}

-(NSString *)returndaytitlewithslidephotoobject:(SlidePhotoRecord *)object
{
    NSDate *nspostdate=[MyClass convertToNSDateWithDate:object.postdate DateFormat:@"yyyy-MM-dd"];
    
    NSString *dayago;
    NSString *dayleft;
    
    NSInteger noofdayago= [MyClass noOfDayBetweenStartDate:nspostdate EndDate:[NSDate date]];
    if (noofdayago==0){
        dayago= [MyClass returntitlewithtitle:@"Today"];
    }else if (noofdayago==1){
        dayago= [MyClass returntitlewithtitle:@"1 day ago"];
    }else{
        dayago= [MyClass returnreplacedtitlewithtitle:@"%@1 days ago" replacementarray:@[[@(noofdayago) stringValue]]];
    }
    
    if (![object.hn_expiry_date isEqualToString:@""]) {
        NSDate *nsexpirydate=[MyClass convertToNSDateWithDate:object.hn_expiry_date DateFormat:@"yyyy-MM-dd"];
        NSInteger noofdayleft= [MyClass noOfDayBetweenStartDate:[NSDate date] EndDate:nsexpirydate];
        if (noofdayleft==1){
            dayleft= [MyClass returntitlewithtitle:@"1 day left"];
        }else{
            dayleft= [MyClass returnreplacedtitlewithtitle:@"%@1 days left" replacementarray:@[[@(noofdayleft) stringValue]]];
        }
    }else{
        dayleft = [MyClass returntitlewithtitle:@"Forever"];
    }
    
    
    return [NSString stringWithFormat:@"%@ / %@",dayago,dayleft];
}

- (IBAction)deletebuttonpressed:(UIButton *)sender {
    [self.delegate deleteSlideWithIndex:sender.tag];
}


@end
