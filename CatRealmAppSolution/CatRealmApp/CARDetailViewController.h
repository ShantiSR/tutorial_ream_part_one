//
//  CARDetailViewController.h
//  CatRealmApp
//
//  Created by Erick Camacho on 8/3/14.
//  Copyright (c) 2014 codigoambar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CARCat.h"

@interface CARDetailViewController : UIViewController

@property (strong, nonatomic) CARCat *theCat;

@property (assign, nonatomic) BOOL isNew;

@end
