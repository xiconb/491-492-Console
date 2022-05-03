pub main
  coginit(0, @entry, 0)
dat
	org	0
entry
	mov	arg01, par wz
 if_ne	jmp	#spininit
	mov	pc, $+2
	call	#LMM_CALL_FROM_COG
	long	@@@_main
cogexit
	cogid	arg01
	cogstop	arg01
spininit
	mov	sp, arg01
	rdlong	objptr, sp
	add	sp, #4
	rdlong	pc, sp
	wrlong	ptr_hubexit_, sp
	add	sp, #4
	rdlong	arg01, sp
	add	sp, #4
	rdlong	arg02, sp
	add	sp, #4
	rdlong	arg03, sp
	add	sp, #4
	rdlong	arg04, sp
	sub	sp, #12
	jmp	#LMM_LOOP
LMM_LOOP
    rdlong LMM_i1, pc
    add    pc, #4
LMM_i1
    nop
    rdlong LMM_i2, pc
    add    pc, #4
LMM_i2
    nop
    rdlong LMM_i3, pc
    add    pc, #4
LMM_i3
    nop
    rdlong LMM_i4, pc
    add    pc, #4
LMM_i4
    nop
    rdlong LMM_i5, pc
    add    pc, #4
LMM_i5
    nop
    rdlong LMM_i6, pc
    add    pc, #4
LMM_i6
    nop
    rdlong LMM_i7, pc
    add    pc, #4
LMM_i7
    nop
    rdlong LMM_i8, pc
    add    pc, #4
LMM_i8
    nop
LMM_jmptop
    jmp    #LMM_LOOP
pc
    long @@@hubentry
lr
    long 0
hubretptr
    long @@@hub_ret_to_cog
LMM_NEW_PC
    long   0
    ' fall through
LMM_CALL
    rdlong LMM_NEW_PC, pc
    add    pc, #4
LMM_CALL_PTR
    wrlong pc, sp
    add    sp, #4
LMM_JUMP_PTR
    mov    pc, LMM_NEW_PC
    jmp    #LMM_LOOP
LMM_JUMP
    rdlong pc, pc
    jmp    #LMM_LOOP
LMM_RET
    sub    sp, #4
    rdlong pc, sp
    jmp    #LMM_LOOP
LMM_CALL_FROM_COG
    wrlong  hubretptr, sp
    add     sp, #4
    jmp  #LMM_LOOP
LMM_CALL_FROM_COG_ret
    ret
    
LMM_CALL_ret
LMM_CALL_PTR_ret
LMM_JUMP_ret
LMM_JUMP_PTR_ret
LMM_RET_ret
LMM_RA
    long	0
    
LMM_FCACHE_LOAD
    rdlong FCOUNT_, pc
    add    pc, #4
    mov    ADDR_, pc
    sub    LMM_ADDR_, pc
    tjz    LMM_ADDR_, #a_fcachegoaddpc
    movd   a_fcacheldlp, #LMM_FCACHE_START
    shr    FCOUNT_, #2
a_fcacheldlp
    rdlong 0-0, pc
    add    pc, #4
    add    a_fcacheldlp,inc_dest1
    djnz   FCOUNT_,#a_fcacheldlp
    '' add in a JMP back out of LMM
    ror    a_fcacheldlp, #9
    movd   a_fcachecopyjmp, a_fcacheldlp
    rol    a_fcacheldlp, #9
a_fcachecopyjmp
    mov    0-0, LMM_jmptop
a_fcachego
    mov    LMM_ADDR_, ADDR_
    jmpret LMM_RETREG,#LMM_FCACHE_START
a_fcachegoaddpc
    add    pc, FCOUNT_
    jmp    #a_fcachego
LMM_FCACHE_LOAD_ret
    ret
inc_dest1
    long (1<<9)
LMM_LEAVE_CODE
    jmp LMM_RETREG
LMM_ADDR_
    long 0
ADDR_
    long 0
FCOUNT_
    long 0
COUNT_
    long 0
prcnt_
    long 0
