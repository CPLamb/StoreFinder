//
//  TestingViewController.m
//  ThinkLocalFirst
//
//  Created by Chris Lamb on 4/27/13.
//  Copyright (c) 2013 Chris Lamb. All rights reserved.
//

#import "TestingViewController.h"

@interface TestingViewController ()

@end

#define RECT_PADDING 2.0    // space around data object
#define RECT_SPACING 10.0    // space between backgrounds

@implementation TestingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskLandscape;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Custom methods

- (IBAction)test01:(id)sender {
    NSLog(@"Someone is doing some NSDocumentDirectory stuff");
    
    //----- LIST ALL FILES -----
    NSLog(@"LISTING ALL FILES FOUND");
    
    int Count;
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@""];
    NSLog(@"URL is %@", path);
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for (Count = 0; Count < (int)[directoryContent count]; Count++)
    {
        NSLog(@"File %d: %@", (Count + 1), [directoryContent objectAtIndex:Count]);
    }
    
/*
// Set up fileManager & get directory URLs
    NSFileManager *myFileManager = [NSFileManager defaultManager];
    NSArray *myDocumentDirectoryURL = [myFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSLog(@"NSDocumentDirectory %@", myDocumentDirectoryURL);
    
// Get contents of the directory
    NSURL *myFirstDirectoryURL = [myDocumentDirectoryURL objectAtIndex:0];
    NSString *myFirstDirectoryString = [myFirstDirectoryURL absoluteString];
    NSArray *myFiles = [myFileManager contentsOfDirectoryAtPath:myFirstDirectoryString error:nil];
    NSError* err = nil;
    if( err != nil ){
        NSDictionary* d = [err userInfo];
        NSLog(@"There was an error reading the files in the documents directory %@ ... %@", myFirstDirectoryURL, d);
    }
    NSLog(@"files are %@", myFiles);
*/    
}

- (IBAction)test02:(id)sender {
// Get a handle on the shared file manager already resident in memory
    NSFileManager *myFileManager = [NSFileManager defaultManager];
    
// Get's the app's bundle
    NSArray *myBundle = [NSBundle allBundles];
    NSLog(@"ALL my apps bundles are %@", myBundle);
    
// List the contents of that bundle
    NSURL *TLFMemberListURL = [[NSBundle mainBundle] URLForResource:@"TLFMemberList" withExtension:@"plist"];
    NSLog(@"my local PLIST data URL is %@", TLFMemberListURL);
    
//    - (BOOL)fileManager:(NSFileManager *)fileManager shouldCopyItemAtURL:(NSURL *)srcURL toURL:(NSURL *)dstURL
    
// ??????Copy the bundle PList to the documents directory
    NSArray *myDocumentDirectoryURL = [myFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL* docDirURL = [myDocumentDirectoryURL objectAtIndex:0];
    NSString* docDirStr = [docDirURL absoluteString];
    NSLog(@"my DOCUMENTS directory URL is %@", docDirStr);
    
// Build the destination URL
    NSString* fileName = [TLFMemberListURL absoluteString];
    NSString* fileBaseName = [fileName lastPathComponent];
    NSString* destinationFile = [docDirStr stringByAppendingPathComponent:fileBaseName];
    NSLog(@"my DESTINATION directory URL is %@", destinationFile);
    
    NSLog(@"-----------------------------");
    NSError* err = nil;
//    [myFileManager copyItemAtURL:TLFMemberListURL toURL:[myDocumentDirectoryURL objectAtIndex:0] error:&err];
    [myFileManager copyItemAtPath:fileName toPath:destinationFile error:&err];
    
// Error catch
    if( err != nil ){
        NSDictionary* d = [err userInfo];
        NSLog(@"There was an error copying %@ to %@ ... %@", fileName, destinationFile, d);
    }



}

@end
