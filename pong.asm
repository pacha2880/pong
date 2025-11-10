; #########################################################################

      .386
      .model flat, stdcall  ; 32 bit memory model
      option casemap :none  ; case sensitive

      include gdibits.inc   ; local includes for this file

; #########################################################################

.code

start:
      invoke GetModuleHandle, NULL
      mov hInstance, eax

      invoke GetCommandLine
      mov CommandLine, eax

      invoke WinMain,hInstance,NULL,CommandLine,SW_SHOWDEFAULT
      invoke ExitProcess,eax

; #########################################################################

WinMain proc hInst     :DWORD,
             hPrevInst :DWORD,
             CmdLine   :DWORD,
             CmdShow   :DWORD

      ;====================
      ; Put LOCALs on stack
      ;====================

      LOCAL wc   :WNDCLASSEX
      LOCAL msg  :MSG
      LOCAL Wwd  :DWORD
      LOCAL Wht  :DWORD
      LOCAL Wtx  :DWORD
      LOCAL Wty  :DWORD

      ;==================================================
      ; Fill WNDCLASSEX structure with required variables
      ;==================================================

      invoke LoadIcon,hInst,500    ; icon ID
      mov hIcon, eax

      szText szClassName,"GDIs_Class"

      mov wc.cbSize,         sizeof WNDCLASSEX
      mov wc.style,          CS_BYTEALIGNWINDOW
      mov wc.lpfnWndProc,    offset WndPongProc
      mov wc.cbClsExtra,     NULL
      mov wc.cbWndExtra,     NULL
      m2m wc.hInstance,      hInst
      mov wc.hbrBackground,  2
      mov wc.lpszMenuName,   NULL
      mov wc.lpszClassName,  offset szClassName
      m2m wc.hIcon,          hIcon
        invoke LoadCursor,NULL,IDC_ARROW
      mov wc.hCursor,        eax
      m2m wc.hIconSm,        hIcon

      invoke RegisterClassEx, ADDR wc

      ;================================
      ; Centre window at following size
      ;================================

      mov Wwd, 1024
      mov Wht, 512

      invoke GetSystemMetrics,SM_CXSCREEN
      invoke TopXY,Wwd,eax
      mov Wtx, eax

      invoke GetSystemMetrics,SM_CYSCREEN
      invoke TopXY,Wht,eax
      mov Wty, eax

      invoke CreateWindowEx,WS_EX_LEFT,
                            ADDR szClassName,
                            ADDR szDisplayName,
                            WS_OVERLAPPEDWINDOW,
                            Wtx,Wty,Wwd,Wht,
                            NULL,NULL,
                            hInst,NULL
      mov   hWnd,eax

      invoke LoadMenu,hInst,600  ; menu ID
      invoke SetMenu,hWnd,eax

      invoke ShowWindow,hWnd,SW_SHOWNORMAL
      invoke UpdateWindow,hWnd

      ;===================================
      ; Loop until PostQuitMessage is sent
      ;===================================

    StartLoop:

  
      invoke GetMessage,ADDR msg,NULL,0,0
      cmp eax, 0
      je ExitLoop
      invoke TranslateMessage, ADDR msg
      invoke DispatchMessage,  ADDR msg
      jmp StartLoop
    ExitLoop:

      return msg.wParam

WinMain endp

; #########################################################################

