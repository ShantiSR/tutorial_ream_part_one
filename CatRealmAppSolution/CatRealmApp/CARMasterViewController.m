//
//  CARMasterViewController.m
//  CatRealmApp
//
//  Created by Erick Camacho on 8/3/14.
//  Copyright (c) 2014 codigoambar. All rights reserved.
//

#import "CARMasterViewController.h"

#import "CARCat.h"
#import "CARDetailViewController.h"
#import "AnimatedGIFImageSerialization.h"

@interface CARMasterViewController () {
    RLMArray *_objects;
}
@end

@implementation CARMasterViewController


- (void)viewDidLoad
{
  [super viewDidLoad];
	
  self.navigationItem.leftBarButtonItem = self.editButtonItem;
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
  self.navigationItem.rightBarButtonItem = addButton;
  _objects = [CARCat allObjects];
}


- (void)insertNewObject:(id)sender
{
  [self performSegueWithIdentifier:@"showDetail" sender:self];
}

- (void)addCat:(NSDictionary *)dictionary
{
  
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

  CARCat *cat = _objects[indexPath.row];
  cell.textLabel.text = cat.imageTitle;
  NSString *imagePath = cat.imagePath;
  UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
  NSLog(@"image %@", image);
  cell.imageView.image = image;
  return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
      CARCat *cat = _objects[indexPath.row];
      [cat remove];
      _objects = [CARCat allObjects];
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"showDetail"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
      CARCat *cat = _objects[indexPath.row];
      [[segue destinationViewController] setTheCat:cat];
      [[segue destinationViewController] setIsNew:NO];
    } else {      
      [[segue destinationViewController] setIsNew:YES];
    }
  }
}

@end
