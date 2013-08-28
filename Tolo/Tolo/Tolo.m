//
//  Tolo.m
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

#import "Tolo.h"
#import <objc/runtime.h>

@interface Subscriber : NSObject
@property(nonatomic) SEL selector;
@property(nonatomic,weak) id target;
+ (Subscriber *)subscriberWithObject:(id)subscriber selector:(SEL)selector;
@end
@implementation Subscriber
+ (Subscriber *)subscriberWithObject:(id)target selector:(SEL)selector
{
    Subscriber *sub = [Subscriber new];
    sub.selector = selector;
    sub.target = target;
    
    return sub;
}
@end

@interface NSObject (PubSub)
- (NSDictionary *)selectorsWithPrefix:(NSString *)prefix withParam:(BOOL)hasParam;
@end
@implementation NSObject (PubSub)

- (NSDictionary *)selectorsWithPrefix:(NSString *)prefix withParam:(BOOL)hasParam
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    int numberOfParams = hasParam ? 1 : 0;
    static int INDEX_FIRST_PARAM = 2;
    
    u_int count;
    
    Method* methods = class_copyMethodList([self class], &count);
    
    for (int i = 0; i < count ; i++) {
        
        Method method = methods[i];
        
        const char *encoding = method_getTypeEncoding(method);
        NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:encoding];
        int parameterCount = [signature numberOfArguments];
        
        if (parameterCount - INDEX_FIRST_PARAM != numberOfParams) {
            continue;
        }
        
        SEL selector = method_getName(method);
        const char* methodName = sel_getName(selector);
        NSString *methodNameString = [NSString stringWithCString:methodName encoding:NSUTF8StringEncoding];
        
        if (![methodNameString hasPrefix:prefix]) {
            continue;
        }
        
        NSRange range = {prefix.length, methodNameString.length - prefix.length - (hasParam?1:0)};
        
        NSString *paramTypeNameString = [methodNameString substringWithRange:range];
        
        [result setObject:methodNameString forKey:paramTypeNameString];
        
    }
    free(methods);
    return result;
}
@end

@interface Tolo ()
@property (nonatomic,strong) NSMutableDictionary *observers;
@property (nonatomic,strong) NSMutableDictionary *publishers;
@end

@implementation Tolo

+ (Tolo *)sharedInstance {
    static dispatch_once_t pred;
    static Tolo *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[Tolo alloc] init];
    });
    return shared;
}

- (id)init
{
    self = [super init];
    
    self.forceMainThread = YES;
    self.publisherPrefix = @"get";
    self.observerPrefix = @"on";
    
    return self;
}

- (void) subscribe:(NSObject *)object
{
    // establish any data sources first
    
    if (!self.publishers) {
        self.publishers = [NSMutableDictionary dictionary];
    }
    
    NSDictionary *publishingObjects = [object selectorsWithPrefix:self.publisherPrefix withParam:NO];
    
    if (publishingObjects.count) {
        
        for (NSString* type in publishingObjects) {
            
            SEL selector = NSSelectorFromString([publishingObjects objectForKey:type]);
            
            [self.publishers setObject:[Subscriber subscriberWithObject:object selector:selector]
                                forKey:type];
            
            // publish to existing subscribers
            [self publish:[object performSelector:selector]];
        }
    }
    
    // register subscriptions
    
    if (!self.observers) {
        self.observers = [NSMutableDictionary dictionary];
    }
    NSDictionary *observedObjects = [object selectorsWithPrefix:self.observerPrefix withParam:YES];
    
    if (observedObjects.count) {
        
        for (NSString* type in observedObjects) {
            
            NSMutableArray *observersForType = [self.observers objectForKey:type];
            
            if (!observersForType) {
                observersForType = [NSMutableArray array];
                [self.observers setObject:observersForType forKey:type];
            }
            
            SEL selector = NSSelectorFromString([observedObjects objectForKey:type]);
            
            [observersForType addObject:[Subscriber subscriberWithObject:object selector:selector]];
            
            // publish this type to the subscriber on subscribe
            Subscriber *pub = [self.publishers objectForKey:type];
            if (pub) {
                [object performSelector:selector withObject:[pub.target performSelector:pub.selector]];
            }
        }
    }
}

- (void) unsubscribe:(NSObject *)object
{
    for (NSString *key in self.observers.allKeys) {
        
        NSMutableArray *subscribers = [self.observers objectForKey:key];
        
        for (Subscriber *subscriber in [NSArray arrayWithArray:subscribers]) {
            if (!subscriber.target || subscriber.target == object) {
                [subscribers removeObject:subscriber];
            }
        }
        
        if (!subscribers.count) {
            [self.observers removeObjectForKey:key];
        }
    }
    
    for (NSString *key in self.publishers.allKeys) {
        
        Subscriber *subscriber = (Subscriber *)[self.publishers objectForKey:key];
        
        if (!subscriber.target || subscriber.target == object) {
            [self.publishers removeObjectForKey:key];
        }
    }
}

- (void) publish:(id<NSObject>)type
{
    if (self.forceMainThread && ![[NSThread currentThread] isEqual:[NSThread mainThread]]) {
        
        [self performSelectorOnMainThread:@selector(publish:) withObject:type waitUntilDone:YES];
        
    } else {
        
        NSString *thisType = NSStringFromClass([type class]);
        
        NSMutableArray *observers = [self.observers objectForKey:thisType];
        
        for (Subscriber *subscriber in [NSArray arrayWithArray:observers]) {
            
            if (!subscriber.target) {
                [observers removeObject:subscriber];
            
            } else {
                [subscriber.target performSelector:subscriber.selector withObject:type];
            }
        }
    }
}

@end