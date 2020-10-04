VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CMsgBox"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Class      : CMsgBox
' Description: Wrapper class to simplify using Message Boxes
' Source     : Total VB SourceBook 6
' Update     : Code Service Pack 1
' Enumerated type for icons
Public Enum EnumMBIcon
  icoCritcal = 16
  icoQuestion = 32
  icoExclamation = 48
  icoInformation = 64
End Enum
    
' Enumerated type for button combinations
Public Enum EnumMBButton
  btnOKOnly = 0
  btnOKCancel = 1
  btnOKAbortRetryIgnore = 2
  btnYesNoCancel = 3
  btnYesNo = 4
  btnRetryCancel = 5
End Enum

' Enumerated type for the default button
Public Enum EnumMBDefaultButton
  dfButton1 = 0
  dfButton2 = 256
  dfButton3 = 512
  dfButton4 = 768
End Enum

' Enumerated type for the modal mode
Public Enum EnumMBModal
  mbNotModal = 0
  mbApplicationModal = 0
  mbSystemModal = 4096
End Enum

' Enumerated type for the return value
Public Enum EnumMBResponse
  mbReturnOK = 1
  mbReturnCancel = 2
  mbReturnAbort = 3
  mbReturnRetry = 4
  mbReturnIgnore = 5
  mbReturnYes = 6
  mbReturnNo = 7
End Enum

' Private variables to maintain property values
Private m_lngIcon As Long
Private m_lngButtons As Long
Private m_lngDefaultButton As Long
Private m_lngModal As Long
Private m_lngHelpContextID As Long
Private m_strHelpFile As String
Private m_fSetForeground As Boolean
Private m_fRightAligned As Boolean
Private m_strTitle As String
Private m_lngResponse As Long
Private m_strMessage As String

Public Property Get Buttons() As EnumMBButton
  ' Returns: The current setting of the Buttons property
  ' Source : Total VB SourceBook 6
  '
  Buttons = m_lngButtons
  
End Property

Public Property Let Buttons(eValue As EnumMBButton)
  ' eValue: The buttons to show, as defined by the EnumMBButton
  '         enumerated type.
  ' Source: Total VB SourceBook 6
  '
  m_lngButtons = eValue
  
End Property

Public Property Get DefaultButton() As EnumMBDefaultButton
  ' Returns: The current Default button setting
  ' Source : Total VB SourceBook 6
  '
  DefaultButton = m_lngDefaultButton
  
End Property

Public Property Let DefaultButton(eValue As EnumMBDefaultButton)
  ' eValue: Sets the default button as defined by the EnumMBDefaultButton
  '         enumerated type
  ' Source: Total VB SourceBook 6
  '
  m_lngDefaultButton = eValue
  
End Property

Public Property Get Foreground() As Boolean
  ' Returns: The current Foreground setting
  ' Source : Total VB SourceBook 6
  '
  Foreground = m_fSetForeground
  
End Property

Public Property Let Foreground(fValue As Boolean)
  ' fValue: True to have the message box appear in the foreground
  ' Source: Total VB SourceBook 6
  '
  m_fSetForeground = fValue
  
End Property

Public Property Get HelpContextID() As Long
  ' Returns: The current help context id setting
  ' Source : Total VB SourceBook 6
  '
  HelpContextID = m_lngHelpContextID
  
End Property

Public Property Let HelpContextID(lngValue As Long)
  ' lngValue: Help context id for the help file, if the HelpFile
  '           property is set.
  ' Source  : Total VB SourceBook 6
  '
  m_lngHelpContextID = lngValue
  
End Property

Public Property Get HelpFile() As String
  ' Returns: The current help file setting
  ' Source : Total VB SourceBook 6
  '
  HelpFile = m_strHelpFile
  
End Property

Public Property Let HelpFile(strValue As String)
  ' strValue: Sets the name (path optional) of the help file to use
  ' Source  : Total VB SourceBook 6
  '
  m_strHelpFile = strValue
  
End Property

Public Property Get Icon() As EnumMBIcon
  ' Returns: The current icon setting
  ' Source : Total VB SourceBook 6
  '
  Icon = m_lngIcon
  
End Property

Public Property Let Icon(eValue As EnumMBIcon)
  ' eValue: Sets the icon to use as defined by the EnumMBIcon
  '         enumerated type
  ' Source: Total VB SourceBook 6
  '
  m_lngIcon = eValue
  
End Property

