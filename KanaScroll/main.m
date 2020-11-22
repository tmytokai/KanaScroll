//
//  main.m
//  KanaScroll
//
//  Created by tokai on 2019/01/13.
//  Copyright © 2019 tmytokai. All rights reserved.
//

#import <ApplicationServices/ApplicationServices.h>
#import <Foundation/NSObjCRuntime.h>

const int64_t eisukey = 102; // Eisu Key on a Japanese keyboard
const CGKeyCode kanakey = 104; // Kana key on a Japanese keyboard
int64_t scrollspeed = 3; // scroll speed (lines) default=3
bool disable_eisukey = true; // disable eisukey default=true

CGEventRef eventcallback( CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon )
{
    static bool kanamode = false;
    
    if( disable_eisukey && ( type == kCGEventKeyDown || type == kCGEventKeyUp ) ){
        CGKeyCode key = CGEventGetIntegerValueField( event, kCGKeyboardEventKeycode );
        if( key == kanakey ){
            if( kanamode ){
                CGEventSetIntegerValueField( event, kCGKeyboardEventKeycode, eisukey );
            }
            if( type == kCGEventKeyUp ){
                kanamode = !kanamode;
            }
#ifdef DEBUG
            NSLog(@"kanamode: %d\n",kanamode);
#endif
        }
    }
    else if( type == kCGEventScrollWheel ){
        if( CGEventGetIntegerValueField( event, kCGScrollWheelEventIsContinuous ) == 0 ){
            int64_t d = CGEventGetIntegerValueField( event, kCGScrollWheelEventPointDeltaAxis1 );
            int64_t d2 = (scrollspeed^(d>>63))-(d>>63);
#ifdef DEBUG
            NSLog(@"scroll: %lld -> %lld\n",d,d2);
#endif
            CGEventSetIntegerValueField( event, kCGScrollWheelEventDeltaAxis1, d2 );
        }
    }
    
    return event;
}

int main()
{
    char* e = getenv("ks_disable_eisukey");
    if(e!=NULL){
        if(strncmp(e,"true",4)!=0) disable_eisukey = false;
#ifdef DEBUG
        NSLog(@"ks_disable_eisukey: %s\n",e);
        NSLog(@"disable_eisukey: %d\n",disable_eisukey);
#endif
    }
    e = getenv("ks_scrollspeed");
    if(e!=NULL){
        scrollspeed = atoi(e);
#ifdef DEBUG
        NSLog(@"ks_scrollspeed: %s\n",e);
        NSLog(@"scrollspeed: %lld\n",scrollspeed);
#endif
    }

    CFMachPortRef tap = CGEventTapCreate( kCGSessionEventTap, kCGHeadInsertEventTap, 0,
                                (1 << kCGEventKeyDown) | (1 << kCGEventKeyUp) | (1 << kCGEventScrollWheel),
                                eventcallback, NULL );
    CFRunLoopSourceRef loop = CFMachPortCreateRunLoopSource( kCFAllocatorDefault, tap, 0 );
    
    CFRunLoopAddSource( CFRunLoopGetCurrent(), loop, kCFRunLoopCommonModes );
    CGEventTapEnable( tap, true );
    CFRunLoopRun();

    return 0;
}

