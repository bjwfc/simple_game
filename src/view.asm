.386
.model flat,stdcall
option casemap:none

INCLUDELIB acllib.lib
INCLUDELIB myLib.lib
include inc/acllib.inc
include inc/sharedVar.inc
include inc/model.inc
include inc/msvcrt.inc

calPsin PROTO C :dword, :dword
calPcos PROTO C :dword, :dword
myitoa PROTO C :dword, :ptr sbyte
printf proto C :dword,:vararg

colorBLACK EQU 00000000h
colorWHITE EQU 00ffffffh
colorEMPTY EQU 0ffffffffh

.data	
srcBg byte "..\..\..\resource\icon\background.jpg", 0
srcTitle byte "..\..\..\resource\icon\title.jpg", 0
srcPin byte "..\..\..\resource\icon\pin.jpg", 0 
srcStart byte "..\..\..\resource\icon\start.jpg", 0 
srcExit byte "..\..\..\resource\icon\exit.jpg", 0 
srcBg2 byte "..\..\..\resource\icon\background2.jpg", 0 
srcContinue byte "..\..\..\resource\icon\continue.jpg", 0 
srcHome byte "..\..\..\resource\icon\home.jpg", 0 
srcHome2 byte "..\..\..\resource\icon\home2.jpg", 0 
srcMenu byte "..\..\..\resource\icon\menu.jpg", 0 
srcScore byte "..\..\..\resource\icon\score.jpg", 0 
srcWin byte "..\..\..\resource\icon\win.jpg", 0 
srcReload byte "..\..\..\resource\icon\reload.jpg", 0 
imgBg ACL_Image <>
imgTitle ACL_Image <>
imgPin ACL_Image <>
imgStart ACL_Image <>
imgExit ACL_Image <>
imgBg2 ACL_Image <>
imgContinue ACL_Image <>
imgHome ACL_Image <>
imgHome2 ACL_Image <>
imgMenu ACL_Image <>
imgScore ACL_Image <>
imgWin ACL_Image <>
imgReload ACL_Image <>

fontName byte "����", 0
titleScore byte "�� ��", 0

colorCCircle dword 008515c7h  ;����Բ��ɫ
colorScore dword 008eb0fch  ;�Ƿ�����ɫ
colors  dword 00cccc99h  ;�ײ���ͷ��ɫ
		dword 0099cc99h
		dword 00996699h
		dword 009999ffh
		dword 009966cch
		dword 0099ccffh

strScore byte 10 DUP(0)
strPinNum byte 10 DUP(0)
strCurNum byte 10 DUP(0)

curScore dword ?
lowy dword 545  ;�ײ���ͷ���϶������� 
lowyText dword 534  ;�ײ���ͷ�������϶�������
initPinNum dword ?  ;Ԥ��������
totalPinNum dword ?  ;Ҫ�����������
pinLen dword 170  ;�볤
pinX dword ? 
pinY dword ?



.code
;@brief:ˢ�¼Ƿ���
;@param num:��ǰ����
FlushScore proc C num: dword
	mov ebx, num
	mov curScore, ebx
	invoke myitoa, ebx, offset strScore
	ret
FlushScore endp


;@brief:����������/ʧ��/�ɹ�����
;@param win:�������ͣ�0�����棬2ʧ�ܽ��棬3�ɹ����棩
loadMenu proc C win:dword
	mov ebx, win
	mov currWindow, ebx	
	
	;ѡ�����ɵĴ���
	cmp ebx, 0  
	jz mainwindow	
	cmp ebx, 2
	jz loser
	cmp ebx,3
	jz winner

mainwindow:
	;����ͼƬ
	invoke loadImage, offset srcBg, offset imgBg
	invoke loadImage, offset srcTitle, offset imgTitle
	invoke loadImage, offset srcPin, offset imgPin
	invoke loadImage, offset srcStart, offset imgStart
	invoke loadImage, offset srcExit, offset imgExit	
	;��ʾ������
	invoke beginPaint
	invoke putImageScale, offset imgBg, 0, 0, 550, 700
	invoke putImageScale, offset imgTitle, 45, 110, 500, 150
	invoke putImageScale, offset imgPin, 246, 120, 60, 100
	invoke putImageScale, offset imgStart, 155, 310, 240, 100
	invoke putImageScale, offset imgExit, 155, 460, 240, 100
	invoke endPaint
	jmp finish

