Attribute VB_Name = "CaptureScreenM"
'#########################################################
'#    CaptureScreen Module (C) 1998 - 2000 aWhile-Soft   #
'#########################################################
Option Explicit
Option Base 0
Private Type PALETTEENTRY
    peRed   As Byte
    peGreen As Byte
    peBlue  As Byte
    peFlags As Byte
End Type

Private Type LOGPALETTE
    palVersion       As Integer
    palNumEntries    As Integer
    palPalEntry(255) As PALETTEENTRY  ' Enough for 256 colors
End Type
         
Private Type GUID
    Data1    As Long
    Data2    As Integer
    Data3    As Integer
    Data4(7) As Byte
End Type

Private Type RECT
    Left   As Long
    Top    As Long
    Right  As Long
    Bottom As Long
End Type

Private Type PicBmp
    Size As Long
    Type As Long
    hBmp As Long
    hPal As Long
    Reserved As Long
End Type

Private Const RASTERCAPS As Long = 38
Private Const RC_PALETTE As Long = &H100
Private Const SIZEPALETTE As Long = 104

Private Declare Function CreateCompatibleBitmap Lib "GDI32" ( _
    ByVal hDC As Long, ByVal nWidth As Long, _
    ByVal nHeight As Long) As Long

Private Declare Function GetDeviceCaps Lib "GDI32" ( _
    ByVal hDC As Long, ByVal iCapabilitiy As Long) As Long

Private Declare Function GetSystemPaletteEntries Lib "GDI32" ( _
    ByVal hDC As Long, ByVal wStartIndex As Long, _
    ByVal wNumEntries As Long, lpPaletteEntries As PALETTEENTRY) _
    As Long

Private Declare Function CreateCompatibleDC Lib "GDI32" ( _
    ByVal hDC As Long) As Long

Private Declare Function CreatePalette Lib "GDI32" ( _
    lpLogPalette As LOGPALETTE) As Long

Private Declare Function SelectPalette Lib "GDI32" ( _
    ByVal hDC As Long, ByVal hPalette As Long, _
    ByVal bForceBackground As Long) As Long

Private Declare Function RealizePalette Lib "GDI32" ( _
    ByVal hDC As Long) As Long

Private Declare Function SelectObject Lib "GDI32" ( _
    ByVal hDC As Long, ByVal hObject As Long) As Long

Private Declare Function BitBlt Lib "GDI32" ( _
    ByVal hDCDest As Long, ByVal XDest As Long, _
    ByVal YDest As Long, ByVal nWidth As Long, _
    ByVal nHeight As Long, ByVal hDCSrc As Long, _
    ByVal XSrc As Long, ByVal YSrc As Long, ByVal dwRop As Long) _
    As Long

Private Declare Function GetWindowDC Lib "USER32" ( _
    ByVal hWnd As Long) As Long

Private Declare Function GetDC Lib "USER32" ( _
    ByVal hWnd As Long) As Long

Private Declare Function ReleaseDC Lib "USER32" ( _
    ByVal hWnd As Long, ByVal hDC As Long) As Long

Private Declare Function DeleteDC Lib "GDI32" ( _
    ByVal hDC As Long) As Long

Private Declare Function GetWindowRect Lib "USER32" ( _
    ByVal hWnd As Long, lpRect As RECT) As Long

Private Declare Function GetDesktopWindow Lib "USER32" () As Long

Private Declare Function GetForegroundWindow Lib "USER32" () As Long

Private Declare Function OleCreatePictureIndirect _
    Lib "olepro32.dll" (PicDesc As PicBmp, RefIID As GUID, _
    ByVal fPictureOwnsHandle As Long, IPic As IPicture) As Long
Public Function CreateBitmapPicture(ByVal hBmp As Long, _
        ByVal hPal As Long) As Picture
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
' CreateBitmapPicture
'    - Creates a bitmap type Picture object from a bitmap and palette.
'
' hBmp
'    - Handle to a bitmap
'
' hPal
'    - Handle to a Palette
'    - Can be null if the bitmap doesn't use a palette
'
' Returns
'    - Returns a Picture object containing the bitmap
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
Dim r   As Long
Dim Pic As PicBmp
'
' IPicture requires a reference to "Standard OLE Types"
'
Dim IPic          As IPicture
Dim IID_IDispatch As GUID
'
' Fill in with IDispatch Interface ID
'
With IID_IDispatch
    .Data1 = &H20400
    .Data4(0) = &HC0
    .Data4(7) = &H46
