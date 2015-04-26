//
//  MercuryBroadcastManager.m
//  TRIOS-MOBILE-DEMO-2
//
//  Created by stephen eshelman on 4/19/15.
//  Copyright (c) 2015 objectthink.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MercuryBroadcastManager.h"

@implementation MercuryBroadcastManager
{
   GCDAsyncUdpSocket* _udpSocket;
   void (^_startCompletion)();
}

-(void)start:(void (^)())onCompletion
{
   NSError* error;
   
   _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
   [_udpSocket bindToPort:0 error:&error];
   [_udpSocket beginReceiving:&error];
   
   [_udpSocket joinMulticastGroup:@"255.255.255.255" error:&error];
   
   NSData *data = [[NSString stringWithFormat:@"TARGET InstrumentType=MercuryDSC"] dataUsingEncoding:NSUTF8StringEncoding];
   
   _startCompletion = onCompletion;
   
   [_udpSocket sendData:data toHost:@"255.255.255.255" port:50500 withTimeout:-1 tag:1];
}

/**
 * By design, UDP is a connectionless protocol, and connecting is not needed.
 * However, you may optionally choose to connect to a particular host for reasons
 * outlined in the documentation for the various connect methods listed above.
 *
 * This method is called if one of the connect methods are invoked, and the connection is successful.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address
{
   NSLog(@"didConnectToAddress");
}

/**
 * By design, UDP is a connectionless protocol, and connecting is not needed.
 * However, you may optionally choose to connect to a particular host for reasons
 * outlined in the documentation for the various connect methods listed above.
 *
 * This method is called if one of the connect methods are invoked, and the connection fails.
 * This may happen, for example, if a domain name is given for the host and the domain name is unable to be resolved.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error
{
   NSLog(@"(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error");
}

/**
 * Called when the datagram with the given tag has been sent.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
   NSLog(@"(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag");
}

/**
 * Called if an error occurs while trying to send a datagram.
 * This could be due to a timeout, or something more serious such as the data being too large to fit in a sigle packet.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
   NSLog(@"(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error");
}

/**
 * Called when the socket has received the requested datagram.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock
   didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
   NSLog(@"didReceiveData");
   
   _startCompletion();
   
   const char* bs = [data bytes];
   char b = bs[0];
   b = bs[1];
   b = bs[2];
}

/**
 * Called when the socket is closed.
 **/
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
   NSLog(@"udpSocketDidClose");
}

@end
