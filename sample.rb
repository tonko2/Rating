require 'tk'

f = TkFrame.new.pack
lx = TkLabel.new(f, 'relief'=>'ridge', 'width'=>6).pack('side'=>'left')
ly = TkLabel.new(f, 'relief'=>'ridge', 'width'=>6).pack('side'=>'left')

c = TkCanvas.new.pack
c.bind('B1-Motion', proc{|x, y| lx.text( x.to_s ); ly.text( y.to_s )}, "%x %y")

Tk.mainloop
