//
//  Tolo.h
//  Tolo
//
//  Created by Ephraim Tekle on 8/23/13.
//  Copyright (c) 2013 Ephraim Tekle. All rights reserved.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2013 Ephraim Tekle
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


/**
 * Tolo is an event publish/subscribe framework designed to decouple different parts 
 * of your iOS application while still allowing them to communicate efficiently.
 *
 * Usage:
 *
 * First import Tolo.h (or <Tolo/Tolo.h> depending on how the library is added).
 * 
 * Publishing: 
 *    PUBLISH(instance_of_event_class);
 *
 *    Note: an instance of any class may publish.
 *
 * Subscribing: 
 *    SUBSCRIBE(event_class) 
 *    {
 *          // do somethign with the event
 *    }
 * 
 *    Note: an instance of any class may become a subscriber; however, in order
 *    to receive events, the instance needs to register using the macro REGISTER(). 
 *    Unregistring a subscriber or/and publisher is optional, as subscribers/publishers
 *    will be auto unregister on any next publish, subscriber, unsubscribe action.
 *
 * Producing (optional -- the initial value for an event when new subscribers are
 * register):
 *    PUBLISHER(event_class) 
 *    {
 *          return instance-of-event-class;
 *    }
 *
 *    Note: there could only be one publisher per event type. The last publisher to 
 *    register will become the publisher of that event. 
 *
 */

#import <Foundation/Foundation.h>

#define SUBSCRIBE(_event_type_) - (void) on##_event_type_:(_event_type_ *) event

#define PUBLISHER(_event_type_) - (_event_type_ *) get##_event_type_

#define REGISTER() [Tolo.sharedInstance subscribe:self]

#define UNREGISTER() [Tolo.sharedInstance unsubscribe:self]

#define PUBLISH(_value_) [Tolo.sharedInstance publish:_value_]

@interface Tolo : NSObject

@property(nonatomic) BOOL forceMainThread;

@property (nonatomic,strong) NSString *publisherPrefix;
@property (nonatomic,strong) NSString *observerPrefix;

- (void) subscribe:(NSObject *)object;
- (void) unsubscribe:(NSObject *)object;
- (void) publish:(id<NSObject>)type;

// This doesn't prevent you from creating as many instances as you like. This way, you have at least
// one shared instance that you can use right off the bat.
+ (Tolo *) sharedInstance;

@end

