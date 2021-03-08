lis(Seq, L) :- % aggregate all possible increasing  subsequence and find the one with largest length  
		aggregate(max(Length,Subseq), (get_subsequence(Seq, [], Subseq), length(Subseq, Length)), max(Length, Subsequence)),
		% reverse the final subsequence into increasing order
		reverse(Subsequence, L).
  
% Base Case
get_subsequence([], Accumulator, Accumulator).
 
% Recursion on each situation
get_subsequence([Head | Tail], Accumulator, Final) :-  Accumulator = [], get_subsequence(Tail, [Head], Final).
get_subsequence([Head | Tail], Accumulator, Final) :-  Accumulator = [Accumulator_head | _], Accumulator_head < Head,   get_subsequence(Tail, [Head | Accumulator], Final).
get_subsequence([_ | Tail], Accumulator, Final) :-  get_subsequence(Tail, Accumulator, Final).
