//
//  ProgressSubscriberView.m
//  HelloTolo
//
//  Created by Ephraim Tekle on 8/23/13.
//  Copyright (c) 2013 Ephraim Tekle. All rights reserved.
//

#import "ProgressSubscriberView.h"

@interface ProgressSubscriberView ()
@property(nonatomic,strong) UILabel *label;
@property(nonatomic,strong) UIProgressView *progressView;
@end

@implementation ProgressSubscriberView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, frame.size.height)];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor blackColor];
        
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(45, (frame.size.height-5)/2., frame.size.width-45, 5)];
        self.progressView.progress = 0;
        
        [self addSubview:self.label];
        [self addSubview:self.progressView];
        
        REGISTER();
        
    }
    return self;
}

SUBSCRIBE(EventProgressUpdated)
{
    self.progressView.progress = event.progress;
    self.label.text = [NSString stringWithFormat:@"%0.2f",event.progress];
}

- (void) dealloc
{
    UNREGISTER();
}

@end
