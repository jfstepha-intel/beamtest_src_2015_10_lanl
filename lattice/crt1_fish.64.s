###################################################################
# crt1_64.s          : C runtime for Em64t platform.
# last modified by   : mrajagop
# date               : June 05 2006.
###################################################################
        .text
        .globl  _start

        # This code takes place of the OS and loader which would normally have
        # everything set up nicely for a unix process.  Since the x86 does not
        # boot up ready to run unix processes, we have to set up the segments
        # to make it look like we have a flat addressing space in 32bit mode.
        # This means we have to set up GDTs and get into protected mode.

        # Note that the x86 boots up to address FFFFFFF0, so we must rely on
        # some method of getting to location 0 (here).  Currently, we modify
        # the final object file to add a far jump from the boot vector to
        # this startup code.  All that is needed the following byte sequence
        # starting at location FFFFFFF0: EA 00 00 00 00 00 00 00

        # The override prefixes which are added before all of the
        # instructions in this section of code are due to the fact that the
        # unix assembler assumes it is assembling 32bit code, while the x86
        # processor boots up in 16 bit mode.

        .code16
        .align 1
_start:
        lgdt GDT
        lidt IDT
        cli
        mov  %cr0, %eax
        andl $0x9FFFFFFF, %eax
        orl  $0x00000001, %eax
        mov  %eax, %cr0

        .byte   0x66                    # Long jump to load CS
        .byte   0xEA                    # afterwards, we'll be in 32bit
        .4byte  protected_mode          # protected mode.
        .2byte  0x08                    # Selector 0x08 is our code segment

        # If we have gotten this far, we are in 32bit protected mode.
        # We still have to set up the segment registers (unix processes
        # never modify them) to access a flat address space.  Since unix
        # processes don't care where the stack is located w.r.t. the other
        # data, we will put it in it's own separate address space to avoid
        # writing over data.
        #
        # Note that at this point, CS is already loaded with selector 0x08.
        # Base = 0, Lim = 0ffffff

        .code32
protected_mode:
        # Now, lets set up 64-bit mode
        #       1. Strt with paging enabled -- CRO.PE & CR0.PG = 1
        #       Paging is enabled already so I'm not going to restart it !!!

        #       2. Disable paging           -- CR0.PG = 0
        mov %cr0, %eax
        btr $31, %eax
        mov %eax, %cr0

        #       3. Enable PAE               -- CR4.PAE = 1
        mov %cr4, %eax
        bts $5, %eax
        mov %eax, %cr4

        #       4. Load CR3<- with level 4 page map table !!!
        #       At the moment I'm using PML=PDPT
        mov $pagedir, %eax
        mov %eax, %cr3

        #       5. Enable IA-32e: EFER.LME = 1
        movl    $0xc0000080, %ecx  # set EFER.LME should switch to intel64
        rdmsr
        bts     $8, %eax
        wrmsr

         #      #       5.5 Digressing, enable page size extension well...
        #mov    %cr4, %eax
        #bts    $4,%eax
        #mov    %eax, %cr4

        #       6. Enable Paging: CR0.PG = 1, EFER.LMA = 1
        mov %cr0, %eax
        btsl $31,%eax
        mov  %eax, %cr0

         .byte   0xEA                   # after this long jump we should be in 64bit mode
        .4byte  long_mode               # protected mode.
        .2byte  0x10                    # Selector 0x10 is our 64bit code segment

        .code64
long_mode:
        mov     %cr4, %rax      # cr4 osfxsr=1
        or      $0x0200,%rax
        and     $0x07ff,%rax
        mov     %rax, %cr4

        mov     %cr4, %rax      # cr4 osxmmexcpt=1
        or      $0x0400,%rax
        and     $0x07ff,%rax
        mov     %rax, %cr4

        mov     %cr0, %rax      # cr0 nw=1
        or      $0x0, %eax
        and     $0xdfffffff, %eax
        mov     %rax, %cr0

        mov     %cr0, %rax      # cr0 cd=1
        or      $0x0, %eax
        and     $0xbfffffff, %eax
        mov     %rax, %cr0

                                        # Setup MTRR
        mov     $0x800, %eax            # Set IA32_MTRR_DEF_TYPE to UC
        xor     %edx, %edx
        mov     $0x2ff, %ecx
        wrmsr
        mov     $0x6, %eax              # Set PhysBase to 0x0, WB
        xor     %edx, %edx
        mov     $0x200, %ecx
        wrmsr                           # Set PhysMask to 0xf80000000, enabled
        mov     $0x80000800, %eax
        mov     $0xf, %edx
        mov     $0x201, %ecx
        wrmsr

        mov     $0x18, %ax              # Set up the data segment pointers
        mov     %ax, %ds                # to segment selector 0x18
        mov     %ax, %es                # Base = 0, Lim = 1ffffff
        mov     %ax, %fs
        mov     %ax, %ss

        mov     $-0x20000, %rax         # Ensure we have separate stack for
        lock    xadd %rax, stack        # each thread
        mov     %rax, %rsp
        mov     %rsp, %rbp


        fninit                          # Init FP state
        fldcw   FCW                     # Set up FCW

        xorq    %rax, %rax
        movq    %rax, %rdi      # argc
        movq    %rax, %rsi      # argv
        movq    %rax, %rdx      # envp
        call    main                    # Transfer control to main() routine
        nop
        hlt                             # Exit when control comes back

        # This is just a test handler
