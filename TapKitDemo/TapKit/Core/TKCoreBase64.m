//
//  TKCoreBase64.m
//  TapKit
//
//  Created by Wu Kevin on 4/27/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import "TKCoreBase64.h"



static const char base64EncodingTable[65] = {
  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
  'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
  'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
  'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
  '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/', '\0'
};

static const short base64DecodingTable[256] = {
  -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
  -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
  -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
  52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
  -2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
  15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
  -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
  41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
  -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
  -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
  -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
  -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
  -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
  -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
  -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
  -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};


#pragma mark - Base64 encoding

NSString *TKEncodeBase64(NSData *data)
{
  // Ensure we actually have data
  if ( [data length] <= 0 ) {
    return @"";
  }
  
  size_t length = [data length];
  const unsigned char *bytes = [data bytes];
  
  // Setup the String-based result placeholder and pointer within that placeholder
  char *result = (char *)calloc(((length+2)/3)*4, sizeof(char));
  char *pointer = result;
  
  // Iterate through everything
  while ( length > 2 ) { // Keep going until we have less than 24 bits
    *pointer++ = base64EncodingTable[bytes[0] >> 2];
    *pointer++ = base64EncodingTable[((bytes[0] & 0x03) << 4) + (bytes[1] >> 4)];
    *pointer++ = base64EncodingTable[((bytes[1] & 0x0f) << 2) + (bytes[2] >> 6)];
    *pointer++ = base64EncodingTable[bytes[2] & 0x3f];
    
    // We just handled 3 octets (24 bits) of data
    bytes += 3;
    length -= 3;
  }
  
  // Now deal with the tail end of things
  if ( length != 0 ) {
    *pointer++ = base64EncodingTable[bytes[0] >> 2];
    if ( length > 1 ) {
      *pointer++ = base64EncodingTable[((bytes[0] & 0x03) << 4) + (bytes[1] >> 4)];
      *pointer++ = base64EncodingTable[(bytes[1] & 0x0f) << 2];
      *pointer++ = '=';
    } else {
      *pointer++ = base64EncodingTable[(bytes[0] & 0x03) << 4];
      *pointer++ = '=';
      *pointer++ = '=';
    }
  }
  
  return [[NSString alloc] initWithBytesNoCopy:result
                                        length:pointer - result
                                      encoding:NSASCIIStringEncoding
                                  freeWhenDone:YES];
}

NSData *TKDecodeBase64(NSString *string)
{
  const char *pointer = [string cStringUsingEncoding:NSASCIIStringEncoding];
  if ( pointer == NULL ) {
    return nil;
  }
  
  size_t length = strlen(pointer);
  
  unsigned char *result = calloc(length, sizeof(unsigned char));
  
  int current;
  int i = 0;
  int j = 0;
  int k;
  
  // Run through the whole string, converting as we go
  while ( ((current = *pointer++) != '\0') && (length-- > 0) ) {
    if ( current == '=' ) {
      if ( (*pointer != '=') && ((i % 4) == 1) ) {// || (length > 0)) {
        // The padding character is invalid at this point, so this entire string is invalid
        free(result);
        return nil;
      }
      continue;
    }
    
    current = base64DecodingTable[current];
    if ( current == -1 ) {
      // We're at a whitespace, simply skip over
      continue;
    } else if ( current == -2 ) {
      // We're at an invalid character
      free(result);
      return nil;
    }
    
    switch ( i % 4 ) {
      case 0:
        result[j] = current << 2;
        break;
        
      case 1:
        result[j++] |= current >> 4;
        result[j] = (current & 0x0f) << 4;
        break;
        
      case 2:
        result[j++] |= current >>2;
        result[j] = (current & 0x03) << 6;
        break;
        
      case 3:
        result[j++] |= current;
        break;
    }
    i++;
  }
  
  // Mop things up if we ended on a boundary
  k = j;
  if ( current == '=' ) {
    switch ( i % 4 ) {
      case 1:
        // Invalid state
        free(result);
        return nil;
        
      case 2:
        k++;
        // Flow through
      case 3:
        result[k] = 0;
    }
  }
  
  // Cleanup and setup the return NSData
  return [[NSData alloc] initWithBytesNoCopy:result length:j freeWhenDone:YES];
}
