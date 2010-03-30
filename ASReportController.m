    //
//  ASReportController.m
//  Zarabus
//
//  Created by Jorge Bernal on 3/26/10.
//  Copyright 2010 Jorge Bernal. All rights reserved.
//

#import "ASReportController.h"


@implementation ASReportController
@synthesize details;

- (id)initWithCause:(ASReportCause)reportCause {
	if (self = [super initWithNibName:@"ASReportController" bundle:nil]) {
		cause = reportCause;
	}
	
	return self;
}

- (NSString *)description {
	switch (cause) {
		case ASReportCauseServerConnect:
			return NSLocalizedString(@"Can't connect to server",@"");
			break;
		case ASReportCauseDataParse:
			return NSLocalizedString(@"Error parsing data",@"");
			break;
		default:
			return NSLocalizedString(@"Unknown error",@"");
			break;
	}
}

- (NSString *)causeName {
	switch (cause) {
		case ASReportCauseServerConnect:
			return @"serverconnect";
			break;
		case ASReportCauseDataParse:
			return @"dataparse";
			break;
		case ASReportCauseCustom:
			return @"custom";
			break;
		default:
			return @"unknown";
			break;
	}
}

- (void)dealloc {
    [super dealloc];
}

- (IBAction)sendReport:(id)sender {
	NSURL *reportUrl = [NSURL URLWithString:@"http://appstatus.42foo.com/report"];
	NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
							[[UIDevice currentDevice] uniqueIdentifier],
							@"device_id",
							[[NSBundle mainBundle] bundleIdentifier],
							@"app_id",
							[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
							@"app_version",
							[emailField text],
							@"email",
							[self causeName],
							@"cause",
							details,
							@"details",
							nil];
	NSLog(@"Reporting to %@ with params %@", reportUrl, parameters);							
	
	NSMutableString *params = nil;
    if (parameters != nil)
    {
        params = [[NSMutableString alloc] init];
        for (id key in parameters)
        {
            NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            CFStringRef value = (CFStringRef)[[parameters objectForKey:key] copy];
            // Escape even the "reserved" characters for URLs
            // as defined in http://www.ietf.org/rfc/rfc2396.txt
            CFStringRef encodedValue = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                               value,
                                                                               NULL,
                                                                               (CFStringRef)@";/?:@&=+$,",
                                                                               kCFStringEncodingUTF8);
            [params appendFormat:@"%@=%@&", encodedKey, encodedValue];
            CFRelease(value);
            CFRelease(encodedValue);
        }
        [params deleteCharactersInRange:NSMakeRange([params length] - 1, 1)];
    }
	NSData *body = [params dataUsingEncoding:NSUTF8StringEncoding];
	NSLog(@"Sending body: %@", body);
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:reportUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
	[request setHTTPBody:body];
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request
										   delegate:self
								   startImmediately:YES];
	
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
	[self release];
}

- (IBAction)dismiss:(id)sender {
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
	[self release];
}

@end
