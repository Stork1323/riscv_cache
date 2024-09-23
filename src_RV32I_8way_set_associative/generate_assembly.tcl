for {set i 0} {$i < 100} {incr i} {
	set rand_nu [expr int([expr rand() * 1000]) % 64 * 4]	
	set x [expr int([expr rand() * 1000]) % 10]
	puts "sw x$x, $rand_nu\(x0\)"
}
