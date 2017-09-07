#!/usr/bin/tclsh

package require http
package require json

set searxURL "http://me0w.net/searx/index.html/"

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

puts {[1|Back to the root|/|server|port]}
puts {[7|New search|/searx.dcgi?|server|port]}
puts "------------------------------------------------------------------------"
puts "Search results for $query:"
puts ""

if [catch {
	set httpToken [::http::geturl "${searxURL}?[::http::formatQuery q ${query} format json]"]
	set reply [::json::json2dict [::http::data $httpToken]]
}] {
	puts "Error during query"
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

puts "------------------------------------------------------------------------"
puts {[1|Back to the root|/|server|port]}
puts {[h|More about searx..|URL:https://github.com/asciimoo/searx|server|port]}
puts "[clock format [clock seconds] -format "%H:%M:%S %Y-%m-%d"]"

