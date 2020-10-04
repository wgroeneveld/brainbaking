Attribute VB_Name = "modExplode"
Option Explicit

'****************************************************************
'*Author: Carl Slutter
'*
'*e-mail to hardwood@erols.com
'*
'*Description:
'*This module (a work in progress) currently either
'*explodes or implodes a form.
'*
'*The larger the "Movement" value the slower the
'*explosion or implosion.  It is possible to have the form
'*explode/implode from various directions although this
'*code does not include that option.
'*
'* Call is ExplodeForm (or ImplodeForm) FormName, Movement

'*Creation Date: Thursday  23 January 1997  2:33 pm
'*Revision Date: Thursday  23 January 1997  2:33 pm
'*
'*Version Number: 1.10
'*
'*This code may be freely used by any individual in a personal
'*project.  If the code is modified or additional effects are
'*added, I would appreciate receiving a copy of the revised
'*code.
'*However, if the code is used in a project developed
'*in the anticipation of a  profit, permission of the author
'*must be obtained and a fee may be charged.
'****************************************************************

'Declarations

#If Win16 Then
    Type RECT
        Left As Integer
        Top As Integer
        Right As Integer
        Bottom As Integer
    End Type
#Else
    Type RECT
        Left As Long
        Top As Long
        Right As Long
        Bottom As Long
    End Type
#End If

'User and GDI Functions for Explode/Implode to work

#If Win16 Then
    Declare Sub GetWindowRect Lib "User" (ByVal hwnd As Integer, lpRect As RECT)
    Declare Function GetDC Lib "User" (ByVal hwnd As Integer) As Integer
    Declare Function ReleaseDC Lib "User" (ByVal hwnd As Integer, ByVal hdc As Integer) As Integer
    Declare Sub SetBkColor Lib "GDI" (ByVal hdc As Integer, ByVal crColor As Long)
    Declare Sub Rectangle Lib "GDI" (ByVal hdc As Integer, ByVal X1 As Integer, ByVal Y1 As Integer, ByVal X2 As Integer, ByVal Y2 As Integer)
    Declare Function CreateSolidBrush Lib "GDI" (ByVal crColor As Long) As Integer
    Declare Function SelectObject Lib "GDI" (ByVal hdc As Integer, ByVal hObject As Integer) As Integer
    Declare Sub DeleteObject Lib "GDI" (ByVal hObject As Integer)
#Else
    Declare Function GetWindowRect Lib "user32" (ByVal hwnd As Long, lpRect As RECT) As Long
    Declare Function GetDC Lib "user32" (ByVal hwnd As Long) As Long
    Declare Function ReleaseDC Lib "user32" (ByVal hwnd As Long, ByVal hdc As Long) As Long
    Declare Function SetBkColor Lib "gdi32" (ByVal hdc As Long, ByVal crColor As Long) As Long
    Declare Function Rectangle Lib "gdi32" (ByVal hdc As Long, ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long) As Long
    Declare Function CreateSolidBrush Lib "gdi32" (ByVal crColor As Long) As Long
    Declare Function SelectObject Lib "user32" (ByVal hdc As Long, ByVal hObject As Long) As Long
    Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
#End If

'****************************************************************
'*Author: Carl Slutter
'*
'*Description:
'*The higher the "Movement", the slower the window
'*"explosion".
'*
'*Creation Date: Thursday  23 January 1997  2:27 pm
'*Revision Date: Thursday  23 January 1997  2:27 pm
'*
'*Version Number: 1.00
'****************************************************************

Sub ExplodeForm(f As Form, Movement As Integer)
    Dim myRect As RECT
    Dim formWidth%, formHeight%, i%, X%, Y%, Cx%, Cy%
    Dim TheScreen As Long
    Dim Brush As Long
    
    GetWindowRect f.hwnd, myRect
    formWidth = (myRect.Right - myRect.Left)
    formHeight = myRect.Bottom - myRect.Top
    TheScreen = GetDC(0)
    Brush = CreateSolidBrush(f.BackColor)
    
    For i = 1 To Movement
        Cx = formWidth * (i / Movement)
        Cy = formHeight * (i / Movement)
        X = myRect.Left + (formWidth - Cx) / 2
        Y = myRect.Top + (formHeight - Cy) / 2
        Rectangle TheScreen, X, Y, X + Cx, Y + Cy
    Next i
    
    X = ReleaseDC(0, TheScreen)
    DeleteObject (Brush)
    
End Sub


Public Sub ImplodeForm(f As Form, Direction As Integer, Movement As Integer, ModalState As Integer)
'****************************************************************
'*Author: Carl Slutter
'*
'*Description:
'*The larger the "Movement" value, the slower the "Implosion"
'*
'*Creation Date: Thursday  23 January 1997  2:42 pm
'*Revision Date: Thursday  23 January 1997  2:42 pm
'*
'*Version Number: 1.00
'****************************************************************
    
    Dim myRect As RECT
    Dim formWidth%, formHeight%, i%, X%, Y%, Cx%, Cy%
    Dim TheScreen As Long
    Dim Brush As Long
    
    GetWindowRect f.hwnd, myRect
    formWidth = (myRect.Right - myRect.Left)
    formHeight = myRect.Bottom - myRect.Top
    TheScreen = GetDC(0)
    Brush = CreateSolidBrush(f.BackColor)
    
        For i = Movement To 1 Step -1
        Cx = formWidth * (i / Movement)
        Cy = formHeight * (i / Movement)
        X = myRect.Left + (formWidth - Cx) / 2
        Y = myRect.Top + (formHeight - Cy) / 2
        Rectangle TheScreen, X, Y, X + Cx, Y + Cy
    Next i
    
    X = ReleaseDC(0, TheScreen)
    DeleteObject (Brush)
        
End Sub

'GEBRUIK:
'--------
'Private Sub Command1_Click()
'    Call ImplodeForm(Me, 2, 500, 1)
'    End
'    Set Form1 = Nothing
'End Sub

'Private Sub Form_Load()
'Call ExplodeForm(Me, 1000)
'End Sub


'Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
'Call ImplodeForm(Me, 2, 500, 1)
'End Sub