int32_handler:
        movl    $0x20aced, %eax
        iretq

int2_handler:
        movl    $0x02aced, %eax
        iretq

        .data
        .align 4
stack:
        .8byte 0x80000000
FCW:
        .2byte      0x037F              # Masks all FP exceptions

        .text
        .align  4096
GDT:                                    # Limit#Offset pairs pointing to the
        .2byte      0x28                # GDT and IDT for loading the GDTR
        .4byte      gdt_table           # and IDTR.  They are in this code
IDT:                                    # segment so they can be loaded
        .2byte      0x400               # while still in 16bit real mode.
        .4byte      idt_table

        .data
        .align 4096
gdt_table:
                                # 0x00
                                # Null Selector
        .4byte      0x00000000  # Can't use this entry
        .4byte      0x00000000

                                # 0x08
                                # Code Segment Descriptor
        .4byte      0x00001FFF  # Limit[15:0], Base[15:0]
        .4byte      0x00CF9C00  # Base[31:24], Acc, Limit[19:16],
                                # Priv, Type, Base[23:16]

                                # 0x10
        .byte      0xff    # Limit [7:0]
        .byte      0xff    # Limit [15:8]
        .byte      0x0                   # Base[7:0]
        .byte      0x0                   # Base[15:8]
        .byte      0x0                   # Base[23:16]
        .byte      0x9C   # P=1 DPL=0 1 TYPE=03h
        .byte      0xAF   # G=1 D/B=0 0 AVL=0 Limit[19:16]
        .byte      0x00                   # Base[31:24]

                                # 0x18
        .byte      0xff    # Limit [7:0]
        .byte      0xff    # Limit [15:8]
        .byte      0x0                   # Base[7:0]
        .byte      0x0                   # Base[15:8]
        .byte      0x0                   # Base[23:16]
        .byte      0x93   # P=1 DPL=0 1 TYPE=03h
        .byte      0xCF   # G=1 D/B=0 0 AVL=0 Limit[19:16]
        .byte      0x00                   # Base[31:24]

                                # 0x20
                                # Stack Segment Descriptor
        .4byte      0x0000FFFF  # Limit[15:0], Base[15:0]
        .4byte      0x00CF9300  # Base[31:24], Acc, Limit[19:16]
                                # Priv, Type, Base[23:16]

idt_table:
        # Currently, we have only int2 and int32 handler.

        .= idt_table + 16 * 2       # Descriptor for interrupt 2 (NMI)
        .word       int2_handler    # Offset address Bits 0-15 of IR
        .word       0x10            # Segment Selector
        .byte       0               # Reserved. Must be 0
        .byte       0b10001110      # +---+---+---+---+---+---+---+---+
                                    # | P |  DPL  | S |    GateType   |
                                    # +---+---+---+---+---+---+---+---+
        .word       0               # Bits 16...31 of IR address

        .= idt_table + 16 * 32      # Descriptor for interrupt 32
        .word       int32_handler   # Offset address Bits 0-15 of IR
        .word       0x10            # Segment Selector
        .byte       0               # Reserved. Must be 0
        .byte       0b10001110      # +---+---+---+---+---+---+---+---+
                                    # | P |  DPL  | S |    GateType   |
                                    # +---+---+---+---+---+---+---+---+
        .word       0               # Bits 16...31 of IR address

        .space 16 * 31

# we need  a page table at 0x020000 that looks something this:
#                                    ;===================================================================
#                                    ; PAGE Segment: pagedir
#                                    ;
#                                    ; ATTRIBUTES:
#                                    ;
#                                    ;                 LONG:  64BIT
#                                    ;                 NAME:  pagedir
#                                    ;                 TYPE:  [RW, ACCESSED]
#                                    ;                 SIZE:  USE32
#                                    ;                 BASE:  0x20000
#                                    ;                LIMIT:  _pagedir_SEGEND
#                                    ;===================================================================
#                                    ;START_SEG(pagedir, USE32, 0x20000)
#                                    pagedir      SEGMENT  USE32     ;# at 020000h
#                                    _pagedir_SEGBEGIN:
        .align 4096
        .= 0x20000
        .include "crt1_pagedir.inc"
.end

