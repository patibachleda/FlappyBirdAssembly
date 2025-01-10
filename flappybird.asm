INCLUDE Irvine32.inc

.data
ground BYTE 100 DUP("-"), 0

titleString BYTE "FLAPPY BIRD", 0

xPosition BYTE 30
yPosition BYTE 10

xPipe0 BYTE ?
xPipe1 BYTE ?
xPipe2 BYTE ?
xPipe3 BYTE ?

ybPipe0 BYTE ?
ybPipe1 BYTE ?
ybPipe2 BYTE ?
ybPipe3 BYTE ?

ytPipe0 BYTE ?
ytPipe1 BYTE ?
ytPipe2 BYTE ?
ytPipe3 BYTE ?

inputChar BYTE ?

scoreString BYTE "Score: ", 0
score DWORD 0

title0 BYTE " ___ _ ___               ___ _       _",0
title1 BYTE "|  _| |_  |___________  | _ |_|_____| |   ___",0
title2 BYTE "|  _| | . | . | . | | | | _-| |  _| . |  /__O\_",0
title3 BYTE "|_| |_|___| __| __|__ | |___|_|_| |___|  \___/-'",0
title4 BYTE "          |_| |_|  |__|                         ",0

gameover0 BYTE " ________                        ________                     ",0
gameover1 BYTE " /  _____/_____    _____   ____   \_____  \___  __ ___________ ",0
gameover2 BYTE "/   \  ___\__  \  /     \_/ __ \   /   |   \  \/ // __ \_  __ \",0
gameover3 BYTE "\    \_\  \/ __ \|  Y Y  \  ___/  /    |    \   /\  ___/|  | \/",0
gameover4 BYTE " \______  (____  /__|_|  /\___  > \_______  /\_/  \___  >__|   ",0
gameover5 BYTE "        \/     \/      \/     \/          \/          \/       ",0

pipet0 BYTE " |      |", 0 
pipet1 BYTE " |      |", 0 
pipet2 BYTE " |      |", 0 
pipet3 BYTE " |      |", 0 
pipet4 BYTE " |      |", 0
pipet5 BYTE " |      |", 0
pipet6 BYTE "_|______|_", 0
pipet7 BYTE "|________|", 0

pipeb0 BYTE " ________ ", 0
pipeb1 BYTE "|________|", 0
pipeb2 BYTE " |      |", 0 
pipeb3 BYTE " |      |", 0
pipeb4 BYTE " |      |", 0
pipeb5 BYTE " |      |", 0
pipeb6 BYTE " |      |", 0
pipeb7 BYTE " |      |", 0
pipeb8 BYTE " |      |", 0

resetString BYTE "           ", 0

instructions BYTE "Press any key to begin", 0

player0 BYTE " ___",0
player1 BYTE "/__O\_",0
player2 BYTE "\___/-'",0

empty BYTE "        ", 0

.code
main PROC PUBLIC
     call drawWelcomeScreen

     call clrscr; Clears the screen
     
     ;draw ceiling at bottom of the screen (0,2)
     call DrawCeiling

     ;draw ground at bottom of the screen (0,27)
     call DrawGround
     
     ;draw title of game
     call DrawTitle

     ;draw player
     call DrawPlayer

     ;draw initial pipes
     mov dl, 15
     mov dh, 7
     call drawTopPipe
     mov dl, 15
     mov dh, 26
     call drawBottomPipe
     mov [xPipe0], 15 

     mov dl, 40
     mov dh, 7
     call drawTopPipe
     mov dl, 40
     mov dh, 26
     call drawBottomPipe
     mov [xPipe1], 40 

     mov dl, 65
     mov dh, 7
     call drawTopPipe
     mov dl, 65
     mov dh, 26
     call drawBottomPipe
     mov [xPipe2], 65 

     mov dl, 90
     mov dh, 7
     call drawTopPipe
     mov dl, 90
     mov dh, 26
     call drawBottomPipe
     mov [xPipe3], 90 

     gameLoop:
          mov cl, 0; determines how tall the top and bottom pipe should be

          ;draw score
          mov dl, 5
          mov dh, 3
          call Gotoxy
          mov edx, OFFSET scoreString
          call WriteString
          mov eax, score
          call WriteDec

          ;pipe logic
          call movePipes

          ;gravity logic
          call clearCharacter
          inc yPosition
          call DrawPlayer

          mov eax, 80
          call Delay 

          ;check if hit the ground
          cmp yPosition, 27
          jge gameOverScreen

          ;check pipe collision
          call checkPipeCollision

          ;get player input
          call ReadKey
          jz gameLoop
          mov inputChar, al

          ;exit the game
          cmp inputChar, "x"
          je endGame

          ;jump
          cmp inputChar, " "
          je jump

          jump:
               ;allow player to jump
               mov ecx, 2
               jumpLoop:
                    call clearCharacter
                    dec yPosition
                    call DrawPlayer
                    mov eax, 40
                    call Delay
                    call clearCharacter
                    dec yPosition
                    call DrawPlayer
                    mov eax, 40
                    call Delay

                    ;check if hit the ceiling
                    cmp yPosition, 6
                    jle gameOverScreen

               dec ecx
               jnz gameLoop
          
          ;repeat the game loop
          jmp gameLoop

     call endGame

