require 'projector'
require 'rubygems'
require 'fox16'
include Fox

IPs = File.read("C:\\Program Files\\Spectrum Sound\\ips.txt").split

def execute(sym)
  IPs.each do |ip|
    eval "#{sym}(\"#{ip}\",\"Administrator\",\"\")"
  end
end

# Setup App/Main Window
theApp = FXApp.new
theMainWindow = FXMainWindow.new(theApp, "Spectrum Sound Projector Control")

# Create Menu Bar
menuBar = FXMenuBar.new(theMainWindow, LAYOUT_SIDE_TOP|LAYOUT_FILL_X)

# File Menu
fileMenu = FXMenuPane.new(menuBar)
FXMenuCommand.new(fileMenu,"E&xit").connect(SEL_COMMAND) do
  exit
end
FXMenuTitle.new(menuBar, "&File", nil, fileMenu, LAYOUT_LEFT)

# Help Menu
helpMenu = FXMenuPane.new(menuBar)
FXMenuCommand.new(helpMenu,"&About Projector Control...").connect(SEL_COMMAND) do
  FXMessageBox.information(theApp,MBOX_OK,"About","Projector Controll v0.1\nSpectrum Sound Inc., 2007\nhttp://www.spsound.net")
  theMainWindow.setFocus
end
FXMenuTitle.new(menuBar, "&Help", nil, helpMenu, LAYOUT_RIGHT)

# Insert Separator
FXSeparator.new(theMainWindow, :opts => SEPARATOR_GROOVE|LAYOUT_FILL_X, :padLeft => 5, :padRight => 5).show

# Create Matrix For Labels
labelMatrix = FXMatrix.new(theMainWindow, 3,
                                    LAYOUT_SIDE_TOP|FRAME_NONE|LAYOUT_FILL_Y|LAYOUT_FILL_X|PACK_UNIFORM_WIDTH)

def sayHi(*args)
  puts "Hi! #{args[2]}"
end

# Add Labels
FXLabel.new(labelMatrix, "Power")
FXLabel.new(labelMatrix, "Blank")
FXLabel.new(labelMatrix, "Freeze")
powerOn = FXButton.new(labelMatrix,"On")
  powerOn.tipText = "Turn all projectors on."
  powerOn.connect(SEL_COMMAND){ execute :power_on }
blankOn = FXButton.new(labelMatrix,"On")
  blankOn.tipText = "Blank all projectors out."
  blankOn.connect(SEL_COMMAND){ execute :blank_on }
freezeOn =FXButton.new(labelMatrix,"On")
  freezeOn.tipText = "Freeze the current image on all projectors."
  freezeOn.connect(SEL_COMMAND){ execute :freeze_on }
powerOff = FXButton.new(labelMatrix,"Off")
  powerOff.tipText = "Turn all projectors off."
  powerOff.connect(SEL_COMMAND){ execute :power_off }
blankOff = FXButton.new(labelMatrix,"Off")
  blankOff.tipText = "Unblank all projectors."
  blankOff.connect(SEL_COMMAND){ execute :blank_off }
freezeOff = FXButton.new(labelMatrix,"Off")
  freezeOff.tipText = "Show live image on all projectors."
  freezeOff.connect(SEL_COMMAND){ execute :freezeOff }

FXToolTip.new(theApp)


# Create App/Main Window
theApp.create
theMainWindow.show(PLACEMENT_SCREEN)
theApp.run
