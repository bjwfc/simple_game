;�ο���ģ���ʽ
.386
.model flat,stdcall
option casemap:none

.data
szMsg3 byte "FROM module:Hello!!World!!!",0
MessageBoxA PROTO :dword, :dword, :dword, :word

.code
;�ο���ע�͸�ʽ
;@brief:��ʾһ����Ϣ��
;@param msg1:Ҫ��ʾ����Ϣ����
;@return:�㷵��0
mymsg proc C msg1:dword
	invoke MessageBoxA, 0,msg1,offset szMsg3,0
	mov eax,0
	ret
mymsg endp


end mymsg