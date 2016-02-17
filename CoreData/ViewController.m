//
//  ViewController.m
//  CoreData
//
//  Created by Apple on 2/13/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "ViewController.h"
#import "NewItem.h"
#import "RateView.h"
#import "Pic.h"
#import "PicDetails.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController{
    NSMutableArray *dataArray;
}
- (void) initPrj{ 
        self.edgesForExtendedLayout = UIRectEdgeNone;
    dataArray = [NSMutableArray new];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self initPrj];
    [self addRightButton];
}
- (void) viewWillAppear:(BOOL)animated{
    
    dataArray = [[Pic findAll]mutableCopy];
    NSSortDescriptor*sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"title" ascending:YES];
    NSArray* sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray  = [dataArray sortedArrayUsingDescriptors:sortDescriptors];
    dataArray = [sortedArray mutableCopy];
    
    
    [self.tableView reloadData];
    
    
}
- (void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
}
- (void) addRightButton{
    UIBarButtonItem*rightButton = [[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addItem)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
}
- (void) addItem{
    [CATransaction begin];
    
    NewItem*newItem = [NewItem new];
    newItem.position = dataArray.count;
    [self.navigationController pushViewController:newItem animated:YES ];
  

    [CATransaction setCompletionBlock:^{
//           [dataArray addObject:newItem];
//        [self.tableView reloadData];
    }];

    [CATransaction commit];
    // get the new value to entities
    // get entities value to the table View 
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Pic *item = dataArray[indexPath.row];
    int value = (int) item.picDetails.rating;
    
    UILabel*titleLabel = (UILabel*)[cell viewWithTag:102];
    titleLabel.text = item.title;
    
    // update RateView
    RateView *rateView = (UIView*)[cell viewWithTag:103];
    [rateView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    float starSize = rateView.frame.size.width/5;
    starSize = MIN(starSize, rateView.frame.size.height);
    
    float x = 0;
    float y = 0;
    
    
    for (int i=0; i<5; i++){
        UIImageView *newImgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, starSize, starSize)];
        
        if (i <= [item.picDetails.rating intValue] ){

            newImgView.image = [UIImage imageNamed:@"kermit_full.png"];
            
        }else{
            newImgView.image = [UIImage imageNamed:@"kermit_empty.png"];
        }
        
        [rateView addSubview:newImgView];
        
        // update x y
        x = x+ starSize;
    }
    UIImageView*imgView = (UIImageView*)[cell viewWithTag:100];
    
    UIImage *photo = [UIImage imageWithContentsOfFile:item.picDetails.image];
    imgView.image = photo;
    
  //  NSLog(@"imgPath: %@",item.picDetails.image);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete){
        
        Pic *picToRemove = dataArray[indexPath.row];
        [picToRemove deleteEntity];
        [self saveContext];
        
        [dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];
        
    }
    
    [tableView endUpdates];
    
}
- (void) saveContext{
    [[NSManagedObjectContext defaultContext]saveToPersistentStoreAndWait];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
        [CATransaction begin];
// the different among "adding new" is that here there is already the "rating" 
    
     Pic *item = dataArray[indexPath.row];
    NewItem*newItem = [NewItem new];
    newItem.pic = item;
    newItem.rateView = [RateView new];


    [self.navigationController pushViewController:newItem animated:true];
    
    [CATransaction setCompletionBlock:^{
        
        dataArray[indexPath.row] = newItem.pic;
        [tableView reloadData];
    }];
    
    [CATransaction commit];
    
}


@end
