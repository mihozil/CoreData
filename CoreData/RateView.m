//
//  RateView.m
//  CoreData
//
//  Created by Apple on 2/16/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "RateView.h"

@implementation RateView{
    float starSize;
}
- (void) baseInit{
    
    self.imgViews = [NSMutableArray new];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
        tap.numberOfTapsRequired = 1;
        tap.enabled = true;
    
    
    [self addGestureRecognizer:tap];

}
- (void) onTap:(UITapGestureRecognizer*)tap{
    CGPoint tapPoint = [tap locationInView:self];
    float xPosition = tapPoint.x;
    
    for (int i=0; i<self.maxStars; i++){
        UIImageView*imgView = self.imgViews[i];
        if (imgView.frame.origin.x<=xPosition){
            imgView.image = [UIImage imageNamed:@"kermit_full.png"];
            self.rateNo = i;
        }else{
            imgView.image = [UIImage imageNamed:@"kermit_empty.png"];
        }
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self baseInit];
    }
    return  self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super initWithCoder:aDecoder]){
        [self baseInit];
    }
    return self;
}

- (void)setMaxStars:(int)maxStars{
    
    _maxStars = maxStars;
    
    [self setStarsView];
}
- (void) setStarsView{

    starSize = self.frame.size.width/self.maxStars;
    starSize = MIN(starSize, self.frame.size.height);
    
    float x=0;
    float y=0;

    for (int i =0; i<self.maxStars; i++) {
        
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, starSize, starSize)];
        
        if (i<=self.rateNo){
            imgView.image = [UIImage imageNamed:@"kermit_full.png"];
        }else{
            imgView.image = [UIImage imageNamed:@"kermit_empty.png"];

        }
                      [self addSubview:imgView];
            [self.imgViews addObject:imgView];
            
            // update x y
            x = x+starSize;
    }
    
}
@end
