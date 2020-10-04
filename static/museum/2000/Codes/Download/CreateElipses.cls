VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CGDIEllipse"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Class       : CGDIEllipse
' Description : Draws an ellipse, using Windows API GDI calls.
' Source      : Total VB SourceBook 6
'
Private Declare Function CreateBrushIndirect _
  Lib "gdi32" _
  (lpLogBrush As LOGBRUSH) _
  As Long

Private Declare Function CreatePen _
  Lib "gdi32" _
  (ByVal nPenStyle As Long, _
   ByVal nWidth As Long, _
   ByVal crColor As Long) _
  As Long

Private Declare Function SetROP2 _
  Lib "gdi32" _
  (ByVal hdc As Long, _
   ByVal nDrawMode As Long) _
  As Long

Private Declare Function GetROP2 _
  Lib "gdi32" _
  (ByVal hdc As Long) _
  As Long

Private Declare Function SelectObject _
  Lib "gdi32" _
  (ByVal hdc As Long, _
   ByVal hObject As Long) _
  As Long

Private Declare Function DeleteObject _
  Lib "gdi32" _
  (ByVal hObject As Long) _
  As Long

Private Declare Function Ellipse _
  Lib "gdi32" _
  (ByVal hdc As Long, _
   ByVal nLeftRect As Long, _
   ByVal nTopRect As Long, _
   ByVal nRightRect As Long, _
   ByVal nBottomRect As Long) _
  As Long

Private Declare Function GetSysColor _
  Lib "user32" _
  (ByVal nIndex As Long) _
  As Long

Public Enum EnumEllipsePenStyles
  epsPS_SOLID = 0
  epsPS_DASH = 1
  epsPS_DOT = 2
  epsPS_DASHDOT = 3
  epsPS_DASHDOTDOT = 4
  epsPS_NULL = 5
  epsPS_INSIDEFRAME = 6
End Enum

Public Enum EnumEllipseBrushStyles
  ebsBS_SOLID = 0
  ebsBS_NULL = 1
  ebsBS_HOLLOW = ebsBS_NULL
  ebsBS_HATCHED = 2
  ebsBS_PATTERN = 3
  ebsBS_INDEXED = 4
  ebsBS_DIBPATTERN = 5
  ebsBS_DIBPATTERNPT = 6
  ebsBS_PATTERN8X8 = 7
  ebsBS_DIBPATTERN8X8 = 8
End Enum

Public Enum EnumEllipseHatchStyles
  ehsHS_HORIZONTAL = 0
  ehsHS_VERTICAL = 1
  ehsHS_FDIAGONAL = 2
  ehsHS_BDIAGONAL = 3
  ehsHS_cross = 4
  ehsHS_DIAGCROSS = 5
  ehsHS_FDIAGONAL1 = 6
  ehsHS_BDIAGONAL1 = 7
  ehsHS_SOLID = 8
  ehsHS_DENSE1 = 9
  ehsHS_DENSE2 = 10
  ehsHS_DENSE3 = 11
  ehsHS_DENSE4 = 12
  ehsHS_DENSE5 = 13
  ehsHS_DENSE6 = 14
  ehsHS_DENSE7 = 15
  ehsHS_DENSE8 = 16
  ehsHS_NOSHADE = 17
  ehsHS_HALFTONE = 18
  ehsHS_SOLIDCLR = 19
  ehsHS_DITHEREDCLR = 20
  ehsHS_SOLIDTEXTCLR = 21
  ehsHS_DITHEREDTEXTCLR = 22
  ehsHS_SOLIDBKCLR = 23
  ehsHS_DITHEREDBKCLR = 24
  ehsHS_API_MAX = 25
End Enum

Public Enum EnumEllipseRasterOps
  eroR2_BLACK = 1
  eroR2_NOTMERGEPEN = 2
  eroR2_MASKNOTPEN = 3
  eroR2_NOTCOPYPEN = 4
  eroR2_MASKPENNOT = 5
  eroR2_NOT = 6
  eroR2_XORPEN = 7
  eroR2_NOTMASKPEN = 8
  eroR2_MASKPEN = 9
  eroR2_NOTXORPEN = 10
  eroR2_NOP = 11
  eroR2_MERGENOTPEN = 12
  eroR2_COPYPEN = 13
  eroR2_MERGEPENNOT = 14
  eroR2_MERGEPEN = 15
  eroR2_WHITE = 16
  eroR2_LAST = 16
End Enum

Private Type LOGBRUSH
  lbStyle As Long
  lbColor As Long
  lbHatch As Long
