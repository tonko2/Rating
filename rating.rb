# -*- coding: utf-8 -*-
require 'tk'

#FileName
$FName = "result.txt"

#FNameに入ってる番号や成績
$number = Array.new
$grade = Array.new

$dd = ""

#ListBoxの指すポインタ
$Pointer

$keep_flag = 0

#ListBoxの今のポインタ
$NowPointer = Array.new
$NowPointer.push(0)

#今選んでるファイル
$selectedFile = "null"

#メーリスファイルを入れる配列
$List = Array.new

#ウィンドウのサイズ
root = TkRoot.new{
  title '採点ツール'
  geometry '930x600'
}



#ボタンを整えてるフレーム
f1 = TkFrame.new(root){
  pady 20
  padx 10
  pack 'side'=>'left','fill'=>'y'
}



#コンパイル、実行結果を表示するフレーム
f2 = TkFrame.new(root){
  pady 45
  pack 'side' => 'left', 'fill' => 'y'
}

f2.place('x' => 230,'y' => 30,'height' => 500,'width' => 320)

#ソースを表示するフレーム
f3 = TkFrame.new(root){
  pady 45
  pack 'side' => 'left', 'fill' => 'y'
}

f3.place('x' => 600,'y' => 30,'height' => 500,'width' => 320)

L1 = TkLabel.new(root){
  text 'メーリスファイル: Null'
  pack
}

L2 = TkLabel.new(root){
  text 'ディレクトリ　　: Null'
  pack
}

L3 = TkLabel.new(root){
  text '実行結果'
  pack
}

L4 = TkLabel.new(root){
  text 'ソース'
  pack
}

L1.place('x' => 275, 'y' => 15)
L2.place('x' => 275, 'y' => 32)
L3.place('x' => 355, 'y' => 52)
L4.place('x' => 710, 'y' => 52)

#f2のスクロールバー
scr = TkScrollbar.new(f2){
  pack('fill'=>'y' , 'side'=>'right')
}

#コンパイル、実行結果を表示するテキストエリア
text = TkText.new(f2){
  width 45
  borderwidth 1
  yscrollbar(scr)
  state 'disabled'
  pack("fill"=>"y","side" => "left")
}

#f3のスクロールバー
scr2 = TkScrollbar.new(f3){
    pack('fill'=>'y', 'side'=>'right')
}

#ソースを表示するテキストエリア
text2 = TkText.new(f3){
  width 55
  borderwidth 1
  yscrollbar(scr2)
  state 'disabled'
  pack("fill"=>'y',"side" => "right")
}

#Student $Listと表示するラベル
l2 = TkLabel.new(f1){
  text "学籍番号 / 成績"
  pack
}

#ListBox
$li = TkListbox.new(f1){
  height 14
  width 25
  pack 'fill' => 'y'
}

#0~6までボタン
b = TkButton.new(f1){
  text 'メーリス読み込み(m)'
  command proc{
    file = Tk.getOpenFile
    if file != "" then
      $List.clear
      open(file){|f|
        while l = f.gets
          $List.push(l)
        end
      }
      L1.text = "メーリスファイル: " + file
    end
  }
  pack 'fill' => 'both'
}

b2 = TkButton.new(f1){
  text '読み込み(r)'
  command proc{
    if L2.text == "ディレクトリ　　: Null" then
      text.state = 'normal'
      text.insert 'end', "ディレクトリを選択してください\n"
      text.state = 'disabled'
      break
    end
    $number.clear
    $grade.clear
    a = L2.text.split(" ");
    a1 = a[1]
    a2 = a1 + "/"+$FName
    $li.clear
    tmp = `cat #{a2}`
    if File.exist?(a2) && tmp.size != 0then 
      readResult(a2)
    else 
      createResult(a2)
    end
    $li.focus

    if $li.size != 0 then
      $Pointer = 0
      $keep_flag = 1
    end


  }
  #  pack 'fill' => 'both'
}