pushregs_
      movd  :write, #local01
      mov   prcnt_, COUNT_ wz
  if_z jmp  #pushregs_done_
:write
      wrlong 0-0, sp
      add    :write, inc_dest1
      add    sp, #4
      djnz   prcnt_, #:write
pushregs_done_
      wrlong COUNT_, sp
      add    sp, #4
      wrlong fp, sp
      add    sp, #4
      mov    fp, sp
pushregs__ret
      ret
popregs_
      sub   sp, #4
      rdlong fp, sp
      sub   sp, #4
      rdlong COUNT_, sp wz
  if_z jmp  #popregs__ret
      add   COUNT_, #local01
      movd  :read, COUNT_
      sub   COUNT_, #local01
:loop
      sub    :read, inc_dest1
      sub    sp, #4
:read
      rdlong 0-0, sp
      djnz   COUNT_, #:loop
popregs__ret
      ret

multiply_
       mov    itmp2_, muldiva_
       xor    itmp2_, muldivb_
       abs    muldiva_, muldiva_
       abs    muldivb_, muldivb_
       jmp    #do_multiply_
unsmultiply_
       mov    itmp2_, #0
do_multiply_
	mov    result1, #0
mul_lp_
	shr    muldivb_, #1 wc,wz
 if_c	add    result1, muldiva_
	shl    muldiva_, #1
 if_ne	jmp    #mul_lp_
       shr    itmp2_, #31 wz
       negnz  muldiva_, result1
multiply__ret
unsmultiply__ret
	ret
' code originally from spin interpreter, modified slightly

unsdivide_
       mov     itmp2_,#0
       jmp     #udiv__

divide_
       abs     muldiva_,muldiva_     wc       'abs(x)
       muxc    itmp2_,divide_haxx_            'store sign of x (mov x,#1 has bits 0 and 31 set)
       abs     muldivb_,muldivb_     wc,wz    'abs(y)
 if_z  jmp     #divbyzero__
 if_c  xor     itmp2_,#1                      'store sign of y
udiv__
divide_haxx_
        mov     itmp1_,#1                    'unsigned divide (bit 0 is discarded)
        mov     DIVCNT,#32
mdiv__
        shr     muldivb_,#1        wc,wz
        rcr     itmp1_,#1
 if_nz   djnz    DIVCNT,#mdiv__
mdiv2__
        cmpsub  muldiva_,itmp1_        wc
        rcl     muldivb_,#1
        shr     itmp1_,#1
        djnz    DIVCNT,#mdiv2__
        shr     itmp2_,#31       wc,wz    'restore sign
        negnz   muldiva_,muldiva_         'remainder
        negc    muldivb_,muldivb_ wz      'division result
divbyzero__
divide__ret
unsdivide__ret
	ret
DIVCNT
	long	0

fp
	long	0
imm_1000000_
	long	1000000
imm_1000_
	long	1000
imm_1032_
	long	1032
imm_20480_
	long	20480
imm_32768_
	long	32768
imm_4294967295_
	long	-1
imm_6250000_
	long	6250000
itmp1_
	long	0
itmp2_
	long	0
objptr
	long	@@@objmem
ptr___system__dat__
	long	@@@__system__dat_
ptr_hubexit_
	long	@@@hubexit
result1
	long	0
sp
	long	@@@stackspace
COG_BSS_START
	fit	496
hub_ret_to_cog
	jmp	#LMM_CALL_FROM_COG_ret
hubentry

_set_directions
	cmps	arg01, arg02 wc,wz
 if_b	mov	_var01, arg02
 if_b	mov	arg02, arg01
 if_b	mov	arg01, _var01
	mov	_var02, #0
	cmps	arg02, #31 wc,wz
 if_a	sub	arg02, #32
 if_a	sub	arg01, #32
 if_a	neg	_var02, #1
	neg	_var03, #1
	mov	_var04, arg01
	sub	_var04, arg02
	mov	_var05, #31
	sub	_var05, _var04
	shl	_var03, _var05
	mov	_var05, #31
	sub	_var05, arg01
	shr	_var03, _var05
	xor	_var03, imm_4294967295_
	shl	arg03, arg02
	cmp	_var02, imm_4294967295_ wz
 if_ne	add	pc, #4*(LR__0001 - ($+1))
	mov	_var06, dirb
	and	_var06, _var03
	or	_var06, arg03
	mov	dirb, _var06
	add	pc, #4*(LR__0002 - ($+1))