End Type

' variables for static property data
Private m_lngLeft As Long
Private m_lngTop As Long
Private m_lngRight As Long
Private m_lngBottom As Long
Private m_lngBorderColor As OLE_COLOR
Private m_lngFillColor As OLE_COLOR
Private m_lngBrushStyle As Long
Private m_lngHatchStyle As Long
Private m_intBorderWidth As Integer
Private m_lngPenStyle As Long
Private m_lngForegroundMixMode As Long

Private Sub Class_Initialize()
  ' Set initial values to defaults which may be overridden
  ' with property settings
  ' Source: Total VB SourceBook 6

  m_intBorderWidth = 1
  m_lngBrushStyle = ebsBS_SOLID
  m_lngHatchStyle = ehsHS_HORIZONTAL
  m_lngPenStyle = epsPS_SOLID
  m_lngForegroundMixMode = eroR2_COPYPEN

End Sub

Public Property Get BorderColor() As OLE_COLOR
  ' Returns: current value of the BorderColor property
  ' Source: Total VB SourceBook 6

  BorderColor = m_lngBorderColor
  
End Property

Public Property Let BorderColor(ByVal lngValue As OLE_COLOR)
  ' lngValue: specify the RGB value for the color used to draw
  '           the ellipse
  ' Source: Total VB SourceBook 6

  m_lngBorderColor = lngValue
  
End Property

Public Property Get BorderWidth() As Integer
  ' Returns: current value of the BorderWidth property
  ' Source: Total VB SourceBook 6

  BorderWidth = m_intBorderWidth
  
End Property

Public Property Let BorderWidth(ByVal intValue As Integer)
  ' intValue: specify the width, in pixels, of the ellipse
  ' Source: Total VB SourceBook 6

  m_intBorderWidth = intValue
  
End Property

Public Property Get Bottom() As Long
  ' Returns: current value of the Bottom property
  ' Source: Total VB SourceBook 6

  Bottom = m_lngBottom
  
End Property

Public Property Let Bottom(ByVal lngValue As Long)
  ' lngValue: location in pixels of the bottom of the
  '           bounding rectangle for the ellipse
  ' Source: Total VB SourceBook 6

  m_lngBottom = lngValue
  
End Property

Public Property Get BrushStyle() As EnumEllipseBrushStyles
  ' Returns: current value of the BrushStyle property
  ' Source: Total VB SourceBook 6
  
  BrushStyle = m_lngBrushStyle
  
End Property

Public Property Let BrushStyle( _
  ByVal eValue As EnumEllipseBrushStyles)
  ' eValue: specify the style used to fill the ellipse
  ' Source: Total VB SourceBook 6

  m_lngBrushStyle = eValue
  
End Property

Public Property Get FillColor() As OLE_COLOR
  ' Returns: current value of the FillColor property
  ' Source: Total VB SourceBook 6
  
  FillColor = m_lngFillColor
  
End Property

Public Property Let FillColor(ByVal lngValue As OLE_COLOR)
  ' lngValue: specify the RGB value for the color used to fill
  '           the ellipse
  ' Source: Total VB SourceBook 6

  m_lngFillColor = lngValue
  
End Property

Public Property Get ForegroundMixMode() As EnumEllipseRasterOps
  ' Returns: current value of the ForegroundMixMode property
  ' Source: Total VB SourceBook 6

  ForegroundMixMode = m_lngForegroundMixMode
  
End Property

Public Property Let ForegroundMixMode( _
  ByVal eValue As EnumEllipseRasterOps)
  ' eValue: The foreground mix mode defines how colors
  '         from the pen and the colors in the existing
  '         image are to be combined.
  ' Source: Total VB SourceBook 6

  m_lngForegroundMixMode = eValue
  
End Property

Public Property Get HatchStyle() As EnumEllipseHatchStyles
  ' Returns: current value of the HatchStyle property
  ' Source: Total VB SourceBook 6
  
  HatchStyle = m_lngHatchStyle
  
End Property

Public Property Let HatchStyle( _
  ByVal eValue As EnumEllipseHatchStyles)
  ' eValue: specify the style used to fill the ellipse when
  '         the BrushStyle is set to hatched
  ' Source: Total VB SourceBook 6
  
  m_lngHatchStyle = eValue
  
End Property

Public Property Get Left() As Long
  ' Returns: current value of the Left property
  ' Source: Total VB SourceBook 6
  
  Left = m_lngLeft
  
End Property

