FasdUAS 1.101.10   ��   ��    k             l     ����  r       	  I    ���� 

�� .sysostdfalis    ��� null��   
 ��  
�� 
ftyp  m       �   $ c o m . c o m p u s e r v e . g i f  ��  
�� 
prmp  m       �   $ S e l e c t   G I F ' s   f i l e s  �� ��
�� 
mlsl  m    ��
�� boovtrue��   	 o      ���� 0 giffiles gifFiles��  ��        l    ����  r        n        1    ��
�� 
strq  n        1    ��
�� 
psxp  l    ����  I   ���� 
�� .sysostflalis    ��� null��    �� ��
�� 
prmp  m         � ! ! L S e l e c t   t h e   f o l d e r   t o   s a v e   g i f ' s   f r a m e s��  ��  ��    o      ���� 0 dest  ��  ��     " # " l     ��������  ��  ��   #  $ % $ l   ! &���� & r    ! ' ( ' n     ) * ) 1    ��
�� 
strq * m     + + � , , f r o m   A p p K i t   i m p o r t   N S A p p l i c a t i o n ,   N S I m a g e ,   N S I m a g e C u r r e n t F r a m e ,   N S G I F F i l e T y p e ;   i m p o r t   s y s ,   o s 
 t N a m e = o s . p a t h . b a s e n a m e ( s y s . a r g v [ 1 ] ) 
 d i r = s y s . a r g v [ 2 ] 
 a p p = N S A p p l i c a t i o n . s h a r e d A p p l i c a t i o n ( )   
 i m g = N S I m a g e . a l l o c ( ) . i n i t W i t h C o n t e n t s O f F i l e _ ( s y s . a r g v [ 1 ] ) 
 i f   i m g : 
           g i f R e p = i m g . r e p r e s e n t a t i o n s ( ) [ 0 ] 
           f r a m e s = g i f R e p . v a l u e F o r P r o p e r t y _ ( ' N S I m a g e F r a m e C o u n t ' ) 
           i f   f r a m e s : 
                   f o r   i   i n   r a n g e ( f r a m e s . i n t V a l u e ( ) ) : 
                           g i f R e p . s e t P r o p e r t y _ w i t h V a l u e _ ( N S I m a g e C u r r e n t F r a m e ,   i ) 
                           g i f R e p . r e p r e s e n t a t i o n U s i n g T y p e _ p r o p e r t i e s _ ( N S G I F F i l e T y p e ,   N o n e ) . w r i t e T o F i l e _ a t o m i c a l l y _ ( d i r   +   t N a m e   +   '   '   +   s t r ( i   +   1 ) . z f i l l ( 2 )   +   ' . g i f ' ,   T r u e ) 
                   p r i n t   ( i   +   1 ) ( o      ���� 0 pscript pScript��  ��   %  - . - l     ��������  ��  ��   .  /�� / l  " Z 0���� 0 X   " Z 1�� 2 1 r   4 U 3 4 3 c   4 Q 5 6 5 l  4 M 7���� 7 I  4 M�� 8��
�� .sysoexecTEXT���     TEXT 8 b   4 I 9 : 9 b   4 G ; < ; b   4 C = > = b   4 = ? @ ? b   4 9 A B A m   4 7 C C � D D & / u s r / b i n / p y t h o n   - c   B o   7 8���� 0 pscript pScript @ m   9 < E E � F F    > l  = B G���� G n   = B H I H 1   @ B��
�� 
strq I n   = @ J K J 1   > @��
�� 
psxp K o   = >���� 0 f  ��  ��   < m   C F L L � M M    : o   G H���� 0 dest  ��  ��  ��   6 m   M P��
�� 
long 4 o      ���� .0 numberofextractedgifs numberOfExtractedGIFs�� 0 f   2 o   % &���� 0 giffiles gifFiles��  ��  ��       �� N O��   N ��
�� .aevtoappnull  �   � **** O �� P���� Q R��
�� .aevtoappnull  �   � **** P k     Z S S   T T   U U  $ V V  /����  ��  ��   Q ���� 0 f   R �� �� ��������  �������� +�������� C E L������
�� 
ftyp
�� 
prmp
�� 
mlsl�� 
�� .sysostdfalis    ��� null�� 0 giffiles gifFiles
�� .sysostflalis    ��� null
�� 
psxp
�� 
strq�� 0 dest  �� 0 pscript pScript
�� 
kocl
�� 
cobj
�� .corecnte****       ****
�� .sysoexecTEXT���     TEXT
�� 
long�� .0 numberofextractedgifs numberOfExtractedGIFs�� [*�����e� E�O*��l 	�,�,E�O��,E�O 7�[�a l kh  a �%a %��,�,%a %�%j a &E` [OY��ascr  ��ޭ