b1 = TkButton.new(f1){
  text 'ディレクトリ選択(d)'
  command proc{
    $dd = Tk.chooseDirectory
    if $dd != "" then 
      L2.text = "ディレクトリ　　: " + $dd
      b2.invoke

    end

    # $scroll = TkScrollbar.new(root){
    #   pack('fill'=>'y' , 'side'=>'right')
    # }

  
  }
  pack 'fill' => 'both'
}

def writeFile(name,dir,point)
  $li.insert('end',"#{name}       #{point}") 
  File.open(dir,"w") do |f|
    f.write("#{name} #{point}")
  end
end

def createResult(file)
  File.open(file,"w") do |f|
    for i in 0..$List.length-1
      tmp = $List[i]
      tmp = tmp.chomp
      $li.insert('end',"#{tmp}       0") 
      f.write(tmp+" 0\n")
    end
  end
end

def readResult(file)
  open(file){|f|
    while l = f.gets
      tmp = Array.new
      tmp = l.split(" ")
      $number.push(tmp[0])
      $grade.push(tmp[1])
    end
  }
  
  system("cat /dev/null > #{file}")
  
  File.open(file,"w") do |f|
    for i in 0..$List.length-1
      tmp = $List[i]
      tmp = tmp.chomp 
      
      for j in 0..$number.length-1
        if $number[j] == tmp then 
          $li.insert('end',"#{tmp}       #{$grade[j]}") 
          f.write(tmp+" "+$grade[j]+"\n")
          break
        end 
      end
    end 
  end
end

def Update(file,name,point)
  open(file){|f|
    while l = f.gets
      tmp = Array.new
      tmp = l.split(" ")
      if tmp[0] == name then tmp[1] = point end
        $number.push(tmp[0])
        $grade.push(tmp[1])
    end
  }
  
  system("cat /dev/null > #{file}")
  
  File.open(file,"w") do |f|
    for i in 0..$List.length-1
      tmp = $List[i]
      tmp = tmp.chomp 
      
      for j in 0..$number.length-1
        if $number[j] == tmp then 
          # $li.insert('end',"#{tmp}       #{$grade[j]}") 
          f.write(tmp+" "+$grade[j]+"\n")
          break
        end 
      end
    end 
  end
end



b3 = TkButton.new(f1){
  text 'コンパイル&実行&ソース(c)'
  command proc {
    text.state = 'normal'
    text2.state = 'normal'
    text.value = ""
    text2.value = ""
    $li.curselection.each{ |i| $selectedFile = "#{$li.get(i)}"}
    
    if $selectedFile == "null" then
    else    
      $selectedFile = $selectedFile.split(" ")
      $selectedFile = $selectedFile[0]
      $selectedFile = $selectedFile.chomp
      $selectedFile = $dd+"/"+$selectedFile + "." + $e3.value
      system("cat /dev/null > compile_result.txt")

      system("#{$e4.value} #{$selectedFile} 2> compile_result.txt")

      tmp = `cat compile_result.txt`

      if tmp == "" then
        # text.insert 'end', "コンパイル成功\n"
        flag = 0
        open($selectedFile){|f|
             while line = f.gets
               pos = line.include?("scanf")
               if pos then 
                 flag = 1
               end
             end
           }

        if $e5.value == "./a.out" && flag == 1 then
          text.insert 'end', "scanfが発見されました。リダイレクトにしてください。"
        else
          tmp = `#{$e5.value}`
          text.insert 'end',tmp
        end
      else
        text.insert 'end',tmp
      end

      if File.exist?($selectedFile) then
        tmp = `cat #{$selectedFile}`
        text2.insert 'end', tmp
      else
        text2.insert 'end', "ファイルがありません"
      end
      
    end
    text.state = 'disabled'
    text2.state = 'disabled'
    $li.focus

  }
#  pack "fill" => "both"
}



b4 = TkButton.new(f1){
  text '終了(q)'
  command proc {exit}
  pack 'fill'=>'both'
}