main ENDP

endGame PROC
     INVOKE ExitProcess, 0
endGame ENDP

checkPipeCollision PROC
;if xpos = xpipe# and (ypos < ytpipe# or ypos > ybpipe#) where # is each pipe 0-3

     ; ypos < ytpipe#
     mov al, yPosition
     mov bl, ytPipe0
     inc bl
     inc bl
     cmp al, bl
     jle checkX0

     ;if ypos > ybpipe#
     mov al, yPosition
     mov bl, ybPipe0
     cmp al, bl
     jl pipe1

     ;xpos = xpipe#
     checkX0:
        mov al, xPosition
        mov bl, xPipe0
        cmp bl, 19
        jl pipe1
        cmp bl, 32
        jg pipe1
        jle gameOverScreen

     pipe1:
          ; ypos < ytpipe#
          mov al, yPosition
          mov bl, ytPipe1
          inc bl
          inc bl
          cmp al, bl
          jle checkX1

          ;if ypos > ybpipe#
          mov al, yPosition
          mov bl, ybPipe1
          cmp al, bl
          jl pipe2

          ;xpos = xpipe#
          checkX1:
             mov al, xPosition
             mov bl, xPipe1
             cmp bl, 19
             jl pipe2
             cmp bl, 32
             jg pipe2
             jle gameOverScreen


     pipe2:
          ; ypos < ytpipe#
          mov al, yPosition
          mov bl, ytPipe2
          inc bl
          inc bl
          cmp al, bl
          jle checkX2

          ;if ypos > ybpipe#
          mov al, yPosition
          mov bl, ybPipe2
          cmp al, bl
          jl pipe3

          ;xpos = xpipe#
          checkX2:
             mov al, xPosition
             mov bl, xPipe2
             cmp bl, 19
             jl pipe3
             cmp bl, 32
             jg pipe3
             jle gameOverScreen


     pipe3:
          ; ypos < ytpipe#
          mov al, yPosition
          mov bl, ytPipe3
          inc bl
          inc bl
          cmp al, bl
          jle checkX3

          ;if ypos > ybpipe#
          mov al, yPosition
          mov bl, ybPipe3
          cmp al, bl
          jl done

          ;xpos = xpipe#
          checkX3:
             mov al, xPosition
             mov bl, xPipe3
             cmp bl, 19 
             jl done
             cmp bl, 32
             jg done
             jle gameOverScreen

     done:
          ret
checkPipeCollision ENDP

drawWelcomeScreen PROC
     mov dl, 35
     mov dh, 10
     call Gotoxy
     mov edx, OFFSET title0
     call WriteString

     mov dl, 35
     mov dh, 11
     call Gotoxy
     mov edx, OFFSET title1
     call WriteString

     mov dl, 35
     mov dh, 12
     call Gotoxy
     mov edx, OFFSET title2
     call WriteString

     mov dl, 35
     mov dh, 13
     call Gotoxy
     mov edx, OFFSET title3
     call WriteString

     mov dl, 35
     mov dh, 14
     call Gotoxy
     mov edx, OFFSET title4
     call WriteString

     mov dl, 45
     mov dh, 18
     call Gotoxy
     mov edx, OFFSET instructions
     call WriteString
          
     call ReadChar
     ret

drawWelcomeScreen ENDP

clearCharacter PROC
     mov dl, xPosition
     mov dh, yPosition
     call Gotoxy
     mov edx, OFFSET empty
     call WriteString

     
     mov dl, xPosition
     mov dh, yPosition
     dec dh
     call Gotoxy
     mov edx, OFFSET empty
     call WriteString

     mov dl, xPosition
     mov dh, yPosition
     inc dh
     call Gotoxy
     mov edx, OFFSET empty
     call WriteString
     ret
clearCharacter ENDP

