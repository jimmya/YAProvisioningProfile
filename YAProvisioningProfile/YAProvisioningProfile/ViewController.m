//
//  ViewController.m
//  YAProvisioningProfile
//
//  Created by Jimmy Arts on 21/02/15.
//  Copyright (c) 2015 Jimmy Arts. All rights reserved.
//

#import "ViewController.h"
#import "YAProvisioningProfile.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet NSPopUpButton *provisioningSelectButton;
@property (nonatomic, weak) IBOutlet NSTextField *profileName;
@property (nonatomic, weak) IBOutlet NSTextField *bundleIdentifier;
@property (nonatomic, weak) IBOutlet NSButton *validButton;
@property (nonatomic, weak) IBOutlet NSButton *debugButton;
@property (nonatomic, weak) IBOutlet NSTextField *version;
@property (nonatomic, weak) IBOutlet NSTextField *creationDate;
@property (nonatomic, weak) IBOutlet NSTextField *expirationDate;
@property (nonatomic, weak) IBOutlet NSTextField *teamName;
@property (nonatomic, weak) IBOutlet NSPopUpButton *devicesSelectButton;
@property (nonatomic, weak) IBOutlet NSTextField *UUID;
@property (nonatomic, weak) IBOutlet NSPopUpButton *prefixes;

@property (nonatomic, strong) NSMutableArray *profiles;

@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        self.profiles = [NSMutableArray new];
        
        self.formatter = [[NSDateFormatter alloc] init];
        self.formatter.dateFormat = @"dd-MM-yyyy";
        
        NSArray *provisioningProfiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/Library/MobileDevice/Provisioning Profiles", NSHomeDirectory()] error:nil];
        provisioningProfiles = [provisioningProfiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.mobileprovision'"]];
        
        for (NSString *path in provisioningProfiles) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/Library/MobileDevice/Provisioning Profiles/%@", NSHomeDirectory(), path] isDirectory:NO]) {
                YAProvisioningProfile *profile = [[YAProvisioningProfile alloc] initWithPath:[NSString stringWithFormat:@"%@/Library/MobileDevice/Provisioning Profiles/%@", NSHomeDirectory(), path]];
                
                [self.profiles addObject:profile];
            }
        }
        
        self.profiles = [[self.profiles sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [((YAProvisioningProfile *)obj1).name compare:((YAProvisioningProfile *)obj2).name];
        }] mutableCopy];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            for (NSInteger i = 0; i < self.profiles.count; i++) {
                NSString *name = [NSString stringWithFormat:@"%lu - %@", (long)i + 1, ((YAProvisioningProfile *)self.profiles[i]).name];
                [self.provisioningSelectButton addItemWithTitle:name];
            }
            
            if (self.profiles.count > 0) {
                [self selectProfileAtIndex:0];
            } else {
                [self.provisioningSelectButton addItemWithTitle:@"No profiles"];
                self.provisioningSelectButton.enabled = NO;
            }
        });
    });
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)provisioningSelectAction:(id)sender
{
    [self selectProfileAtIndex:self.provisioningSelectButton.indexOfSelectedItem];
}

- (void)selectProfileAtIndex:(NSInteger)index
{
    YAProvisioningProfile *selectedProfile = self.profiles[self.provisioningSelectButton.indexOfSelectedItem];
    
    self.profileName.stringValue = selectedProfile.name;
    self.bundleIdentifier.stringValue = selectedProfile.bundleIdentifier;
    self.validButton.state = selectedProfile.isValid ? NSOnState : NSOffState;
    self.validButton.enabled = selectedProfile.isValid;
    self.debugButton.state = selectedProfile.isDebug ? NSOnState : NSOffState;
    self.debugButton.enabled = selectedProfile.isDebug;
    self.teamName.stringValue = selectedProfile.teamName ? selectedProfile.teamName : @"";
    self.creationDate.stringValue = selectedProfile.creationDate ? [self.formatter stringFromDate:selectedProfile.creationDate] : @"Unknown";
    self.expirationDate.stringValue = selectedProfile.expirationDate ? [self.formatter stringFromDate:selectedProfile.expirationDate] : @"Unknown";
    
    [self.devicesSelectButton removeAllItems];
    if (selectedProfile.devices.count > 0) {
        self.devicesSelectButton.enabled = YES;
        [self.devicesSelectButton addItemsWithTitles:selectedProfile.devices];
    } else {
        self.devicesSelectButton.enabled = NO;
        [self.devicesSelectButton addItemWithTitle:@"No devices"];
    }
    
    self.UUID.stringValue = selectedProfile.UUID;
    self.version.stringValue = [NSString stringWithFormat:@"%lu", (long)selectedProfile.version];
    
    [self.prefixes removeAllItems];
    if (selectedProfile.prefixes.count > 0) {
        self.prefixes.enabled = YES;
        [self.prefixes addItemsWithTitles:selectedProfile.prefixes];
    } else {
        self.prefixes.enabled = NO;
        [self.prefixes addItemWithTitle:@"No prefix"];
    }
}

@end