End With
'
' Fill Pic with the necessary parts.
'
With Pic
    .Size = Len(Pic)          ' Length of structure
    .Type = vbPicTypeBitmap   ' Type of Picture (bitmap)
    .hBmp = hBmp              ' Handle to bitmap
    .hPal = hPal              ' Handle to palette (may be null)
End With
'
' Create the Picture object.
r = OleCreatePictureIndirect(Pic, IID_IDispatch, 1, IPic)
'
' Return the new Picture object.
'
Set CreateBitmapPicture = IPic
End Function



'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
' CaptureWindow
'    - Captures any portion of a window.
'
' hWndSrc
'    - Handle to the window to be captured
'
' bClient
'    - If True CaptureWindow captures from the bClient area of the
'      window
'    - If False CaptureWindow captures from the entire window
'
' LeftSrc, TopSrc, WidthSrc, HeightSrc
'    - Specify the portion of the window to capture
'    - Dimensions need to be specified in pixels
'
' Returns
'    - Returns a Picture object containing a bitmap of the specified
'      portion of the window that was captured
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Public Function CaptureWindow(ByVal hWndSrc As Long, _
    ByVal bClient As Boolean, ByVal LeftSrc As Long, _
    ByVal TopSrc As Long, ByVal WidthSrc As Long, _
    ByVal HeightSrc As Long) As Picture

Dim hDCMemory       As Long
Dim hBmp            As Long
Dim hBmpPrev        As Long
Dim r               As Long
Dim hDCSrc          As Long
Dim hPal            As Long
Dim hPalPrev        As Long
Dim RasterCapsScrn  As Long
Dim HasPaletteScrn  As Long
Dim PaletteSizeScrn As Long
Dim LogPal          As LOGPALETTE
'
' Get the proper Device Context (DC) depending on the value of bClient.
'
If bClient Then
    hDCSrc = GetDC(hWndSrc)       'Get DC for Client area.
Else
    hDCSrc = GetWindowDC(hWndSrc) 'Get DC for entire window.
End If
'
' Create a memory DC for the copy process.
'
hDCMemory = CreateCompatibleDC(hDCSrc)
'
' Create a bitmap and place it in the memory DC.
'
hBmp = CreateCompatibleBitmap(hDCSrc, WidthSrc, HeightSrc)
hBmpPrev = SelectObject(hDCMemory, hBmp)
'
' Get the screen properties.
'
RasterCapsScrn = GetDeviceCaps(hDCSrc, RASTERCAPS)   'Raster capabilities
HasPaletteScrn = RasterCapsScrn And RC_PALETTE       'Palette support
PaletteSizeScrn = GetDeviceCaps(hDCSrc, SIZEPALETTE) 'Palette size
'
' If the screen has a palette make a copy and realize it.
'
If HasPaletteScrn And (PaletteSizeScrn = 256) Then
    '
    ' Create a copy of the system palette.
    '
    LogPal.palVersion = &H300
    LogPal.palNumEntries = 256
    r = GetSystemPaletteEntries(hDCSrc, 0, 256, LogPal.palPalEntry(0))
    hPal = CreatePalette(LogPal)
    '
    ' Select the new palette into the memory DC and realize it.
    '
    hPalPrev = SelectPalette(hDCMemory, hPal, 0)
    r = RealizePalette(hDCMemory)
End If
'
' Copy the on-screen image into the memory DC.
'
r = BitBlt(hDCMemory, 0, 0, WidthSrc, HeightSrc, hDCSrc, _
    LeftSrc, TopSrc, vbSrcCopy)
'
' Remove the new copy of the on-screen image.
'
hBmp = SelectObject(hDCMemory, hBmpPrev)
'
' If the screen has a palette get back the
' palette that was selected in previously.
'
If HasPaletteScrn And (PaletteSizeScrn = 256) Then
    hPal = SelectPalette(hDCMemory, hPalPrev, 0)