b5 = TkButton.new(f1){
  text "決定"
  command proc{
    keep

    $Pointer = $li.curselection
    $number.clear
    $grade.clear
    # $li.clear

    a = L2.text.split(" ");
    a1 = a[1]
    if a1 != "Null" then
      a2 = a1 + "/"+$FName
      Update(a2,$e1.value,$e2.value)

      tmp = $li.get($Pointer)
      $li.delete($Pointer)
      $li.insert($Pointer,$e1.value+"       "+$e2.value)
      
      keep

    end
  }
  pack
}

b5.place('x' => 150, 'y' => 370, 'width' => 50)



$e1 = TkEntry.new(f1){
  pack
}

$e2 = TkEntry.new(f1){
  bind 'FocusIn', proc {selection_range(0, 'end')}

  pack
}

$e3 = TkEntry.new(f1){
  pack
}

$e3.value = "c"

$e4 = TkEntry.new(f1){
  pack
}

$e4.value = "gcc"

$e5 = TkEntry.new(f1){
  pack
}

$e5.value = "./a.out"

label1 = TkLabel.new(f1){
  text "学籍番号"
  pack
}

label2 = TkLabel.new(f1){
  text "点数"
  pack
}

label3 = TkLabel.new(f1){
  text "拡張子 :"
  pack
}

label4 = TkLabel.new(f1){
  text "コンパイルコマンド"
  pack 
}

label5 = TkLabel.new(f1){
  text "実行コマンド"
  pack
}



label1.place('x' => 27, 'y' => 345)
label2.place('x' => 110, 'y' => 345)
label3.place('x' => 10, 'y' => 420)
label4.place('x' => 27, 'y' => 455)
label5.place('x' => 50, 'y' => 510)
$e1.place('x' => 10, 'y' => 370, 'width' => 90)
$e2.place('x' => 100, 'y' => 370, 'width' => 50)
$e3.place('x' => 70, 'y' => 420, 'width' => 80)
$e4.place('x' => 10, 'y' => 480, 'width' => 170)
$e5.place('x' => 10, 'y' => 540, 'width' => 170)

def display
  tmp = ""
  $li.curselection.each{ |i| tmp = "#{$li.get(i)}"}
  if tmp != "" then
    $li.curselection.each{ |i| $selectedFile = "#{$li.get(i)}"}
    files = $selectedFile.split(" ")
    file = files[0]
    point = files[1]
    $e1.value = file
    $e2.value = point
    $NowPointer = $li.curselection
     if $keep_flag == 1
       $Pointer = $li.curselection
       $li.selection_set($Pointer)
       $li.focus
       $li.activate($Pointer)
     end
  end
end

def foo
  if $NowPointer != "" then 
    $li.activate($NowPointer)
    $li.selection_set($NowPointer)
  end
end

  $scroll = TkScrollbar.new(root) do
      orient 'vertical'
      place('height' => 216, 'x' => 214, 'y' => 35)
    end
    
    $li.yscrollcommand(proc {|*args|
                         $scroll.set(*args)
                       })
    
    $scroll.command(proc{|*args| $li.yview(*args)})

def keep
  if $keep_flag == 1
    $li.selection_set($Pointer)
    $li.focus
    $li.activate($Pointer)
  end
end

Tk.root.bind('m',proc{b.invoke})
Tk.root.bind('d',proc{b1.invoke})
#Tk.root.bind('r',proc{b2.focus; b2.invoke})
#Tk.root.bind('c',proc{b3.focus; b3.invoke})
Tk.root.bind('q',proc{b4.invoke})
Tk.root.bind('Return',proc{b5.invoke})
Tk.root.bind('Up', proc{display; b3.invoke})
Tk.root.bind('Down', proc{display; b3.invoke})
Tk.root.bind('slash',proc{$e2.focus})
$li.bind('ButtonRelease',proc{display;b3.invoke})
# Tk.root.bind('ButtonRelease',proc{keep})
Tk.root.bind('Double-ButtonPress-1' , proc{foo})
Tk.mainloop
