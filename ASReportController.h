//
//  ASReportController.h
//  Zarabus
//
//  Created by Jorge Bernal on 3/26/10.
//  Copyright 2010 Jorge Bernal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	ASReportCauseUnknown,
	ASReportCauseServerConnect,
	ASReportCauseDataParse,
	ASReportCauseCustom
} ASReportCause;

@interface ASReportController : UIViewController {
	ASReportCause cause;
	NSString *details;
	IBOutlet UITextField *emailField;
	IBOutlet UILabel *detailsLabel;
}
@property (nonatomic,retain) NSString *details;
- (id)initWithCause:(ASReportCause)reportCause;
- (IBAction)sendReport:(id)sender;
- (IBAction)dismiss:(id)sender;
@end