WndPongProc proc hWin   :DWORD,
             uMsg   :DWORD,
             wParam :DWORD,
             lParam :DWORD

    LOCAL var    :DWORD
    LOCAL caW    :DWORD
    LOCAL caH    :DWORD
    LOCAL Rct    :RECT
    LOCAL hDC    :DWORD
    LOCAL Ps     :PAINTSTRUCT
    LOCAL hfont  :HFONT
    LOCAL systime :SYSTEMTIME
    ; ACTUALIZANDO POSICION
    .if np
      mov eax,VelBallY
      mov edx,VelBallX
      add BallY,eax
      add BallY1,eax
      add BallX,edx
      add BallX1,edx
      .if LeftPlayerY > 7
      .if LeftPlayerY1 < 463
      mov eax,VelLeftPlayerY
      add LeftPlayerY,eax
      add LeftPlayerY1,eax
      .else
      mov LeftPlayerY,392
      mov LeftPlayerY1,462
      .endif
      .else
      mov LeftPlayerY1,78
      mov LeftPlayerY,8
      .endif
      .if RightPlayerY > 7
      .if RightPlayerY1 < 463
      mov eax,VelRightPlayerY
      add RightPlayerY,eax
      add RightPlayerY1,eax
      .else
      mov RightPlayerY,392
       mov RightPlayerY1,462
      .endif
      .else
      mov RightPlayerY1,78
      mov RightPlayerY,8
      .endif
      ; REBOTE PARED
      .if BallY1 <= 19
          .if VelBallY>10
            neg VelBallY
          .endif
      .elseif BallY1 >= 463
          .if VelBallY<10
            neg VelBallY
          .endif
      .endif
      ;REBOTE JUGADOR
      .if BallX1 >= 965
        .if BallX1 <= 975
        mov eax,RightPlayerY
        .if BallY1 >= eax
          mov eax,RightPlayerY1
          .if BallY <= eax
            neg VelBallX
            direccion
          .endif
        .endif
        .endif
      .elseif BallX1 <= 55
        .if BallX1 >=45
        mov eax,LeftPlayerY
        .if BallY1 >= eax 
          mov eax,LeftPlayerY1
          .if BallY <= eax
            neg VelBallX
            direccion
          .endif
        .endif
        .endif
      .endif
      ;AUMENTANDO PUNTUACION
      .if BallX1 > 1000
            inc LeftPlayerScore
            mov game,0
            mov VelBallY,0
            mov VelBallX,0
            mov BallX,497
            mov BallY,235
            mov BallX1,509
            mov BallY1,247
            mov del,1
      .elseif BallX > 2000
            inc RightPlayerScore
            mov game,0
            mov VelBallY,0
            mov VelBallX,0
            mov BallX,497
            mov BallY,235
            mov BallX1,509
            mov BallY1,247
            mov del,1
      .endif  
      ;CONDICION DE GANADOR
     .if LeftPlayerScore == 35h
          mov g,1
          mov game,0
      .elseif RightPlayerScore == 35h
          mov g,2
          mov game,0
      .endif
    .endif
      invoke InvalidateRect, hWnd,NULL,TRUE

    .if uMsg == WM_PAINT
          
        invoke Sleep,33
        invoke BeginPaint,hWin,ADDR Ps
          mov hDC, eax
          invoke CreateFont,50,20,0,0,800,0,0,0,OEM_CHARSET,\ 
                                       OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,\ 
                                       DEFAULT_QUALITY,DEFAULT_PITCH or FF_SCRIPT,\ 
                                       ADDR FontName
        invoke SelectObject, hDC, eax 
        mov    hfont,eax 
        invoke SetTextColor,hDC,0ffffffh
        invoke SetBkColor,hDC,0
        invoke TextOut,hDC,150,50,addr LeftPlayerScore,1
        invoke TextOut,hDC,790,50,addr RightPlayerScore,1
          .if g == 1
              invoke TextOut,hDC,150,200,addr LeftPlayerWin,10
                  mov LeftPlayerScore,30h
                  mov RightPlayerScore,30h
          .elseif g == 2
              invoke TextOut,hDC,550,200,addr RightPlayerWin,11
                  mov LeftPlayerScore,30h
                  mov RightPlayerScore,30h
          .endif
          .if np == 0
              invoke TextOut,hDC,430,200,addr PauseString,5
          .endif
          .if g > 0
              invoke TextOut,hDC,550,400,addr PressG,7
          .endif
        invoke SelectObject,hDC, hfont 
          invoke Paint_Proc,hWin,hDC
        invoke EndPaint,hWin,ADDR Ps
        .if del
            invoke Sleep,1000
            mov del,0
        .endif
        return 0
    .ELSEIF uMsg == WM_KEYDOWN
      .if np
          push wParam
          pop  char
          ;CUANDO SE PRESIONA UNA TECLA SE LE DA VELOCIDAD AL RECTANGULITO
          .if char == 57h
                mov VelLeftPlayerY,-3
          .elseif char == 53h
                mov VelLeftPlayerY,3
          .elseif char == 4Fh
                mov VelRightPlayerY,-3
          .elseif char == 4Ch
                mov VelRightPlayerY,3              
          .endif        
      .endif
    .ELSEIF uMsg == WM_KEYUP
      .if np
          push wParam
          pop  char
          ;CUANDO SE LEVANTA UNA TECLA SE LE QUITA LA VELOCIDAD AL RECTANGULITO
          .if char == 57h
              .if VelLeftPlayerY == -3
                mov VelLeftPlayerY,0
              .endif
          .elseif char == 53h
              .if VelLeftPlayerY == 3
                mov VelLeftPlayerY,0
              .endif
          .elseif char == 4Fh
              .if VelRightPlayerY == -3
                mov VelRightPlayerY,0
              .endif
          .elseif char == 4Ch
              .if VelRightPlayerY == 3
                mov VelRightPlayerY,0
              .endif          
          .endif    
      .endif
    .elseif uMsg == WM_CHAR
          push wParam
          pop char
          ;PARA INICIAR EL JUEGO PULSAR CUALQUIER TECLA
          .if game == 0
                  .if g == 0
                  iniciar:
                      mov game,1
                      randVel
                      mov LeftPlayerY,201
                      mov LeftPlayerY1,271
                      mov VelLeftPlayerY,0
                      mov RightPlayerY,201
                      mov RightPlayerY1,271
                  .elseif g > 0
                      .if char == 'g'
                          mov g,0
                          jmp iniciar
                      .endif
                  .endif
          ;RESETEAR JUEGO
          .elseif char == 'r'
                  mov game,0
                  mov VelBallY,0
                  mov VelBallX,0
                  mov BallX,497
                  mov BallY,235
                  mov BallX1,509
                  mov BallY1,247
                  mov LeftPlayerScore,30h
                  mov RightPlayerScore,30h
                  mov g,0
                  mov np,1
          ;PAUSAR JUEGO
          .elseif char == 't'
                  not np
          .endif
    .elseif uMsg == WM_DESTROY
        invoke PostQuitMessage,NULL
        return 0 
    .endif
    invoke DefWindowProc,hWin,uMsg,wParam,lParam

    ret

