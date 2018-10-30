#!/usr/bin/tclsh

# Copyright 2018 nm0i

# Permission  is  hereby  granted,  free  of  charge,  to  any  person
# obtaining a copy of this  catware and associated documentation files
# (the  "Catware"),  to  deal  in  the  Catware  without  restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish,  distribute,  sublicense,  enslave  humanity,  and/or  sell
# copies of the Catware, and to  permit persons to whom the Catware is
# furnished to do so, subject to the following conditions:

# The  above copyright  notice  and this  permission  notice shall  be
# included in all copies or substantial portions of the Catware.

# THE  CATWARE IS  PROVIDED "AS  IS",  WITHOUT WARRANTY  OF ANY  KIND,
# EXPRESS OR IMPLIED,  INCLUDING BUT NOT LIMITED TO  THE WARRANTIES OF
# MERCHANTABILITY,    FITNESS   FOR    A   PARTICULAR    PURPOSE   AND
# NONINFRINGEMENT. IN NO EVENT SHALL  THE AUTHORS OR COPYRIGHT HOLDERS
# OR ANY  CATS BE LIABLE  FOR ANY  CLAIM, DAMAGES OR  OTHER LIABILITY,
# WHETHER IN AN  ACTION OF CONTRACT, TORT OR  OTHERWISE, ARISING FROM,
# OUT  OF OR  IN  CONNECTION WITH  THE  CATWARE OR  THE  USE OR  OTHER
# DEALINGS IN THE CATWARE.

# CONFIG 
set searxURL "http://me0w.net/searx/index.html/"

package require http
package require json

set httpToken [::http::config -urlencoding utf-8]

set query [lindex $argv 0]

proc geomyidaeStrip arg {
	string map {| \\ [ \\ ] \\} $arg
}

proc wordwrap {max msg} {
	if { [string length $msg] > $max } {
		regsub -all "(.{1,$max})( +|$)" $msg "\\1\\3\n" msg
	}
	return $msg
}

puts {[1|To /|/|server|port]}
puts {[7|New search|/searx.dcgi?|server|port]}
puts "Results for $query:"
puts ""

if [catch {
	set httpToken [::http::geturl "${searxURL}?[::http::formatQuery q ${query} format json]"]
	set reply [::json::json2dict [::http::data $httpToken]]
}] {
	puts "Searx query error"
	exit
}

# puts $reply

foreach result [dict get $reply results] {
	if [catch {
		puts "\[h|[geomyidaeStrip [dict get $result title]]|URL:[dict get $result url]|server|port]"
		puts "[wordwrap 72 [geomyidaeStrip [dict get $result content]]]"
	}] {
		puts "Missing data"
	}
	puts ""		
}

puts {[1|To /|/|server|port]}
puts {[h|About searx..|URL:https://github.com/asciimoo/searx|server|port]}
puts "[clock format [clock seconds] -format "%H:%M:%S %Y-%m-%d"]"

