//
//  ViewController.m
//  HelloTolo
//
//  Created by Ephraim Tekle on 8/23/13.
//  Copyright (c) 2013 Ephraim Tekle. All rights reserved.
//

#import "ViewController.h"
#import "ProgressSubscriberView.h"
#import "ProgressGenerator.h"

@interface ViewController ()
@property(nonatomic,strong) IBOutlet UITextField *textField;
@property(nonatomic,strong) IBOutlet UILabel *label;
@property(nonatomic,strong) IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong) ProgressGenerator *progressGenerator;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:self.textField];
    
    self.progressGenerator = [ProgressGenerator new];
    
    REGISTER();
}

- (void) textDidChange
{
    EventValueChanged *value = [EventValueChanged new];
    value.value = self.textField.text;
    
    PUBLISH(value);
    
}

SUBSCRIBE(EventValueChanged)
{
    self.label.text = event.value;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [self removeProgressSubscribers:nil];
}

- (IBAction)addProgressSubscriber:(id)sender
{
    static CGFloat kHeight = 35;
    
    ProgressSubscriberView *view = [[ProgressSubscriberView alloc] initWithFrame:CGRectMake(0,
                                                                                            self.scrollView.subviews.count*kHeight,
                                                                                            self.scrollView.frame.size.width,
                                                                                            kHeight)];
    
    [self.scrollView addSubview:view];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.subviews.count*kHeight);
    
}

- (IBAction)removeProgressSubscribers:(id)sender
{
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
}

- (IBAction)hideKeyboardIfShown:(id)sender
{
    [self.textField resignFirstResponder];
}

@end
