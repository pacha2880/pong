; #########################################################################

;     include files
;     ~~~~~~~~~~~~~
      include \masm32\include\masm32rt.inc
;     libraries
;     ~~~~~~~~~
      includelib \MASM32\LIB\masm32.lib

      includelib \MASM32\LIB\gdi32.lib
      includelib \MASM32\LIB\user32.lib
      includelib \MASM32\LIB\kernel32.lib
      includelib \MASM32\LIB\Comctl32.lib
      includelib \MASM32\LIB\comdlg32.lib
      includelib \MASM32\LIB\shell32.lib
IDB_MAIN   equ 1
; #########################################################################

        ;=================
        ; Local prototypes
        ;=================
        WinMain PROTO :DWORD,:DWORD,:DWORD,:DWORD
        WndPongProc PROTO :DWORD,:DWORD,:DWORD,:DWORD
        TopXY PROTO   :DWORD,:DWORD
        FillBuffer   PROTO :DWORD,:DWORD,:BYTE
        Paint_Proc   PROTO :DWORD,:DWORD

      ;=============
      ; Local macros
      ;=============

      szText MACRO Name, Text:VARARG
        LOCAL lbl
          jmp lbl
            Name db Text,0
          lbl:
        ENDM

      m2m MACRO M1, M2
        push M2
        pop  M1
      ENDM

      return MACRO arg
        mov eax, arg
        ret
      ENDM
      randVel MACRO
        invoke GetSystemTime,ADDR systime
        mov ax,systime.wMilliseconds
        and ax,1
        .if ax == 1
          mov VelBallX,8
        .else
          mov VelBallX,-8
        .endif
      ENDM
      direccion MACRO
        sub eax,10
            mov edx,BallY
            add edx,7
            .if edx > eax
                mov VelBallY,6
            .else
              sub eax,10
              .if edx > eax
                  mov VelBallY,4
              .else
                sub eax,10
                .if edx > eax
                    mov VelBallY,2
                .else
                  sub eax,10
                  .if edx > eax
                      mov VelBallY,0
                  .else
                    sub eax,10
                    .if edx > eax
                        mov VelBallY,-2
                    .else
                      sub eax,10
                      .if edx > eax
                          mov VelBallY,-4
                      .else
                        sub eax,10
                        .if edx > eax
                            mov VelBallY,-6
                        .endif
                      .endif
                    .endif
                 .endif
                .endif
              .endif   
            .endif
      ENDM

    .data
        TestString  db "Win32 assembly is great and easy!",0 
        FontName db "arial",0
        szDisplayName db "GDI Shapes",0
        CommandLine   dd 0
        hWnd          dd 0
        hInstance     dd 0
        hIcon         dd 0
        char WPARAM 20h
        chark WPARAM 20h
        LeftPlayerY dd 201
        LeftPlayerY1 dd 271
        VelLeftPlayerY dd 0
        RightPlayerY dd 201
        RightPlayerY1 dd 271
        VelRightPlayerY dd 0
        BallX dd 497
        BallY dd 235
        BallX1 dd 509
        BallY1 dd 247
        VelBallX dd 0
        VelBallY dd 0
        RightPlayerScore dd 30h
        LeftPlayerScore dd 30h
        game db 0
        p1 db "PLAYER 1 WINS!",0
        p2 db "PLAYER 2 WINS!",0
        g db 3
        np db 0ffh
        del db 0
        RightPlayerWin db "RIGHT WINS!",0
        LeftPlayerWin db "LEFT WINS!",0
        PauseString db "PAUSE",0
        PressG db "Press G",0

; ########################### Inserted modules ############################


; #########################################################################
