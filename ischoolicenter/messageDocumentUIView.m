//
//  messageDocumentUIView.m
//  iCenter
//
//  Created by Jasmond Luk on 22/3/2020.
//  Copyright © 2020 DreamHigh Company Limited. All rights reserved.
//

#import "messageDocumentUIView.h"

@implementation messageDocumentUIView
@synthesize imageview,viewbutton;

-(id) initWithFrame:(CGRect)frame messagePhotoRecord:(nonnull MessagePhotoRecord *)messagephotorecord
{
    NSString* nibName = NSStringFromClass([self class]);
    self = [super initWithFrame:frame];
    if (self) {
        if ([[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil]) {
            box.layer.masksToBounds=YES;
            box.layer.cornerRadius=5;
            
            filenamebox.hidden=![messagephotorecord.filetype isEqualToString:@"pdf"];
            filenametitle.text=messagephotorecord.filename;
            videoicon.hidden=![messagephotorecord.filetype isEqualToString:@"video"];
            
            self.view.frame=self.bounds;
            [self addSubview:self.view];
        }
    }
    return self;
}

@end
