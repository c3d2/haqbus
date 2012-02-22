/*
 * =====================================================================================
 *
 *       Filename:  haqbus.h
 *
 *    Description:  common header for all architectures and roles
 *
 *        Created:  22.02.2012 12:37:16
 *       Revision:  none
 *
 *         Author:  _john ,
 *   Organization:  c3d2 <<</>>
 *
 * =====================================================================================
 */

#include<stdint.h>

typedef enum {
	ASKSTAT    ,
	STALIVE    ,  //the plain header pkg (4 byte 0 payload)
	STALIVPL1  ,  //the pkg of len 14    (7 byte pl, 4 header, 2 check
	STALIVPL2  ,  //tha pkg of len 22    (14byte payload 4 header and 2 byte ckeck
	STALIVPL3  ,  //the pkg of len 30    (21byte payload, 4 header and 2 byte check 
	ASKSTATXXX ,
	DISCOSTART ,
	DISCOROUND1 ,
	DISCOROUND2 ,
	DISCOROUND3 ,
	REGISTERME ,
	PKGINVALID
} haq_pktype;

#define valid_haq_pktype(x) ( (x >= 0 ) && ((haq_pktype)x < PKGINVALID) )


typedef uint16_t haq_addr ;
#define haq_addr_bitmask (0x7fff)
#define haq_addr_vendormask (0x7c00)

#define valid_haq_addr (x) ( x == ((haq_addr)x

typedef union{
	uint8_t w[4];
	struct {uint8_t fb0 : 1 ;
		uint8_t type :5 ;
		uint8_t x0 : 2 ;

		uint8_t fb1 :1 ;
		uint8_t adr0: 5;
		uint8_t x2 :2 ;

		uint8_t fb2 :1 ;
		uint8_t adr1: 5;
		uint8_t x3 :2 ;

		uint8_t fb3 :1 ;
		uint8_t adr2: 5;
		uint8_t x3 :2 ;
		}p;
}framing_head

typedef struct{
	haq_pktype type;
	haq_addr address;
} deframed_head;

/**
 * return value: true if all checksums have been valid, false otherwise 
 **/
int deframe_head (framing_head in, deframed_head *out);




