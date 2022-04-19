	export __main
;--- cfg rcc
rcc_apb2enr equ &40021018
rcc_apb1enr equ &4002101C
;---regs. timer2
tim2_cr1 equ &40000000
tim2_sr equ &40000010
tim2_psc equ &40000028
tim2_arr equ &4000002C
;---regs. portA
gpioa_crl equ &40010800
gpioa_crh equ &40010804
gpioa_idr equ &40010808
gpioa_odr equ &4001080c
;---dir. area-progr. (flash)
	area m_prg, code, readonly
__main
pk0 ldr r0,=rcc_apb2enr ;en.clk port A
	ldr r1,[r0] ;lê apb2enr
	orr r1,r1,#&4 ;bit b4=1
	str r1,[r0] ;salva apb2enr
;---timer2
	ldr r1,[r0,#4];lê apb1enr
	orr r1,r1,#&1 ;bits b0=1
	str r1,[r0,#4];salva apb1enr
;---cfg/ci PA1 output
	ldr r2,=gpioa_crl;cfg portc PA1
	ldr r3,[r2] ;
	eor r3,#&60 ;PC13 output op-dr 
	str r3,[r2]
;---ci PA1=0(valor inicial)
	mov r4,#&2
	str r4,[r2,#&c]
;timer2 cfg
	ldr r0,=tim2_cr1
	mov r3,#45983
	strh r3,[r0,#&2c] ;tim2_arr=45983
	mov r3,#&49
	str r3,[r0,#&28] ;tim_psc=&49
	ldrh r3,[r0] ;lê tim2_cr1
	orr r3,#1 ;b0=cen=1
	strh r3,[r0] ;inicia(liga)timer!!
;---ler uif(timer overflow)-RECENSEAMENTO!
pk1 ldrh r3,[r0,#&10];ler [tim2_sr(uif)]
	ands r3,r3,#&1 ;pres. uif
	beq pk1 ;uif=0?
;---
	eor r3,#&1 ;
	strh r3,[r0,#&10];uif=0
;---acender/apagar PA1
lg_dg ldr r4,[r2,#&c];ler gpioa_odr
	eor r4,#&0002
	str r4,[r2,#&c]
	b pk1
end