movePipes PROC
     inc cl
     inc cl
     inc cl
     inc cl
     dec xPipe0
     call clearPipe0
     mov dl, xPipe0
     mov dh, 7 
     call drawTopPipe
     mov ytPipe0, al
     mov dl, xPipe0
     mov dh, 26
     call drawBottomPipe 
     mov ybPipe0, al
     cmp xPipe0, 10
     jle resetX0  
     dec cl
     dec cl
     dec cl

     dec xPipe1
     call clearPipe1
     mov dl, xPipe1
     mov dh, 7
     call drawTopPipe
     mov ytPipe1, al
     mov dl, xPipe1
     mov dh, 26
     call drawBottomPipe    
     mov ybPipe1, al
     cmp xPipe1, 10
     jle resetX1 
     inc cl
     inc cl
     inc cl

     dec xPipe2
     call clearPipe2
     mov dl, xPipe2
     mov dh, 7
     call drawTopPipe
     mov ytPipe2, al
     mov dl, xPipe2
     mov dh, 26
     call drawBottomPipe   
     mov ybPipe2, al
     cmp xPipe2, 10
     jle resetX2  
     dec cl
     dec cl
     dec cl
     dec cl

     dec xPipe3
     call clearPipe3
     mov dl, xPipe3
     mov dh, 7
     call drawTopPipe
     mov ytPipe3, al
     mov dl, xPipe3
     mov dh, 26
     call drawBottomPipe     
     mov ybPipe3, al
     cmp xPipe3, 10
     jle resetX3  

     inc cl 
     inc cl
     inc cl
     inc cl

     ret
movePipes ENDP

clearPipe0 PROC
     mov dl, xPipe0
     mov dh, 7
     call clearTopPipe
     mov dl, xPipe0
     mov dh, 18
     call clearBottomPipe

     ret
clearPipe0 ENDP

resetX0 PROC
     call clearPipe0
     mov [xPipe0], 110
     inc [score]

     ret
resetX0 ENDP

clearPipe1 PROC
     mov dl, xPipe1
     mov dh, 7
     call clearTopPipe
     mov dl, xPipe1
     mov dh, 18
     call clearBottomPipe

     ret
clearPipe1 ENDP

resetX1 PROC
     call clearPipe1
     mov [xPipe1], 110
     inc [score]

     ret
resetX1 ENDP

clearPipe2 PROC
     mov dl, xPipe2
     mov dh, 7
     call clearTopPipe
     mov dl, xPipe2
     mov dh, 18
     call clearBottomPipe

     ret
clearPipe2 ENDP

resetX2 PROC
     call clearPipe2
     mov [xPipe2], 110
     inc [score]

     ret
resetX2 ENDP

clearPipe3 PROC
     mov dl, xPipe3
     mov dh, 7
     call clearTopPipe
     mov dl, xPipe3
     mov dh, 18
     call clearBottomPipe

     ret
clearPipe3 ENDP

resetX3 PROC
     call clearPipe3
     mov [xPipe3], 110
     inc [score]

     ret
resetX3 ENDP

clearTopPipe PROC
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET resetString
      call WriteString

      mov dh, al
      mov dl, bl

      inc dh
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET resetString
      call WriteString

      mov dh, al
      mov dl, bl

      inc dh
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET resetString
      call WriteString

      mov dh, al
      mov dl, bl

      inc dh
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET resetString
      call WriteString

      mov dh, al
      mov dl, bl

      inc dh
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET resetString
      call WriteString

      mov dh, al
      mov dl, bl

      inc dh
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET resetString
      call WriteString

      mov dh, al
      mov dl, bl

      inc dh
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET resetString
      call WriteString

      mov dh, al
      mov dl, bl

      inc dh
      call Gotoxy
      mov edx, OFFSET resetString
      call WriteString

      ret
clearTopPipe ENDP

clearBottomPipe PROC
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET resetString
      call WriteString

      mov dh, al
      mov dl, bl

      inc dh
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET resetString
      call WriteString

      mov dh, al
      mov dl, bl

       inc dh
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET resetString
      call WriteString

      mov dh, al
      mov dl, bl

      inc dh
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET resetString
      call WriteString

      mov dh, al
      mov dl, bl

      inc dh
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET resetString
      call WriteString

      mov dh, al
      mov dl, bl

      inc dh
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET resetString
      call WriteString

      mov dh, al
      mov dl, bl

      inc dh
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET resetString
      call WriteString

      mov dh, al
      mov dl, bl

            inc dh
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET resetString
      call WriteString

      mov dh, al
      mov dl, bl

            inc dh
      call Gotoxy
      mov edx, OFFSET resetString
      call WriteString

      ret
clearBottomPipe ENDP

