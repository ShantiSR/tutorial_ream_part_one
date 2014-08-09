//
//  CARCat.h
//  CatRealmApp
//
//  Created by Erick Camacho on 8/3/14.
//  Copyright (c) 2014 codigoambar. All rights reserved.
//

#import <Realm/Realm.h>

@interface CARCat : RLMObject

@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *imageTitle;

- (void)save;
- (void)remove;
- (void)updateWithImagePath:(NSString *)imagePath andTitle:(NSString *)imageTitle;

@end

RLM_ARRAY_TYPE(CARCat)