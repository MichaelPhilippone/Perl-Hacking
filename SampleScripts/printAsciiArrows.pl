sub print_stuff {
	($l, $m , $dir , $count , @argv ) = @_;
	
	if($count <= 0) { return; }
	
	if( $dir =~ /^up$/i ) {
		if( $l <= 0 ) { 
			$dir = 'down';
			$count--;
		}
		else { 
			print "*" x $l." "."*" x $m." "."*" x $m." "."*" x $l."\n" if ( $m > 0 );
		}
		$l--;
		$m++;
	}
	else {
		if( $m <= 0 ) { 
			print "*" x ($l)." "."*"." "."*" x ($l)."\n"; 
			$dir = 'up';
			$count--;
		}
		else { 
			print "*" x $l . " " . "*" x $m . " ". "*" x $m . " " . "*" x $l . "\n" if ( $l > 0 );
		}
		$l++;
		$m--;
	}	
	print_stuff ( $l , $m , $dir , $count);
}

print_stuff (10, 1 , 'up' , 2 );
print_stuff (1, 10 , 'down' , 2 );