Public Property Get Message() As String
  ' Returns: The current setting of the Message property
  ' Source : Total VB SourceBook 6
  '
  Message = m_strMessage
  
End Property

Public Property Let Message(strValue As String)
  ' strValue: Value for the message box message text
  ' Source  : Total VB SourceBook 6
  '
  m_strMessage = strValue
  
End Property

Public Property Get Modal() As EnumMBModal
  ' Returns: The current modal setting
  ' Source: Total VB SourceBook 6
  '
  Modal = m_lngModal
  
End Property

Public Property Let Modal(eValue As EnumMBModal)
  ' eValue: Sets the modal mode for the message box as defined by the
  '         EnumMBModal enumerated type
  ' Source: Total VB SourceBook 6
  '
  m_lngModal = eValue
  
End Property

Public Property Get Response() As EnumMBResponse
  ' Returns: The user response to the message box as defined by the
  '          EnumMBResponse enumerated type.
  ' Source : Total VB SourceBook 6
  '
  Response = m_lngResponse

End Property

Public Property Get RightAligned() As Boolean
  ' Returns: The current RightAligned setting
  ' Source : Total VB SourceBook 6
  '
  RightAligned = m_fRightAligned
  
End Property

Public Property Let RightAligned(fValue As Boolean)
  ' fValue: True to right align the message box, False to center
  ' Source: Total VB SourceBook 6
  '
  m_fRightAligned = RightAligned
  
End Property

Public Property Get Title() As String
  ' Returns: The current Title setting
  ' Source : Total VB SourceBook 6
  '
  Title = m_strTitle
  
End Property

Public Property Let Title(strValue As String)
  ' strValue: The title for the message box
  ' Source  : Total VB SourceBook 6
  '
  m_strTitle = strValue
  
End Property

Public Sub Show()
  ' Comments  : Shows the message box with the current options
  ' Parameters: None
  ' Returns   : Nothing
  ' Source    : Total VB SourceBook 6
  '
  Dim lngOptions As Long
  
  On Error GoTo PROC_ERR
  
  ' Build the options value
  lngOptions = m_lngIcon + m_lngDefaultButton + m_lngModal + m_lngButtons
  
  ' Check the Right aligned value
  If m_fRightAligned Then
    lngOptions = lngOptions + vbMsgBoxRight
  End If
  
  ' If the HelpFile property is not blank, add a help button
  If m_strHelpFile <> "" Then
    lngOptions = lngOptions + vbMsgBoxHelpButton
  End If
  
  m_lngResponse = MsgBox(Prompt:=m_strMessage, Buttons:=lngOptions, _
    Title:=m_strTitle, HelpFile:=m_strHelpFile, Context:=m_lngHelpContextID)
     
PROC_EXIT:
  Exit Sub
  
PROC_ERR:
  MsgBox "Error: " & Err.Number & ". " & Err.Description, , _
    "Show"
  Resume PROC_EXIT
     
End Sub


' Example code for the CMsgBox class
'
' To use this example:
' 1. Create a new form.
' 2. Create a command button called cmdShow
' 3. Paste the entire contents of this module into the
'    new form's module.
'
'Private Sub cmdShow_Click()
  'Dim MsgTest As CMsgBox
 ' Dim strRet As String
  
  ' Instantiate the class
  'Set MsgTest = New CMsgBox
  
  ' Set the message box properties
  'MsgTest.Title = "My Message Box"
  ''MsgTest.Icon = icoInformation
 ' MsgTest.Buttons = btnOKCancel
 ' MsgTest.DefaultButton = dfButton1
 ' MsgTest.Modal = mbApplicationModal
 ' MsgTest.HelpFile = "Windows.hlp"
 ' MsgTest.HelpContextID = 1000
  'MsgTest.Message = "This is a test."
  
  ' Show the message box
 ' MsgTest.Show
  
  ' Determine the response
'  Select Case MsgTest.Response
  
'    Case mbReturnOK
 '     strRet = "OK"
'    Case mbReturnCancel
'      strRet = "Cancel"
'    Case mbReturnAbort
'      strRet = "Abort"
 '   Case mbReturnRetry
 '     strRet = "Retry"
'    Case mbReturnIgnore
'      strRet = "Ignore"
 '   Case mbReturnYes
 '     strRet = "Yes"
'    Case mbReturnNo
 '     strRet = "No"
      
'  End Select
  
'  Debug.Print "The example returned: " & strRet
  
'  Set MsgTest = Nothing
  
'End Sub