loser:
	;����ͼƬ
	invoke loadImage, offset srcBg2, offset imgBg2
	invoke loadImage, offset srcHome2, offset imgHome2
	invoke loadImage, offset srcScore, offset imgScore
	invoke loadImage, offset srcReload, offset imgReload
	;��ʾʧ�ܽ���
	invoke beginPaint
	invoke putImageScale, offset imgBg2, 25, 165, 500, 330
	invoke putImageScale, offset imgScore, 100, 180, 350, 100
	invoke putImageScale, offset imgHome2, 155, 400, 70, 70
	invoke putImageScale, offset imgReload, 325, 400, 70, 70
	;��ʾ�÷�
	invoke setTextSize, 80
	invoke setTextColor, 00cc9900h
	invoke setTextBkColor, colorEMPTY
	cmp curScore, 10
	jb l0
	invoke paintText, 235, 295, offset strScore
	jmp l1
l0:
	invoke paintText, 250, 295, offset strScore
l1:
	;����ħ������
	invoke putImageScale, offset imgBg, 260, 530, 30, 30
	invoke endPaint
	jmp finish

winner:
	;����ͼƬ
	invoke loadImage, offset srcBg2, offset imgBg2
	invoke loadImage, offset srcHome2, offset imgHome2
	invoke loadImage, offset srcWin, offset imgWin
	invoke loadImage, offset srcContinue, offset imgContinue
	;��ʾ�ɹ�����
	invoke beginPaint
	invoke putImageScale, offset imgBg2, 25, 165, 500, 330
	invoke putImageScale, offset imgWin, 25, 215, 500, 100
	invoke putImageScale, offset imgHome2, 155, 365, 70, 70
	invoke putImageScale, offset imgContinue, 325, 365, 70, 70
	;�޸ļǷ���
	invoke setPenWidth, 1
	invoke setPenColor, colorScore
	invoke setBrushColor, colorScore
	invoke roundrect, 215, 35, 335, 100, 10, 10
	;���ƼǷ��Ʒ���
	invoke setTextColor, colorWHITE
	invoke setTextFont, offset fontName
	invoke setTextBkColor, colorEMPTY
	invoke setTextSize, 28
	invoke paintText, 245, 40, offset titleScore
	cmp curScore, 10
	jb t2
	invoke paintText, 260, 70, offset strScore
	jmp t3
t2:
	invoke paintText, 267, 70, offset strScore
t3:
	;����ħ������
	invoke putImageScale, offset imgBg, 260, 530, 30, 30
	invoke endPaint
	jmp finish

finish:	
	invoke printf, offset titleScore
	ret 
loadMenu endp


;@brief:ˢ����Ϸ����
flushGameWindow proc C
	add cdeg, 2
	cmp cdeg, 360
	jb ta
	mov cdeg, 0
ta:
	invoke loadImage, offset srcBg, offset imgBg
	invoke loadImage, offset srcHome, offset imgHome
	
	invoke beginPaint
	invoke putImageScale, offset imgBg, 0, 0, 550, 700
	invoke putImageScale, offset imgHome, 60, 35, 60, 60	
	
	;���ƼǷ���
	invoke setPenWidth, 1
	invoke setPenColor, colorScore
	invoke setBrushColor, colorScore
	invoke roundrect, 215, 35, 335, 100, 10, 10
	;���ƼǷ��Ʒ���
	invoke setTextColor, colorWHITE
	invoke setTextFont, offset fontName
	invoke setTextBkColor, colorEMPTY
	invoke setTextSize, 28
	invoke paintText, 245, 40, offset titleScore
	cmp curScore, 10
	jb tz
	invoke paintText, 260, 70, offset strScore
	jmp ty
tz:
	invoke paintText, 267, 70, offset strScore
ty:
	mov ecx, 0  ;ѭ������=Ԥ��������
t0:	
	;�������յ�
	mov edx, cdeg  
	add edx, pindeg[ecx*4]  ;���㵱ǰ�Ƕ�
	cmp edx, 360
	jb t2  ;С��360��ֱ�Ӽ���
	cmp edx, 720
	jae t3  ;���ڵ���720������l3
	sub edx, 360  ;���ڵ���360��С��720
	jmp t2
t3:
	sub edx, 720
t2:
	mov eax, 275
	add eax, pcos[edx*4]
	mov pinX, eax  ;���������
	mov eax, 320
	add eax, psin[edx*4]
	mov pinY, eax  ;����������
	push ecx
	;����Ԥ����
	invoke setPenColor, colorBLACK
	invoke setPenWidth, 2
	invoke line, 275, 320, pinX, pinY 
	;����Ԥ����ͷ
	invoke setPenWidth, 30
	invoke line, pinX, pinY, pinX, pinY
	pop ecx
	inc ecx
	cmp ecx, initPinNum
	jb t0

	; ���Ʋ�����
	mov ebx, totalPinNum
	cmp pinnum, ebx
	je tc
