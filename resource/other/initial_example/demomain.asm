;
.386
.model flat,stdcall
option casemap:none

INCLUDELIB msvcrt.lib
INCLUDELIB acllib.lib
include acllib.inc
include module.inc

printf	PROTO C:ptr sbyte, :VARARG



.data
szMsg byte "Hello!!World!!!",0ah,0
szMsg2 byte "Hello!!World!!!%d",0


.code
main proc
	 invoke mymsg,offset szMsg
	 invoke init_first ;�ȵ����������ʼ������
	 invoke initWindow, offset szMsg,900,100,300,300 ;Ȼ���ʼ�����ڣ���һ��
	 invoke beginPaint;Ȼ��ʼ����
	 invoke paintText,0,0,addr szMsg
	 invoke endPaint;�������������Գ������ɴ�beginpaint��endpaint
	 invoke init_second ;�����¼�ѭ��
;	 invoke MessageBoxA, 0,offset szMsg,offset szMsg,0
	 mov eax,0
	 ret
main endp
end main