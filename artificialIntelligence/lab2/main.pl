insert_sort([], []).
insert_sort([H | T], Sorted) :-
    insert_sort(T, [H], Sorted).
insert_sort([], Sorted, Sorted).
insert_sort([H | T], Progress, Sorted) :- 
    insert(H, Progress, MoreProgress),
    insert_sort(T, MoreProgress, Sorted).
insert(X, [], [X]).
insert(X, [H | T], Inserted) :- 
    H < X ->
        insert(X, T, SubInserted),
        Inserted = [H | SubInserted]
    ;
        Inserted = [X, H | T].
