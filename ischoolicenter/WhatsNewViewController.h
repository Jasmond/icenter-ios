//
//  WhatsNewViewController.h
//  iCenter
//
//  Created by Jasmond Luk on 23/5/2020.
//  Copyright © 2020 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "MyClass.h"
#import "FullScreenPhotoViewController.h"

@protocol myWhatsNewViewControllerDelegate <NSObject>
-(void) closewhatsnewwindowwithviewcontroller:(UIViewController *)view;
@end

@interface WhatsNewViewController : UIViewController<myFullScreenPhotoViewControllerDelegate>
{
    GlobalVariables *globalvariables;
    __weak IBOutlet UIButton *closeButton;
    __weak IBOutlet UILabel *titlelabel;
    __weak IBOutlet UITableView *whatsnewtable;
    __weak IBOutlet UILabel *norecordlabel;
    __weak IBOutlet UIActivityIndicatorView *ailoadingindicator;
    
    NSMutableArray *whatsnewarray;
    
    UIWindow *mainWindow;
    
    NSInteger viewwidth;
    NSInteger viewheight;
    FullScreenPhotoViewController *fullscreenphotoviewcontroller;
    
}

@property (nonatomic,weak) id<myWhatsNewViewControllerDelegate>delegate;
- (IBAction)closebuttonpressed:(id)sender;

@end