drawTopPipe PROC
      cmp cl, 1
      jge one
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET pipet0
      call WriteString

      mov dh, al
      mov dl, bl

      inc dh
      
      one:
      cmp cl, 2
      jge two
      call Gotoxy
            mov al, dh
      mov bl, dl
      mov edx, OFFSET pipet1
      call WriteString

      mov dh, al
      mov dl, bl

      inc dh

      two:
      cmp cl, 3
      jge three
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET pipet2

      call WriteString

      mov dh, al
      mov dl, bl

      inc dh

      three:
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET pipet3

      call WriteString

      mov dh, al
      mov dl, bl

      inc dh
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET pipet4

      call WriteString

      mov dh, al
      mov dl, bl

      inc dh
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET pipet5

      call WriteString

      mov dh, al
      mov dl, bl

      inc dh
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET pipet6

      call WriteString

      mov dh, al
      mov dl, bl

      inc dh
      call Gotoxy

      mov edx, OFFSET pipet7
      call WriteString
     ret
drawTopPipe ENDP

drawBottomPipe PROC
      cmp cl, 0
      je two

      cmp cl, 1
      je one

      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET pipeb8
      call WriteString

      mov dh, al
      mov dl, bl

      dec dh

      one:
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET pipeb7
      call WriteString

      mov dh, al
      mov dl, bl

       dec dh

      two:
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET pipeb6
      call WriteString

      mov dh, al
      mov dl, bl

      dec dh

      three:
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET pipeb5
      call WriteString

      mov dh, al
      mov dl, bl

      dec dh
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET pipeb4
      call WriteString

      mov dh, al
      mov dl, bl

      dec dh
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET pipeb3
      call WriteString

      mov dh, al
      mov dl, bl

      dec dh
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET pipeb2
      call WriteString

      mov dh, al
      mov dl, bl

      dec dh
      call Gotoxy
      mov al, dh
      mov bl, dl
      mov edx, OFFSET pipeb1
      call WriteString

      mov dh, al
      mov dl, bl

      dec dh
      call Gotoxy
      mov edx, OFFSET pipeb0
      call WriteString

      ret
drawBottomPipe ENDP

DrawGround PROC
     mov dl, 10
     mov dh, 27
     call Gotoxy
     mov edx, OFFSET ground
     call WriteString
     ret
DrawGround ENDP

DrawCeiling PROC
     mov dl, 10
     mov dh, 6
     call Gotoxy
     mov edx, OFFSET ground
     call WriteString
     ret
DrawCeiling ENDP

DrawTitle PROC
     mov dl, 35
     mov dh, 0
     call Gotoxy
     mov edx, OFFSET title0
     call WriteString

     mov dl, 35
     mov dh, 1
     call Gotoxy
     mov edx, OFFSET title1
     call WriteString

     mov dl, 35
     mov dh, 2
     call Gotoxy
     mov edx, OFFSET title2
     call WriteString

     mov dl, 35
     mov dh, 3
     call Gotoxy
     mov edx, OFFSET title3
     call WriteString

     mov dl, 35
     mov dh, 4
     call Gotoxy
     mov edx, OFFSET title4
     call WriteString

     ret
DrawTitle ENDP

DrawPlayer PROC
     mov dl, xPosition
     mov dh, yPosition
     call Gotoxy
     mov edx, OFFSET player1
     call WriteString

     mov dl, xPosition
     mov dh, yPosition
     dec dh
     call Gotoxy
     mov edx, OFFSET player0
     call WriteString

     mov dl, xPosition
     mov dh, yPosition
     inc dh
     call Gotoxy
     mov edx, OFFSET player2
     call WriteString
     ret
DrawPlayer ENDP

gameOverScreen PROC
     call clrscr

     mov dl, 30
     mov dh, 10
     call Gotoxy
     mov edx, OFFSET gameover0
     call WriteString

     mov dl, 30
     mov dh, 11
     call Gotoxy
     mov edx, OFFSET gameover1
     call WriteString

     mov dl, 30
     mov dh, 12
     call Gotoxy
     mov edx, OFFSET gameover2
     call WriteString

     mov dl, 30
     mov dh, 13
     call Gotoxy
     mov edx, OFFSET gameover3
     call WriteString

     mov dl, 30
     mov dh, 14
     call Gotoxy
     mov edx, OFFSET gameover4
     call WriteString

     mov dl, 30
     mov dh, 15
     call Gotoxy
     mov edx, OFFSET gameover5
     call WriteString

     mov dl, 0
     mov dh, 27
     call Gotoxy
     
     mov eax, 1000
     call Delay

     call endGame
gameOverScreen ENDP

END main