Public Property Let Left(ByVal lngValue As Long)
  ' lngValue: location in pixels of the left side of the
  '           bounding rectangle for the ellipse
  ' Source: Total VB SourceBook 6
  
  m_lngLeft = lngValue
  
End Property

Public Property Get PenStyle() As EnumEllipsePenStyles
  ' Returns: current value of the PenStyle property
  ' Source: Total VB SourceBook 6

  PenStyle = m_lngPenStyle
  
End Property

Public Property Let PenStyle(ByVal eValue As EnumEllipsePenStyles)
  ' eValue: style used to draw the line.
  ' Source: Total VB SourceBook 6

  m_lngPenStyle = eValue
  
End Property

Public Property Get Right() As Long
  ' Returns: current value of the Right property
  ' Source: Total VB SourceBook 6

  Right = m_lngRight
  
End Property

Public Property Let Right(ByVal lngValue As Long)
  ' lngValue: location in pixels of the right side of the
  '           bounding rectangle for the ellipse
  ' Source: Total VB SourceBook 6

  m_lngRight = lngValue
  
End Property

Public Property Get Top() As Long
  ' Returns: current value of the Top property
  ' Source: Total VB SourceBook 6

  Top = m_lngTop
  
End Property

Public Property Let Top(ByVal lngValue As Long)
  ' lngValue: location in pixels of the top side of the
  '           bounding rectangle for the ellipse
  ' Source: Total VB SourceBook 6

  m_lngTop = lngValue
  
End Property

Public Sub Draw3DEllipse( _
  lnghDC As Long, _
  ByVal lngShadowColor As OLE_COLOR, _
  ByVal lngHighlightColor As OLE_COLOR)
  ' Comments  : Draws two Ellipses on a selected device so that
  '             they create a 3D effect. The ellipses are
  '             bounded by the dimensions of a  rectangle specified
  '             in the Left, Top, Bottom and Right
  '             properties. The normal BorderColor property
  '             is not used with this method. Instead the two colors
  '             for the ellipses are supplied as parameters
  ' Parameters: lnghDC - handle to device context to receive
  '             the image.
  '             lngShadowColor - RGB color for the ellipse forming
  '             the "shadow". May use VB color constants, or any RGB value
  '             lngHighlighColor - RGB color for the ellipse forming
  '             the "highlight".
  ' Returns   : Nothing
  ' Source    : Total VB SourceBook 6
  '
  Dim lngSaveBorderColor As Long
  Dim lngSaveBrushStyle As Long
  
  On Error GoTo PROC_ERR
  
  ' save border color and fill style, because the properties
  ' will be modified temporarily by this method
  lngSaveBorderColor = m_lngBorderColor
  lngSaveBrushStyle = m_lngBrushStyle
  
  ' set fill style to hollow
  m_lngBrushStyle = ebsBS_HOLLOW
  
  ' draw an ellipse using the Shadow Color
  m_lngBorderColor = lngShadowColor
  DrawEllipse lnghDC
  
  ' draw an ellipse using the HighLight color. Move the
  ' ellipse down and to the right the width of the current
  ' BorderWidth setting
  m_lngBorderColor = lngHighlightColor
  
  m_lngLeft = m_lngLeft + m_intBorderWidth
  m_lngTop = m_lngTop + m_intBorderWidth
  m_lngRight = m_lngRight + m_intBorderWidth
  m_lngBottom = m_lngBottom + m_intBorderWidth
  
  DrawEllipse lnghDC
    
  ' restore original border color and location
  m_lngBorderColor = lngSaveBorderColor
  m_lngBrushStyle = lngSaveBrushStyle
  
  m_lngLeft = m_lngLeft - m_intBorderWidth
  m_lngTop = m_lngTop - m_intBorderWidth
  m_lngRight = m_lngRight - m_intBorderWidth
  m_lngBottom = m_lngBottom - m_intBorderWidth
  
PROC_EXIT:
  Exit Sub

PROC_ERR:
  MsgBox "Error: " & Err.Number & ". " & Err.Description, , _
    "Draw3DEllipse"
  Resume PROC_EXIT
  
End Sub

