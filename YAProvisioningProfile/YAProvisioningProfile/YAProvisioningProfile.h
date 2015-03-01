//
//  YAProvisioningProfile.h
//  YAProvisioningProfile
//
//  Created by Jimmy Arts on 21/02/15.
//  Copyright (c) 2015 Jimmy Arts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YAProvisioningProfile : NSObject

- (id)initWithPath:(NSString *)path;

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *teamName;
@property (nonatomic, assign, getter=isValid, readonly) BOOL valid;
@property (nonatomic, assign, getter=isDebug, readonly) BOOL debug;
@property (nonatomic, strong, readonly) NSDate *creationDate;
@property (nonatomic, strong, readonly) NSDate *expirationDate;
@property (nonatomic, strong, readonly) NSString *UUID;
@property (nonatomic, strong, readonly) NSArray *devices;
@property (nonatomic, assign, readonly) NSInteger timeToLive;
@property (nonatomic, strong, readonly) NSString *applicationIdentifier;
@property (nonatomic, strong, readonly) NSString *bundleIdentifier;
@property (nonatomic, strong, readonly) NSArray *certificates;
@property (nonatomic, assign, readonly) NSInteger version;
@property (nonatomic, assign, readonly) NSArray *prefixes;

@end
