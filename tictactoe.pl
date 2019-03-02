my ($dirty, $finished) = (0, 0);
my ($turn, $stepper) = (1, 1);
my ($board, @moves) = ("123456789", ("123456789"));

sub hasWon{
    foreach my $x (("123", "456", "789", "147", "258", "369", "159", "357")){
       my $tmp = 0;
       foreach my $y(split //, $x){
          $tmp = ((split //, $board)[$y-1] eq (($turn == 1) ? "X" : "O")) ? $tmp += 1 : $tmp;
          if($tmp == 3){
	      printBoard();
	      print "\n\nPlayer " . $turn . " (" . (($turn == 1) ? "X" : "O") . ") " . "has won\n";
	      return $finished = 1;
          }
       }
   }
   $finished = ($stepper == 9) ? return (print "Draw!\n", $finished = 1) : $finished;
}
sub printBoard{
    my $count = 1;
    foreach (split //, $board){
        print $_ . " | ";
        if ($count ~~ [3,6,9]){
	   print "\n-----------\n";
	}
	$count++;
    }
}
sub isMoveValid{
    my $newS = ($turn == 1) ? "X" : "O";
    if ((split//,$board)[@_[0]-1] ~~ ["X", "O"]){
        print "\nInvalid Move\n";
	return $dirty = 1, $board;
    }
    $board =~ s/${_[0]}/${newS}/;
    hasWon($board);
    @moves[$stepper] = $board;
    $stepper += 1;   
    return $board;
}
sub makeMove{
    $dirty = 0;
    printBoard();
    print "\nEnter the square number (undo - u): ";
    chomp (my $inp = <STDIN>);    
    if($inp ~~ ["u","1","2","3","4","5","6","7","8","9"]){
        if ($inp eq "u"){
            if($stepper==1){
                print "\nCannot return to a state which does not exist...\n";
                return $dirty = 1;;
	    }
	    return undoMove();
         }
        return isMoveValid($inp);   
    }
    print "\nPlease enter a valid number input\n";
    $dirty = 1;
}
sub undoMove{
    $board = @moves[$stepper-2];
    @moves[$stepper] = "";
    $stepper -= 1;
}
while(!$finished){
    print "\nWelcome Player " . $turn . "! " . (($turn == 1) ? "X" : "0"). "\n\n" ;
    makeMove($turn);
    $dirty = ($dirty == 1) ? next : 0;
    $turn = ($turn == 1) ? 2 : 1;
}
