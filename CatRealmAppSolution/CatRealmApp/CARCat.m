//
//  CARCat.m
//  CatRealmApp
//
//  Created by Erick Camacho on 8/3/14.
//  Copyright (c) 2014 codigoambar. All rights reserved.
//

#import "CARCat.h"

@implementation CARCat


- (void)save
{
  RLMRealm *realm = [RLMRealm defaultRealm];
  [realm beginWriteTransaction];
  [realm addObject:self];
  [realm commitWriteTransaction];
}

- (void)remove
{
  RLMRealm *realm = [RLMRealm defaultRealm];
  [realm beginWriteTransaction];
  [realm deleteObject:self];
  [realm commitWriteTransaction];
}

- (void)updateWithImagePath:(NSString *)imagePath andTitle:(NSString *)imageTitle;
{
  RLMRealm *realm = [RLMRealm defaultRealm];
  [realm beginWriteTransaction];
  self.imagePath  = imagePath;
  self.imageTitle = imageTitle;
  [realm commitWriteTransaction];
}


// Specify default values for properties
+ (NSDictionary *)defaultPropertyValues
{
  return @{@"imagePath":@"", @"imageTitle":@"My cat"};
}

// Specify properties to ignore (Realm won't persist these)
+ (NSArray *)ignoredProperties
{
  return @[];
}

@end
