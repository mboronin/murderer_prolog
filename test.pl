/*
    To run the test suit consult main file and this file and run every single test; or run 'runTests.'
*/
runTests :-
    consult(main),
    test1,
    test2,
    test3,
    test4,
    test5,
    test6,
    test7,
    test8,
    test9,
    test10,
    test11,
    test12,
    nl,
    write('====================================================='),
    nl,
    write('All the given tests succeeded'),
    nl,
    write('======================================================'),
    nl.

runTests :-
    write('====================================================='),
    nl,
    write('Some tests failed'),
    nl,
    write('======================================================'),
    nl.
/*
@descr Initialization function
@date 26/09/2018
*/
init :-
    retractall(clues(X)),
	assert(clues(0)),
    retractall(person(X,Y,Z)),
    retractall(innocent(X,Y,Z)),
    retractall(suspect(X,Y,Z)),
    retractall(murderer(X,Y,Z)),
    retractall(latest(P)),
    generate_people.

/*
@descr test function to get clue
@date 26/09/2018
@expected print a clue
*/
test1 :-
    init,
    select_murderer,
    get_clue.

/*
@descr test function to check if murderer is checked correctly
@date 26/09/2018
@expected win of the game
*/
test2 :-
    init,
    assert(murderer(youngman,yellow,poison)),
    make_guess(person(youngman,yellow,poison)).

/*
@descr test function to check if murderer is checked correctly
@date 26/09/2018
@expected Loss of the game
*/
test3 :-
    init,
    assert(murderer(youngman,yellow,gun)),
    make_guess(person(youngman,yellow,poison)).

/*
@descr test function to check if suspects are printed correctly
@date 26/09/2018
@expected Print 4 clues, 0..4 suspects
*/
test4 :-
    init,
    select_murderer,
    get_clue,
    get_clue,
    get_clue,
    get_clue,
    printSuspects.

/*
@descr test function to check if innocents are printed correctly
@date 26/09/2018
@expected Print 4 clues, 0..4 innocents
*/
test5 :-
    init,
    select_murderer,
    get_clue,
    get_clue,
    get_clue,
    get_clue,
    printInnocents.

/*
@descr test function to check if innocents are printed correctly
@date 26/09/2018
@expected print that no innocents are in the game so far
*/
test6 :-
    init,
    printInnocents.

/*
@descr test function to check if suspects are printed correctly
@date 26/09/2018
@expected print that no suspects are in the game so far
*/
test7 :- 
    init,
    printSuspects.

/*
@descr test function to check exit from the game
@date 26/09/2018
@expected Print murderer, number of tries and exit the game
*/
test8 :-
    init,
    select_murderer,
    exit.

/*
@descr test function to check exit from the game
@date 26/09/2018
@expected Print 3 clues, murderer, number of tries and exit the game
*/
test9 :-
    init,
    select_murderer,
    get_clue,
    get_clue,
    get_clue,
    exit.

/*
@descr test function to check printLatest func
@date 26/09/2018
@expected Print 2 clues, latest clue.
*/
test10 :-
    init,
    select_murderer,
    get_clue,
    get_clue,
    printLatest.

/*
@descr test function to check printLatest func
@date 26/09/2018
@expected Print that no clues has been used.
*/
test11 :-
    init,
    printLatest.

/*
@descr test function to check the case with no clues left
@date 26/09/2018
@expected Print that there are no more clues left
*/
test12 :-
    retractall(clues(X)),
	assert(clues(0)),
    retractall(person(X,Y,Z)),
    retractall(innocent(X,Y,Z)),
    retractall(suspect(X,Y,Z)),
    retractall(murderer(X,Y,Z)),
    retractall(latest(P)),
    get_clue.