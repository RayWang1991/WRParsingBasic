WRParsingBasic is A powerful Parser Generator, supporting Earley Parser, LL1 Parser, LR0 Parser and LR1 Parser.

## Features:
- All Context Free Grammar can be parsed (Earley Parser)
- Parser can judge whether a CF grammar with a given input is ambigous
- AST Generation
- Grammar tree and AST can be printed in human-readable dash-style or lisp-style strings

## Earley Parser
- Capable of parsing all Context Free Grammar in o(n3) time
- Generating a Shared-Packed Parse Forest(SPPF)-style Grammar Result
- If the result is tree-style, print it in dash-style or lisp style

e.g.
```
Grammar:
     1. S -> A T | a T
     2. A -> a| B A 
     3. B ->
     4. T -> b b b

Input: a b b b

Parsing result could be:
      0. S -> a T, a T -> a b b b
      1. S -> A T, A T -> B A T, B A T -> A T ... (any number of A T cycle) -> a T -> a b b b
so the result is a forest(many trees), rather than one tree

The Parser will show a message " The result is AMBIGUOUS, with the NODE: A,0,1" and shows one of the possible Grammar tree
S
+-------A
|       +-------a
+-------T
        +-------b
        +-------b
        +-------b
```

## LL1 Parser
- Capable of Parsing LL1 Grammar
- Generate Grammar tree when successful

e.g.
```
- Grammar:
        Goal -> Expr
        Expr -> Term Expr'
        Expr' -> + Term Expr'| - Term Expr' | 
        Term -> Factor Term'
        Term' -> × Factor Term'| ÷ Factor Term' | 
        Factor -> ( Expr )| num | name

- Input: ( name - num ) × ( num ÷ name )

- Results:
Build predict table... done.
The LL1 predict table has no conflicts.

PredictTable:
               ×       ÷       +       -       (       )       num     name    eof
    Goal       e       e       e       e       0       e       0       0       e
    Expr       e       e       e       e       0       e       0       0       e
   Expr'       e       e       0       1       e       2       e       e       2
    Term       e       e       e       e       0       e       0       0       e
   Term'       0       1       2       2       e       2       e       e       2
  Factor       e       e       e       e       0       e       1       2       e

parse done successfully!

Goal
+-------Expr
        +-------Term
        |       +-------Factor
        |       |       +-------(
        |       |       +-------Expr
        |       |       |       +-------Term
        |       |       |       |       +-------Factor
        |       |       |       |       |       +-------name
        |       |       |       |       +-------Term'
        |       |       |       +-------Expr'
        |       |       |               +--------
        |       |       |               +-------Term
        |       |       |               |       +-------Factor
        |       |       |               |       |       +-------num
        |       |       |               |       +-------Term'
        |       |       |               +-------Expr'
        |       |       +-------)
        |       +-------Term'
        |               +-------×
        |               +-------Factor
        |               |       +-------(
        |               |       +-------Expr
        |               |       |       +-------Term
        |               |       |       |       +-------Factor
        |               |       |       |       |       +-------num
        |               |       |       |       +-------Term'
        |               |       |       |               +-------÷
        |               |       |       |               +-------Factor
        |               |       |       |               |       +-------name
        |               |       |       |               +-------Term'
        |               |       |       +-------Expr'
        |               |       +-------)
        |               +-------Term'
        +-------Expr'
 (Goal: (Expr: (Term: (Factor: ( (Expr: (Term: (Factor: name) Term') (Expr': - (Term: (Factor: num) Term') Expr')) )) (Term': × (Factor: ( (Expr: (Term: (Factor: num) (Term': ÷ (Factor: name) Term')) Expr') )) Term')) Expr'))

AST:
×
+--------
|       +-------name
|       +-------num
+-------÷
        +-------num
        +-------name
```

## LR0 Parser & LR1 Parser are also available.   
(For Grammar Power: CF > LR1 > LR0 > LL1)

## For more example, plz see the Demo
   
