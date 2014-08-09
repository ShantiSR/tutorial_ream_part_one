//
//  CARDetailViewController.m
//  CatRealmApp
//
//  Created by Erick Camacho on 8/3/14.
//  Copyright (c) 2014 codigoambar. All rights reserved.
//

#import "CARDetailViewController.h"
#import "CARMasterViewController.h"
#import "AnimatedGIFImageSerialization.h"

@interface CARDetailViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *catImageView;
@property (nonatomic, weak) IBOutlet UITextField *catTitleTextField;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSString *imagePath;
@end

@implementation CARDetailViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [(UIControl *)self.view addTarget:self action:@selector(hideKeyboard)
                   forControlEvents:UIControlEventTouchUpInside];
  if (self.theCat) {
    [self configureView];
  } else {
    self.theCat = [NSMutableDictionary dictionary];
  }
  
}


- (void)configureView
{
  if (self.theCat) {
    self.catImageView.image     = [UIImage imageWithData:[NSData dataWithContentsOfFile:self.theCat[@"imageFile"]]];
    self.catTitleTextField.text = self.theCat[@"imageTitle"];
  }
}


- (void)hideKeyboard
{
  [self.catTitleTextField resignFirstResponder];
}


- (IBAction)cancel:(id)sender {
  if (self.imagePath) {
    [self deleteFileWithPath:self.imagePath];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
  }
}

- (IBAction)save:(id)sender {
  if (!self.catTitleTextField.text.length ) {
    [self handleError:@"Please, enter a title"];
  }
  else if (!self.catImageView.image ) {
    [self handleError:@"Please, add a Cat image"];
  } else {
    self.theCat[@"imageTitle"] = self.catTitleTextField.text;
    if (self.imagePath) {
      self.theCat[@"imageFile"]  = self.imagePath;
    }
    
    CARMasterViewController *masterViewController = (CARMasterViewController *)[(UINavigationController *)self.presentingViewController topViewController];
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:^{
                                                        if (self.isNew) {
                                                          [masterViewController addCat:self.theCat];
                                                        }
                                                        [masterViewController.tableView reloadData];
                                                      }];
  }
}


- (IBAction)fetchCatGif:(id)sender {
  [self.spinner setHidden:NO];
  [self.spinner startAnimating];
  NSURL *catApiUrl           = [NSURL URLWithString:@"http://thecatapi.com/api/images/get"];
  NSURLRequest *request      = [NSURLRequest requestWithURL:catApiUrl];
  NSURLSession *session      = [NSURLSession sharedSession];
  NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                          completionHandler: ^(NSData *data, NSURLResponse *resp, NSError *error) {
                                            if (!error) {
                                              NSHTTPURLResponse * response =  (NSHTTPURLResponse *)resp;
                                              NSLog(@"response code %ld", response.statusCode );
                                              if (response.statusCode == 200) {
                                                NSLog(@"image %@", response.suggestedFilename);
                                                self.imagePath = [self saveImageWithData:data];
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                  [self.spinner stopAnimating];
                                                  self.catImageView.image     = [UIImage imageWithData:data];
                                                });
                                              } else {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                  [self.spinner stopAnimating];
                                                  [self handleError:[NSString stringWithFormat:@"Server responded with code %ld", response.statusCode]];
                                                });
                                              }
                                            } else {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                [self.spinner stopAnimating];
                                                [self handleError:error.localizedDescription];
                                              });
                                            }
                                }];
  [task resume];
}

- (void)handleError:(NSString *)errorMessage
{
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                 message:errorMessage
                                                delegate:nil
                                       cancelButtonTitle:@"Ok"
                                       otherButtonTitles:nil];
  [alert show];
}


#pragma mark - file handler methods
- (void)deleteFileWithPath:(NSString *)path
{
  [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}

- (NSString *)saveImageWithData:(NSData *)data
{
  NSString *imagePath = [self pathForFile:[[NSUUID UUID] UUIDString]];
  [data writeToFile:imagePath
         atomically:YES];
  return imagePath;
}

- (NSString *)pathForFile:(NSString *)fileName
{
  NSURL *documentsFolder = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                   inDomains:NSUserDomainMask] lastObject];
  
  return [[documentsFolder path] stringByAppendingPathComponent:fileName];
}

@end
