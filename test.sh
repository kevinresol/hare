haxelib dev hare .
(cd /home/travis/haxe/lib/hxcpp/git/tools/hxcpp && haxe compile.hxml)
(cd /home/travis/haxe/lib/hxcpp/git/project && neko build.n clean && neko build.n)
haxelib run lime rebuild lua linux -64 -clean
cd test && haxelib run munit test -neko && haxelib run munit test -cpp
cd ../samples/flixel && haxelib run lime build neko