End If
'
' Release the DC resources back to the system.
'
r = DeleteDC(hDCMemory)
r = ReleaseDC(hWndSrc, hDCSrc)
'
' Create a picture object from the bitmap
' and palette handles.
'
Set CaptureWindow = CreateBitmapPicture(hBmp, hPal)
End Function

Public Function CaptureScreen() As Picture
Dim hWndScreen As Long
'
' Get a handle to the desktop window.
hWndScreen = GetDesktopWindow()
'
' Capture the entire desktop.
'
With Screen
    Set CaptureScreen = CaptureWindow(hWndScreen, False, 0, 0, _
            .Width \ .TwipsPerPixelX, .Height \ .TwipsPerPixelY)
End With
End Function

Public Function CaptureForm(frm As Form) As Picture
'
' Capture the entire form.
'
With frm
    Set CaptureForm = CaptureWindow(.hWnd, False, 0, 0, _
            .ScaleX(.Width, vbTwips, vbPixels), _
            .ScaleY(.Height, vbTwips, vbPixels))
End With
End Function

Public Function CaptureClient(frm As Form) As Picture
'
' Capture the client area of the form.
'
With frm
    Set CaptureClient = CaptureWindow(.hWnd, True, 0, 0, _
            .ScaleX(.ScaleWidth, .ScaleMode, vbPixels), _
            .ScaleY(.ScaleHeight, .ScaleMode, vbPixels))
End With
End Function

Public Function CaptureActiveWindow() As Picture
Dim hWndActive As Long
Dim RectActive As RECT
'
' Get a handle to the active/foreground window.
' Get the dimensions of the window.
'
hWndActive = GetForegroundWindow()
Call GetWindowRect(hWndActive, RectActive)
'
' Capture the active window.
'
With RectActive
    Set CaptureActiveWindow = CaptureWindow(hWndActive, False, 0, 0, _
            .Right - .Left, .Bottom - .Top)
End With
End Function

Public Sub PrintPictureToFitPage(Prn As Printer, Pic As Picture)
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
' PrintPictureToFitPage
'    - Prints a Picture object as big as possible.
'
' Prn
'    - Destination Printer object
'
' Pic
'    - Source Picture object
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Dim PicRatio     As Double
Dim PrnWidth     As Double
Dim PrnHeight    As Double
Dim PrnRatio     As Double
Dim PrnPicWidth  As Double
Dim PrnPicHeight As Double
Const vbHiMetric As Integer = 8
'
' Determine if picture should be printed in landscape
' or portrait and set the orientation.
'
If Pic.Height >= Pic.Width Then
    Prn.Orientation = vbPRORPortrait   'Taller than wide
Else
    Prn.Orientation = vbPRORLandscape  'Wider than tall
End If
'
' Calculate device independent Width to Height ratio for picture.
'
PicRatio = Pic.Width / Pic.Height
'
' Calculate the dimentions of the printable area in HiMetric.
'
With Prn
    PrnWidth = .ScaleX(.ScaleWidth, .ScaleMode, vbHiMetric)
    PrnHeight = .ScaleY(.ScaleHeight, .ScaleMode, vbHiMetric)
End With
'
' Calculate device independent Width to Height ratio for printer.
'
PrnRatio = PrnWidth / PrnHeight
'
' Scale the output to the printable area.
'
If PicRatio >= PrnRatio Then
    '
    ' Scale picture to fit full width of printable area.
    '
    PrnPicWidth = Prn.ScaleX(PrnWidth, vbHiMetric, Prn.ScaleMode)
    PrnPicHeight = Prn.ScaleY(PrnWidth / PicRatio, vbHiMetric, Prn.ScaleMode)
Else
    '
    ' Scale picture to fit full height of printable area.
    '
    PrnPicHeight = Prn.ScaleY(PrnHeight, vbHiMetric, Prn.ScaleMode)
    PrnPicWidth = Prn.ScaleX(PrnHeight * PicRatio, vbHiMetric, Prn.ScaleMode)
End If
'
' Print the picture using the PaintPicture method.
'
Call Prn.PaintPicture(Pic, 0, 0, PrnPicWidth, PrnPicHeight)
End Sub


'GEBRUIK:
'Set [Picture].Picture = CaptureScreen()

