//
//  NewItem.h
//  CoreData
//
//  Created by Apple on 2/14/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "ViewController.h"
#import "RateView.h"
#import "Pic.h"
#import "PicDetails.h"

@interface NewItem : ViewController

@property (nonatomic, strong) Pic *pic;
@property (nonatomic, assign) int position;

@property (strong, nonatomic) IBOutlet RateView *rateView;
@property (nonatomic, strong) NSString*textTitle;
@property (nonatomic, strong) NSString*textDetails;

@end