LR__0001
	mov	_var06, dira
	and	_var06, _var03
	or	_var06, arg03
	mov	dira, _var06
LR__0002
_set_directions_ret
	call	#LMM_RET

_wait
	rdlong	result1, #0
	mov	muldiva_, result1
	mov	muldivb_, imm_1000_
	call	#unsdivide_
	mov	muldiva_, muldivb_
	mov	muldivb_, arg01
	call	#unsmultiply_
	add	muldiva_, cnt
	waitcnt	muldiva_, #0
_wait_ret
	call	#LMM_RET

_command
	mov	COUNT_, #2
	call	#pushregs_
	or	dira, #1
	andn	outa, #1
	or	dira, #4
	andn	outa, #4
	or	dira, #8
	andn	outa, #8
	or	outa, #8
	andn	outa, #8
	mov	local01, #0
	call	#LMM_FCACHE_LOAD
	long	(@@@LR__0004-@@@LR__0003)
'     _pinl( 0 ) ;
'     _pinl( 2 ) ;
'     _pinl( 3 ) ;
'     _pinh( 3 ) ;
'     _pinl( 3 ) ;
' 
'     for(int i=0; i < 8; i++) {
LR__0003
	cmps	local01, #8 wc,wz
 if_ae	jmp	#LMM_FCACHE_START + (LR__0005 - LR__0003)
	mov	local02, arg01
	and	local02, #255
	and	local02, #128
	cmp	local02, #128 wz
 if_e	or	dira, #4
 if_e	or	outa, #4
 if_ne	or	dira, #4
 if_ne	andn	outa, #4
	and	arg01, #255
	shl	arg01, #1
	or	dira, #8
	andn	outa, #8
	or	outa, #8
	andn	outa, #8
	add	local01, #1
	jmp	#LMM_FCACHE_START + (LR__0003 - LR__0003)
LR__0004
LR__0005
	or	dira, #1
	or	outa, #1
	mov	sp, fp
	call	#popregs_
_command_ret
	call	#LMM_RET

_data
	mov	COUNT_, #2
	call	#pushregs_
	or	dira, #1
	andn	outa, #1
	or	dira, #4
	or	outa, #4
	or	dira, #8
	andn	outa, #8
	or	outa, #8
	andn	outa, #8
	mov	local01, #0
	call	#LMM_FCACHE_LOAD
	long	(@@@LR__0007-@@@LR__0006)
'     _pinl( 0 ) ;
'     _pinh( 2 ) ;
'     _pinl( 3 ) ;
'     _pinh( 3 ) ;
'     _pinl( 3 ) ;
' 
'     for(int i=0; i < 8; i++) {
LR__0006
	cmps	local01, #8 wc,wz
 if_ae	jmp	#LMM_FCACHE_START + (LR__0008 - LR__0006)
	mov	local02, arg01
	and	local02, #255
	and	local02, #128
	cmp	local02, #128 wz
 if_e	or	dira, #4
 if_e	or	outa, #4
 if_ne	or	dira, #4
 if_ne	andn	outa, #4
	and	arg01, #255
	shl	arg01, #1
	or	dira, #8
	andn	outa, #8
	or	outa, #8
	andn	outa, #8
	add	local01, #1
	jmp	#LMM_FCACHE_START + (LR__0006 - LR__0006)
LR__0007
LR__0008
	or	dira, #1
	or	outa, #1
	mov	sp, fp
	call	#popregs_
_data_ret
	call	#LMM_RET