tb:
	;�������յ�
	mov edx, cdeg  
	add edx, pindeg[ecx*4]  ;���㵱ǰ�Ƕ�
	cmp edx, 360
	jb ti  ;С��360��ֱ�Ӽ���
	cmp edx, 720
	jae th  ;���ڵ���720������th
	sub edx, 360  ;���ڵ���360��С��720
	jmp ti
th:
	sub edx, 720
ti:
	mov eax, 275
	add eax, pcos[edx*4]
	mov pinX, eax  ;���������
	mov eax, 320
	add eax, psin[edx*4]
	mov pinY, eax  ;����������
	push ecx
	;���Ʋ�����
	invoke setPenColor, colorBLACK
	invoke setPenWidth, 2
	invoke line, 275, 320, pinX, pinY 
	;���Ʋ�����ͷ ��ͷ��ǰ���eax=total+init-ecx
	pop ecx
	mov eax, totalPinNum
	add eax, initPinNum
	sub eax, ecx
	
	xor ebx, ebx
	xor edx, edx
	mov bl, 6
	div bl
	mov dl, ah 
	push ecx
	invoke setPenColor, colors[edx*4]  ;��������ѡ����ɫ
	invoke setPenWidth, 30
	invoke line, pinX, pinY, pinX, pinY
	pop ecx
	inc ecx
	mov edx, ecx
	sub edx, initPinNum
	add edx, pinnum
	cmp edx, totalPinNum
	jb tb

tc:
	;��������Բ
	invoke setPenWidth, 1
	invoke setPenColor, colorCCircle
	invoke setBrushColor, colorCCircle
	invoke pie, 235, 280, 315, 360, 235, 320, 235, 320
	;������������
	invoke setTextSize, 35
	invoke myitoa, pinnum, offset strPinNum
	cmp pinnum, 10
	jb t4
	invoke paintText, 256, 303, offset strPinNum
	jmp t5
t4:
	invoke paintText, 265, 303, offset strPinNum

t5:
	;���Ƶײ���ͷ	
	mov eax, pinnum  ;��ǰʣ����ͷ�� 
	mov cx, 6  ;ѭ������
	mov ebx, 0

t1:	
	mov edx, 0  ;��¼����
	push cx
	push eax
	mov bl, 6
	div bl
	mov dl, ah 
	push edx
	invoke setPenColor, colors[edx*4]  ;��������ѡ����ɫ
	pop edx
	invoke setBrushColor, colors[edx*4]
	invoke setPenWidth, 30
	invoke line, 275, lowy, 275, lowy  ;������ͷ	
	
	;������ͷ����
	invoke setTextColor, colorWHITE
	invoke setTextSize, 20
	pop eax
	push eax
	invoke myitoa, eax, offset strCurNum
	pop eax
	cmp eax, 10
	push eax
	jb t6
	invoke paintText, 264, lowyText, offset strCurNum
	jmp t7
t6:
	invoke paintText, 270, lowyText, offset strCurNum
t7:
	pop eax
	pop cx
	dec eax
	cmp eax, 0
	jz finish

	add lowy, 30
	add lowyText, 30
	
	dec cx
	cmp cx, 0
	jz finish
	jmp t1

finish:	
	mov lowy, 545  ;�ָ��ײ���ͷ���϶�������
	mov lowyText, 534

	invoke endPaint
	ret
	
flushGameWindow endp


;@brief:��ʱ���ص�����
timer proc C id:dword
	invoke flushGameWindow
	ret
timer endp


;@brief:��ʼ����Ϸ����
;@param omega:���ٶ�
initGameWindow proc C num:dword, interval:dword
	mov currWindow, 1  

	;����psin��pcos
	mov ecx, 0
cal:
	push ecx
	invoke calPsin, pinLen, ecx
	pop ecx
	mov psin[ecx*4] ,eax
	
	push ecx
	invoke calPcos, pinLen, ecx
	pop ecx
	mov pcos[ecx*4] ,eax
	inc ecx
	cmp ecx, 360
	jb cal

	;�洢Ԥ��������
	mov eax, num
	mov initPinNum, eax
	;�洢Ҫ�����������
	mov eax, pinnum
	mov totalPinNum, eax

	;ˢ�³�ʼ����
	;invoke FlushScore, 0

	;��ʼ��ginterval
	mov eax, interval
	mov ginterval, eax

	;��ʼ����ʱ��
	invoke registerTimerEvent, offset timer
	invoke startTimer, 0, interval
	ret
initGameWindow endp	


end