//
//  NewItem.m
//  CoreData
//
//  Created by Apple on 2/14/16.
//  Copyright © 2016 AMOSC. All rights reserved.
// first step: is to save to entities
// second step: is to keep when kill app ? 

#import "NewItem.h"
#import "Pic.h"
#import "PicDetails.h"

// Finally: the point is that: we can update NewItem star from the main view controller

@interface NewItem ()<UIGestureRecognizerDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate, UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UITextField *detailField;

@end

@implementation NewItem{
    UIImagePickerController *picker;
}
- (void) initPrj{

    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (!self.pic.picDetails.image){
        // update imgview
        self.imgView.image  = [UIImage imageNamed:@"peach.jpg"];
        
        // get image link to entity
        NSData*webData = UIImagePNGRepresentation(self.imgView.image);
        NSArray*path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString*documentDirectory = [path objectAtIndex:0];
        NSString *localFilePath = [documentDirectory stringByAppendingPathComponent:@"peach"];
        [webData writeToFile:localFilePath atomically:YES];
        self.pic.picDetails.image = localFilePath;
    } else{
        self.imgView.image = [UIImage imageWithContentsOfFile:self.pic.picDetails.image];
        
    }
    // add new
    
    self.titleField.text = self.textTitle;
    self.detailField.text = self.textDetails;
    
    picker = [[UIImagePickerController alloc]init];
    picker.allowsEditing= true;
      picker.delegate = self;
    
    self.titleField.delegate=self;
    self.detailField.delegate = self;
    self.titleField.tag=1;
    self.detailField.tag=2;
    
    
    if (!self.pic){
        self.pic = [Pic createEntity];
    }
    if (!self.pic.picDetails){
        self.pic.picDetails = [PicDetails createEntity];
        self.pic.picDetails.rating = [NSNumber numberWithInt:-1];
    }
    self.titleField.text = self.pic.title;
    self.detailField.text = self.pic.picDetails.details;
    
    self.rateView.rateNo = [self.pic.picDetails.rating intValue];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self initPrj];
    [self tapGesture];
    [self rightBarItem];
 
    
}
- (void)viewDidAppear:(BOOL)animated{
    
         self.rateView.maxStars = 5;
    
}
- (void) viewDidDisappear:(BOOL)animated{
    // save to entity
    [super viewDidDisappear:YES];
    self.textTitle = self.pic.title;
    self.textDetails = self.pic.picDetails.details;
    
    self.pic.picDetails.rating = [NSNumber numberWithInt:self.rateView.rateNo];

    [self saveContext];
    
}

// the point is that i need to update the rateView's rate number from old data
// but old data (Pic) save just NSNUmber: rating
// how to to update from just rating , there are certainly way!

- (void) saveContext{
    [[NSManagedObjectContext defaultContext]saveToPersistentStoreWithCompletion:^(BOOL success, NSError*error){
        if (success) {
            NSLog(@"You successfully saved the context");
        }else{
            NSLog(@"Error saving context");
        }
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    // update text to table
    if (textField.tag==1) self.pic.title = textField.text;
    if (textField.tag==2) self.pic.picDetails.details = textField.text;
    
    return YES;
}
- (void) rightBarItem{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void) doneAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
                    
- (void) tapGesture{
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImage)];
    tap.delegate = self;
    tap.numberOfTapsRequired =1;
    tap.enabled = YES;
    
    [self.imgView addGestureRecognizer:tap];
    
}
- (void) addImage{
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Choose Image" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Library Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:true completion:nil];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
               picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
     
        [self presentViewController:picker animated:true completion:nil];
        
    }]];
    
    [self presentViewController:actionSheet animated:true completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo{
    
    self.imgView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    NSData*webData = UIImagePNGRepresentation(self.imgView.image);
    NSArray*path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*documentDirectory = [path objectAtIndex:0];
    
    NSString *strName = [self genRandStringLength:6];
    
    NSString *localFilePath = [documentDirectory stringByAppendingPathComponent:strName];
    
    [webData writeToFile:localFilePath atomically:YES];
    self.pic.picDetails.image = localFilePath;
    
}
-(NSString *) genRandStringLength: (NSInteger) len {
    static NSString *letters = @" abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