_main
	mov	COUNT_, #1
	call	#pushregs_
	mov	arg01, imm_1032_
	mov	arg02, imm_6250000_
	call	#LMM_CALL
	long	@@@__system___clkset
	or	dira, imm_32768_
	or	outa, imm_32768_
	mov	arg01, #10
	call	#LMM_CALL
	long	@@@_wait
	or	dira, imm_32768_
	andn	outa, imm_32768_
	mov	arg01, #0
	mov	arg02, #3
	mov	arg03, #15
	call	#LMM_CALL
	long	@@@_set_directions
	or	dira, #4
	or	outa, #4
	or	dira, #8
	or	outa, #8
	or	dira, #2
	andn	outa, #2
	mov	arg01, #10
	call	#LMM_CALL
	long	@@@_wait
	or	dira, #2
	or	outa, #2
	mov	arg01, #10
	call	#LMM_CALL
	long	@@@_wait
	mov	arg01, #17
	call	#LMM_CALL
	long	@@@_command
	mov	arg01, #10
	call	#LMM_CALL
	long	@@@_wait
	mov	arg01, #40
	call	#LMM_CALL
	long	@@@_command
	mov	arg01, #38
	call	#LMM_CALL
	long	@@@_command
	mov	arg01, #4
	call	#LMM_CALL
	long	@@@_data
	mov	arg01, #177
	call	#LMM_CALL
	long	@@@_command
	mov	arg01, #10
	call	#LMM_CALL
	long	@@@_data
	mov	arg01, #20
	call	#LMM_CALL
	long	@@@_data
	mov	arg01, #192
	call	#LMM_CALL
	long	@@@_command
	mov	arg01, #10
	call	#LMM_CALL
	long	@@@_data
	mov	arg01, #0
	call	#LMM_CALL
	long	@@@_data
	mov	arg01, #193
	call	#LMM_CALL
	long	@@@_command
	mov	arg01, #2
	call	#LMM_CALL
	long	@@@_data
	mov	arg01, #197
	call	#LMM_CALL
	long	@@@_command
	mov	arg01, #47
	call	#LMM_CALL
	long	@@@_data
	mov	arg01, #62
	call	#LMM_CALL
	long	@@@_data
	mov	arg01, #199
	call	#LMM_CALL
	long	@@@_command
	mov	arg01, #64
	call	#LMM_CALL
	long	@@@_data
	mov	arg01, #42
	call	#LMM_CALL
	long	@@@_command
	mov	arg01, #0
	call	#LMM_CALL
	long	@@@_data
	mov	arg01, #0
	call	#LMM_CALL
	long	@@@_data
	mov	arg01, #0
	call	#LMM_CALL
	long	@@@_data
	mov	arg01, #127
	call	#LMM_CALL
	long	@@@_data
	mov	arg01, #43
	call	#LMM_CALL
	long	@@@_command
	mov	arg01, #0
	call	#LMM_CALL
	long	@@@_data
	mov	arg01, #0
	call	#LMM_CALL
	long	@@@_data
	mov	arg01, #0
	call	#LMM_CALL
	long	@@@_data
	mov	arg01, #159
	call	#LMM_CALL
	long	@@@_data
	mov	arg01, #54
	call	#LMM_CALL
	long	@@@_command
	mov	arg01, #192
	call	#LMM_CALL
	long	@@@_data
	mov	arg01, #58
	call	#LMM_CALL
	long	@@@_command
	mov	arg01, #6
	call	#LMM_CALL
	long	@@@_data
	mov	arg01, #41
	call	#LMM_CALL
	long	@@@_command
	mov	arg01, #10
	call	#LMM_CALL
	long	@@@_wait
	mov	arg01, #44
	call	#LMM_CALL
	long	@@@_command
