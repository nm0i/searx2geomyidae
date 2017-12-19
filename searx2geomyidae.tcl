#!/usr/bin/tclsh

# CONFIG

set searxURL "http://me0w.net/searx/index.html/"

# CONFIG END

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