Public Sub DrawEllipse(lnghDC As Long)
  ' Comments  : Draw an Ellipse on a selected device. The ellipse is
  '             bounded by the dimensions of a  rectangle specified
  '             in the Left, Top, Bottom and Right
  '             properties.
  ' Parameters: lnghDC - handle to device context to receive
  '             the image.
  ' Returns   : Nothing
  ' Source    : Total VB SourceBook 6
  '
  Dim lngResult As Long
  Dim lnghPen As Long
  Dim lnghPenOld As Long
  Dim lnghBrush As Long
  Dim lnghBrushOld As Long
  Dim lb As LOGBRUSH
  Dim lngROP2ModeOld As Long
  
  On Error GoTo PROC_ERR

  ' create brushes and pens to draw the outline of the
  ' ellipse, and to fill it with a specified color
  With lb
    .lbColor = TranslateVBColor(m_lngFillColor)
    .lbHatch = m_lngHatchStyle
    .lbStyle = m_lngBrushStyle
  End With
  
  lnghBrush = CreateBrushIndirect(lb)
  lnghBrushOld = SelectObject(lnghDC, lnghBrush)

  lnghPen = CreatePen( _
    m_lngPenStyle, _
    m_intBorderWidth, _
    TranslateVBColor(m_lngBorderColor))
    
  lnghPenOld = SelectObject(lnghDC, lnghPen)
    
  If GetROP2(lnghDC) <> m_lngForegroundMixMode Then
    lngROP2ModeOld = SetROP2(lnghDC, m_lngForegroundMixMode)
  End If
  
  ' draw the ellipse
  lngResult = Ellipse( _
    lnghDC, _
    m_lngLeft, _
    m_lngTop, _
    m_lngRight, _
    m_lngBottom)
  
  If lngROP2ModeOld <> 0 Then
    SetROP2 lnghDC, lngROP2ModeOld
  End If
  
  ' restore objects and clean up resources
  SelectObject lnghDC, lnghBrushOld
  SelectObject lnghDC, lnghPenOld
  
  DeleteObject lnghBrush
  DeleteObject lnghPen
  
PROC_EXIT:
  Exit Sub

PROC_ERR:
  MsgBox "Error: " & Err.Number & ". " & Err.Description, , _
    "DrawEllipse"
  Resume PROC_EXIT
  
End Sub

Private Function TranslateVBColor( _
  ByVal lngColor As OLE_COLOR) _
  As Long
  ' Comments  : Translates VB color constants for system
  '             colors into GDI equivalents
  ' Parameters: lngColor - RGB value for the color
  ' Returns   : Translated color, if necessary, or the original color
  ' Source    : Total VB SourceBook 6
  '
  Const clngHighBitMask As Long = &H80000000
  Dim lngResult As Long
  
  On Error GoTo PROC_ERR
  
  If lngColor And clngHighBitMask Then
    ' VB system constants have first bit set. If this is
    ' set, mask it out, and retrieve the system color
    lngResult = lngColor And Not clngHighBitMask
    lngResult = GetSysColor(lngResult)
  Else
    ' otherwise, use original color
    lngResult = lngColor
  End If
  
  TranslateVBColor = lngResult
  
PROC_EXIT:
  Exit Function

PROC_ERR:
  MsgBox "Error: " & Err.Number & ". " & Err.Description, , _
    "TranslateVBColor"
  Resume PROC_EXIT
  
End Function

'gebruik:
'Private Sub Form_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
  
 ' Dim GDIEllipse As CGDIEllipse
  'Set GDIEllipse = New CGDIEllipse

'  With GDIEllipse
  
    ' Draw a hatched green circle
  '  .Left = ScaleX(X, vbTwips, vbPixels) - 100
  '  .Top = ScaleY(Y, vbTwips, vbPixels) - 100
    '.Right = ScaleX(X, vbTwips, vbPixels)
    '.Bottom = ScaleY(Y, vbTwips, vbPixels)
  
    '.BorderColor = vbYellow
    '.BorderWidth = 1
    '.FillColor = vbGreen
    '.BrushStyle = ebsBS_HATCHED
'    .HatchStyle = ehsHS_DIAGCROSS
    '.ForegroundMixMode = eroR2_COPYPEN
    '.PenStyle = epsPS_DASH
    
'    ' Draw the ellipse. See also Draw3DEllipse
'    .DrawEllipse Me.hdc
    
'    ' Draw a 3D Oval
'    .Left = ScaleX(X, vbTwips, vbPixels)
'    .Top = ScaleY(Y, vbTwips, vbPixels)
'    .Right = ScaleX(X, vbTwips, vbPixels) + 100
'    .Bottom = ScaleY(Y, vbTwips, vbPixels) + 75
    
'    .PenStyle = epsPS_SOLID
'    .Draw3DEllipse Me.hdc, vb3DShadow, vb3DHighlight
        
 ' End With
    
'End Sub