'     _clkset(XTAL1 + PLL16X, 6250000) ;
'     _pinh( 15 ) ;
'     wait(10);
'     _pinl( 15 ) ;
' 
' 
'     set_directions(0, 3, 0b1111);
' 
'     _pinh( 2 ) ;
'     _pinh( 3 ) ;
'     _pinl( 1 ) ;
'     wait(10);
'     _pinh( 1 ) ;
'     wait(10);
'     command(0x11);
'     wait(10);
'     command(0x28);
'     command(0x26);
'     data(0x04);
' 
'     command(0xb1);
'     data(0x0a);
'     data(0x14);
' 
'     command(0xc0);
'     data(0x0a);
'     data(0x00);
' 
'     command(0xc1);
'     data(0x02);
' 
'     command(0xc5);
'     data(0x2f);
'     data(0x3e);
' 
'     command(0xc7);
'     data(0x40);
' 
'     command(0x2a);
'     data(0x00);
' 
'     data(0x00);
'     data(0x00);
' 
'     data(0x7f);
'     command(0x2b);
'     data(0x00);
'     data(0x00);
'     data(0x00);
'     data(0x9f);
' 
'     command(0x36);
'     data(0xc0);
'     command(0x3a);
'     data(0x06);
' 
'     command(0x29);
'     wait(10);
' 
'     command(0x2C);
'     while(1){
LR__0009
' 
'     	for(i = 0; i < 128*160; i++){
	mov	local01, #0
LR__0010
	cmps	local01, imm_20480_ wc,wz
 if_ae	add	pc, #4*(LR__0011 - ($+1))
	mov	arg01, #255
	call	#LMM_CALL
	long	@@@_data
	mov	arg01, #0
	call	#LMM_CALL
	long	@@@_data
	mov	arg01, #0
	call	#LMM_CALL
	long	@@@_data
	add	local01, #1
	sub	pc, #4*(($+1) - LR__0010)
LR__0011
	mov	arg01, imm_1000_
	call	#LMM_CALL
	long	@@@_wait
'         	    data(0xFF);
'             	data(0x00);
'             	data(0x00);
'  		}
'  		wait(1000);
'  		for(i = 0; i < 128*160; i++){
	mov	local01, #0
LR__0012
	cmps	local01, imm_20480_ wc,wz
 if_ae	add	pc, #4*(LR__0013 - ($+1))
	mov	arg01, #0
	call	#LMM_CALL
	long	@@@_data
	mov	arg01, #255
	call	#LMM_CALL
	long	@@@_data
	mov	arg01, #0
	call	#LMM_CALL
	long	@@@_data
	add	local01, #1
	sub	pc, #4*(($+1) - LR__0012)
LR__0013
	mov	arg01, imm_1000_
	call	#LMM_CALL
	long	@@@_wait
	sub	pc, #4*(($+1) - LR__0009)
	mov	sp, fp
	call	#popregs_
_main_ret
	call	#LMM_RET
hubexit
	jmp	#cogexit

__system___clkset
	wrlong	arg02, #0
	wrlong	arg01, #4
	mov	muldiva_, arg02
	mov	muldivb_, imm_1000_
	call	#divide_
	add	ptr___system__dat__, #28
	wrlong	muldivb_, ptr___system__dat__
	sub	ptr___system__dat__, #28
	mov	muldiva_, arg02
	mov	muldivb_, imm_1000000_
	call	#divide_
	add	ptr___system__dat__, #32
	wrlong	muldivb_, ptr___system__dat__
	sub	ptr___system__dat__, #32
	clkset	arg01
__system___clkset_ret
	call	#LMM_RET
	long
__system__dat_
	byte	$00, $00, $00, $00, $f0, $09, $bc, $0a, $00, $00, $68, $5c, $01, $08, $fc, $0c
	byte	$03, $08, $7c, $0c, $00, $00, $00, $00, $03, $00, $00, $00, $00, $00, $00, $00
	byte	$00, $00, $00, $00, $00, $00, $00, $00
objmem
	long	0[0]
stackspace
	long	0[1]
	org	COG_BSS_START
_var01
	res	1
_var02
	res	1
_var03
	res	1
_var04
	res	1
_var05
	res	1
_var06
	res	1
arg01
	res	1
arg02
	res	1
arg03
	res	1
arg04
	res	1
local01
	res	1
local02
	res	1
muldiva_
	res	1
muldivb_
	res	1
LMM_RETREG
	res	1
LMM_FCACHE_START
	res	97
LMM_FCACHE_END
	fit	496
