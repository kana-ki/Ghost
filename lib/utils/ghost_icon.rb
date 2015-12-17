# require 'Win32API'
# require 'strings'
#
# shell_notify_icon  = Win32API.new('shell32', 'Shell_NotifyIcon', %w(L P), 'I')
# load_icon = Win32API.new('user32', 'LoadImage' ,%w(P P I I I I),'I')
#
# class NotifyIconData < Struct.new(:cbsize, :hwnd, :uid, :uflags, :ucallbackmessage, :hicon)
# end
#
# ico = load_icon.call(nil, 'E:\Development\Live\Ghost\ghost.ico', 1, 0, 0, 0x00000010)
# ico_txt = 'Ghost (0.1.2)'
#
#
# nid = NotifyIconData.new
#
# p nid.cbsize         = Marshal.dump(NotifyIconData).bytesize
# nid.hwnd             = 0
# nid.uid              = 145
# nid.uflags           = 2
# nid.ucallbackmessage = 0
# nid.hicon            = ico
#
# p nid.hicon
#
# # notify_icon_data = [6*4+64, 0, 'ruby'.hash, 2, 0, ico].pack('LLIIIL') << tiptxt << "\0"*(64 - tiptxt.size)
# # icon_data = NotifyIconData.new(6*4+64, 0, 'ruby')
# if shell_notify_icon.call(0x00000000, nid.values.pack('LLIIIL')) == 0
#   puts('Proper fucked')
# end

require 'Win32API'

RT_ICON         =  3
DIFFERENCE      = 11
RT_GROUP_ICON   = RT_ICON + DIFFERENCE

NIF_MESSAGE = 1
NIF_ICON    = 2
NIF_TIP     = 4
NIM_ADD     = 0
NIM_MODIFY  = 1
NIM_DELETE  = 2


ExtractIcon       = Win32API.new('shell32',  'ExtractIcon',       'LPI',
                                 'L')
Shell_NotifyIcon  = Win32API.new('shell32',  'Shell_NotifyIconA', 'LP',
                                 'I')


hicoY = ExtractIcon.call(0, 'C:\WINDOWS\SYSTEM\INETCPL.CPL', 21)  # Green tick
hicoN = ExtractIcon.call(0, 'C:\WINDOWS\SYSTEM\INETCPL.CPL', 22)  # Red minus

tiptxt = 'test icon (ruby)'
pnid = [6*4+64, 0, 'ruby'.hash, NIF_ICON | NIF_TIP, 0,
        hicoY].pack('LLIIIL') <<
    tiptxt << "\0"*(64 - tiptxt.size)
ret = Shell_NotifyIcon.call(NIM_ADD, pnid)
p 'Err: NIM_ADD' if ret == 0

sleep(3)   #  <----<<

pnid = [6*4+64, 0, 'ruby'.hash, NIF_ICON | NIF_TIP, 0,
        hicoN].pack('LLIIIL') <<
    tiptxt << "\0"*(64 - tiptxt.size)
ret = Shell_NotifyIcon.call(NIM_MODIFY, pnid)
p 'Err: NIM_MODIFY' if ret == 0

sleep(6)   #  <----<<

pnid = [6*4+64, 0, 'ruby'.hash, 0, 0, 0].pack('LLIIIL') << "\0"*64
ret = Shell_NotifyIcon.call(NIM_DELETE, pnid)
p 'Err: NIM_DELETE' if ret == 0