WndPongProc endp

; ########################################################################

TopXY proc wDim:DWORD, sDim:DWORD

    shr sDim, 1      ; divide screen dimension by 2
    shr wDim, 1      ; divide window dimension by 2
    mov eax, wDim    ; copy window dimension into eax
    sub sDim, eax    ; sub half win dimension from half screen dimension

    return sDim

TopXY endp

; #########################################################################

Paint_Proc proc hWin:DWORD, hDC:DWORD

    LOCAL hPen      :DWORD
    LOCAL hPenOld   :DWORD
    LOCAL hBrush    :DWORD
    LOCAL hBrushOld :DWORD

    LOCAL lb        :LOGBRUSH

    invoke CreatePen,0,1,00ffffffh  ; red
    mov hPen, eax

    mov lb.lbStyle, BS_SOLID
    mov lb.lbColor, 00ffffffh       ; blue
    mov lb.lbHatch, NULL

    invoke CreateBrushIndirect,ADDR lb
    mov hBrush, eax

    invoke SelectObject,hDC,hPen
    mov hPenOld, eax

    invoke SelectObject,hDC,hBrush
    mov hBrushOld, eax

  ; ------------------------------------------------
  ; The 4 GDI functions use the pen colour set above
  ; and fill the area with the current brush.
  ; ------------------------------------------------
    ;DIBUJAR PELOTA
    invoke Ellipse,hDC,BallX,BallY,BallX1,BallY1

    ;DIBUJAR JUGADORES
    invoke Rectangle,hDC,965,RightPlayerY,985,RightPlayerY1
    invoke Rectangle,hDC,23,LeftPlayerY,43,LeftPlayerY1

    ;DIBUJAR CANCHA
    invoke Rectangle,hDC,501,3,505,463
    invoke Rectangle,hDC,3,3,1003,7
    invoke Rectangle,hDC,3,463,1003,467
    invoke Rectangle,hDC,3,3,7,467
    invoke Rectangle,hDC,1000,3,1004,467
    

  ; ------------------------------------------------

    invoke SelectObject,hDC,hBrushOld
    invoke DeleteObject,hBrush

    invoke SelectObject,hDC,hPenOld
    invoke DeleteObject,hPen

    ret

Paint_Proc endp

; ########################################################################

end start
