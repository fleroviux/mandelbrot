.align 4
.arm
_start:
	b _copy_to_iwram
	@ TODO: header.

.org 0xE0
_copy_to_iwram:
	mov r0, #0x08000000
	mov r1, #0x03000000
	@ FIXME: make this go brr
	ldr r2, =_end
	lsr r2, #2
	orr r2, #0x80000000
	orr r2, #0x04000000
	ldr r3, =0x040000D4
	stmia r3, {r0-r2}
	ldr r0, =(main + 0x03000000)
	bx r0

main:
	@ Setup bitmap mode 4
	ldr r0, =#0x0404
	mov r1, #0x04000000
	strh r0, [r1]

	ldr r0, =(palette + 0x03000000)
	mov r1, #0x05000000
	ldr r2, =#0x80000014
	stmia r3, {r0-r2}	
	
	@ r0 = vram pointer, r1 = red
	mov r0, #0x06000000

	@ r3 = y-counter
	mov r3, #160

	@ r4 = initial x-coordinate
	ldr r4, =#-0x640

	@ r6 = cy
	ldr r6, =#-0x400
	
	.loop_y:
		@ r5 = cx = initial x-coordinate
		mov r5, r4
		@ r2 = x-counter
		mov r2, #240
		.loop_x:
			@ r7 = zx, r8 = zy
			mov r7, #0
			mov r8, #0
			
			@ r9 = zx², r10 = zy²
			mov r9, #0
			mov r10, #0

			@ r11 = max_iter
			mov r11, #20
			.loop_limes:
				@ zy = 2 * zx * zy + cy
				mul r8, r7, r8
				add r8, r6, r8, asr #9

				@ zx = zx² - zy² + cx
				sub r7, r9, r10
				add r7, r5

				@ update zx² and zy²
				mul r9, r7, r7
				asr r9, #10
				mul r10, r8, r8
				asr r10, #10

				@ check length
				add r12, r9, r10
				cmp r12, #(4 << 10)
				strgtb r11, [r0] 
				bgt .loop_limes_early_exit
				
				subs r11, #1
				bne .loop_limes
		.loop_limes_early_exit:
			add r0, #1
			add r5, #13 @ 0x800 / 160 = 12.8
			subs r2, #1
			bne .loop_x
			
		add r6, #13 @ 0x800 / 160 = 12.8
		subs r3, #1
		bne .loop_y
	b $
.align 4
palette:
	.hword 0x0000
	.hword 0x0001
	.hword 0x0002
	.hword 0x0003
	.hword 0x0004
	.hword 0x0005
	.hword 0x0006
	.hword 0x0007
	.hword 0x0008
	.hword 0x0009
	.hword 0x000A
	.hword 0x000B
	.hword 0x000C
	.hword 0x000D
	.hword 0x000E
	.hword 0x000F
	.hword 0x0010
	.hword 0x0011
	.hword 0x0012
	.hword 0x0013
	.hword 0x0014
	.hword 0x0015
	.hword 0x0016
	.hword 0x0017
	.hword 0x0018
	.hword 0x0019
	.hword 0x001A
	.hword 0x001B
	.hword 0x001C
	.hword 0x001D
	.hword 0x001E
	.hword 0x001F
_pool:
	.pool
.align 4
_end:
